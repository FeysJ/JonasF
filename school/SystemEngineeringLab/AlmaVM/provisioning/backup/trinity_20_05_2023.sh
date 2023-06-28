#! /bin/bash
#
# Provisioning script for srv001

#------------------------------------------------------------------------------
# Bash settings
#------------------------------------------------------------------------------

# Enable "Bash strict mode"
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't mask errors in piped commands

#------------------------------------------------------------------------------
# Variables
#------------------------------------------------------------------------------

# Location of provisioning scripts and files
export readonly PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
export readonly PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/files/${HOSTNAME}"
#hostname
naam="trinity"
#ip address server
ipadres="192.168.168.131"
#DNS ip
DNS="192.168.168.130"
#Gateway ip
Gateway="192.168.168.129"
# Database root password
readonly db_root_password='ChangeMe'
# Database name
readonly db_name=selgroept02
# Database table
readonly db_table=selgroept02_tbl
# Database user
readonly db_user=www_user
# Database password
readonly db_password='PleaseChangeMe'
ssh_locatie="/home/vagrant/.ssh"

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

# Predicate that returns exit status 0 if the database root password
# is not set, a nonzero exit status otherwise.
is_mysql_root_password_empty() {
  mysqladmin --user=root status > /dev/null 2>&1
}


#------------------------------------------------------------------------------
# "Imports"
#------------------------------------------------------------------------------

# Actions/settings common to all servers
source ${PROVISIONING_SCRIPTS}/common.sh

#------------------------------------------------------------------------------
# Provision server
#------------------------------------------------------------------------------

log "Starting server specific provisioning tasks on ${HOSTNAME}"

# TODO: insert code here, e.g. install Apache, add users, etc.


# change hostname
log "change hostname to $naam and set IP configuration"
hostnamectl set-hostname $naam

sed -i -r "s/NETMA.*/NETMASK=255.255.255.240/" /etc/sysconfig/network-scripts/ifcfg-eth1



#DNS
sh -c 'echo "[Resolve]" > /etc/systemd/resolved.conf && echo "DNS=192.168.168.130" >> /etc/systemd/resolved.conf && echo "FallbackDNS=8.8.8.8" >> /etc/systemd/resolved.conf'

systemctl restart NetworkManager

# ++++++++++++
# Installation Webserver and settings
# ++++++++++++

log "updaten packages and install nginx"
#dnf update -y
dnf install nginx -y

log "enable nginx and add firewall rules"
systemctl enable --now nginx
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
#Matrix.org Federation port
#firewall-cmd --permanent --add-port=8448/tcp
#semanage port -a -t http_port_t -p tcp 8448
setsebool -P httpd_can_network_relay 1
setsebool -P httpd_can_network_connect 1
setsebool -P httpd_graceful_shutdown 1
setsebool -P nis_enabled 1
firewall-cmd --reload


log "self signed certificates creation"

dnf install openssl -y
log "Map voor ssl-certificaten aanmaken als deze nog niet bestaat."
mkdir -p /etc/ssl/private

# aanmaken van de certificaten zelf
openssl req -newkey rsa:4096  -x509  -sha512  -days 365 -nodes -out /etc/ssl/certs/nginx-selfsigned.crt -keyout /etc/ssl/private/nginx-selfsigned.key -subj '/CN=thematrix.local'


cp /etc/nginx/nginx.conf /etc/nginx/nginx_backup.conf # backup van bestaande config file 


#versienummer nginx verbergen

log "hide nginx version number"
# 29i is toevoegen op lijn 29
# testen met: nmap -sV -p 80 192.168.168.131
sed -i "29i server_tokens off;" /etc/nginx/nginx.conf

systemctl restart nginx

# ++++++++++++
# Installation of database
# ++++++++++++

#source ${PROVISIONING_SCRIPTS}/database.sh

log "Installing MariaDB server"

dnf install -y mariadb-server 

log "Enabling MariaDB service"

systemctl enable --now mariadb.service

log "Setting firewall rules"

firewall-cmd --add-service=mysql --permanent
firewall-cmd --reload

log "Securing the database"

if is_mysql_root_password_empty; then
mysql <<_EOF_
  SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${db_root_password}');
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
  FLUSH PRIVILEGES;
_EOF_
fi

log "Creating database and user"

mysql --user=root --password="${db_root_password}" << _EOF_
CREATE DATABASE IF NOT EXISTS ${db_name};
GRANT ALL ON ${db_name}.* TO '${db_user}'@'%' IDENTIFIED BY '${db_password}';
FLUSH PRIVILEGES;
_EOF_

systemctl restart mariadb

# ++++++++++++
# Installation of CMS
# ++++++++++++
log "Installing wordpress CMS"

dnf install php php-curl php-bcmath php-gd php-soap php-zip php-curl php-mbstring php-mysqlnd php-gd php-xml php-intl php-zip zip -y

log "Change php-fpm configuration for nginx"

systemctl enable --now php-fpm
sed -i 's/user =.*/user = nginx/' /etc/php-fpm.d/www.conf
sed -i 's/group =.*/group = nginx/' /etc/php-fpm.d/www.conf

systemctl restart php-fpm

log "download wordpress and place in the correct directory"
wget -P /usr/share/nginx/html  https://wordpress.org/latest.zip 
unzip /usr/share/nginx/html/latest.zip -d /usr/share/nginx/html/

cp /usr/share/nginx/html/wordpress/wp-config-sample.php /usr/share/nginx/html/wordpress/wp-config.php

sed -i -r "s/'database_name_here'/ \x27${db_name}\x27/" /usr/share/nginx/html/wordpress/wp-config.php
sed -i -r "s/'username_here'/ \x27${db_user}\x27/" /usr/share/nginx/html/wordpress/wp-config.php
sed -i -r "s/'password_here'/ \x27${db_password}\x27/" /usr/share/nginx/html/wordpress/wp-config.php

log "adjust permissions for wordpress files"

#Change permisions Nginx

chown -R nginx:nginx /usr/share/nginx/html
chmod -R 775 /usr/share/nginx/html

#TODO root nog wijzigen in /etc/nginx/nginx.conf
# sed -i -r "s|/usr/share/nginx/html;|/usr/share/nginx/html/wordpress;|" /etc/nginx/nginx.conf


log "make confuguration file for wordpress website"

sed -i '39,84d' /etc/nginx/nginx.conf

### geen andere manier gevonden om deze variabelen in de file tr krijgen, krees steeds de error dat de variabele unbound is.
uris='$uri'
arg='$args'
doc='$document_root'
fast='$fastcgi_script_name'
prox='$proxy_add_x_forwarded_for'
ht='$http_host'
server_name=theoracle.thematrix.local
theoracle_link_ip="http://192.168.168.133:8008"

cat << EOF | tee -a /etc/nginx/nginx.conf
server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name thematrix.local www.thematrix.local;
    root /usr/share/nginx/html/wordpress;
    include /etc/nginx/default.d/*.conf;
    index index.php index.html index.htm;
    listen 443 ssl http2; #https en http/2
    listen [::]:443 ssl http2; #https en http/2       
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt; # locatie certs
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key; # locatie certs

    error_page 404 /404.html;
    location = /404.html {
    }

    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
    }

    location / {
    try_files $uris $uris/ /index.php?$arg;
    }

    location = /favicon.ico {
    log_not_found off;
    access_log off;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
    expires max;
    log_not_found off;
    }

    location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
    }

    location ~ \.php$ {
    include /etc/nginx/fastcgi_params;
    fastcgi_pass unix:/run/php-fpm/www.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $doc$fast;
    }
  }

  server {
        # replace example.com with your domain name
        server_name rallly.thematrix.local;

        listen 80;
        listen [::]:80;
        listen 443 ssl http2; #https en http/2
        listen [::]:443 ssl http2; #https en http/2
        ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt; # locatie certs
        ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key; # locatie certs

        location / {
                proxy_pass http://localhost:3000;
                proxy_set_header X-Forwarded-For $prox;
                proxy_set_header Host $ht;
        }
  }
  server {
    # Permanent redirect
    server_name www.rallly.thematrix.local;

    listen 80;
    listen [::]:80;
    listen 443 ssl http2; #https en http/2
    listen [::]:443 ssl http2; #https en http/2
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt; # locatie certs
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key; # locatie certs

    return 301 https://rallly.thematrix.local;
  }
  server {
    listen 80;
	listen [::]:80;
    server_name $server_name;
    return 301 https://$server_name;
  }
  server {
        server_name $server_name;

        listen 80;
        listen [::]:80;
        listen 443 ssl http2; #https en http/2
        listen [::]:443 ssl http2; #https en http/2
        ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt; # locatie certs
        ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key; # locatie certs

        location / {
                proxy_pass $theoracle_link_ip;
        }
  }


}
EOF

log "restart nginx and php"

systemctl restart nginx
systemctl restart php-fpm


log "install packages and postgresql"

dnf install git epel-release -y
git clone https://github.com/lukevella/rallly.git
cd rallly
git checkout 9c4731dd224dd061a5bf2f56339455295338c16d
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo
rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg
dnf install yarn -y
log "yarn ok"

dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
dnf update -y
dnf install postgresql14 postgresql14-server postgresql14-contrib -y
/usr/pgsql-14/bin/postgresql-14-setup initdb
systemctl enable --now postgresql-14
firewall-cmd --add-port=5432/tcp --permanent
sed -i -r "s/peer/trust/" /var/lib/pgsql/14/data/pg_hba.conf
sed -i -r "s/#listen_.*/listen_addresses = '*'/" /var/lib/pgsql/14/data/postgresql.conf
systemctl restart postgresql-14
firewall-cmd --reload

log "Database aanmaken postgresql"

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';" > /dev/null 2>&1 &
sudo -u postgres psql -c "CREATE DATABASE rallydb;" > /dev/null 2>&1 &

### .env eventueel hardcoded maken
log "aanpassen .env file"

cp sample.env packages/database/prisma/.env
sed -i -r "s/SECR.*/SECRET_PASSWORD=ditmoethierminstens32karakterslangzijn/" ./packages/database/prisma/.env
sed -i -r "s/NEXT_.*/NEXT_PUBLIC_BASE_URL=rallly.thematrix.local/" ./packages/database/prisma/.env
sed -i -r "s|DATAB.*|DATABASE_URL=postgresql://postgres:postgres@localhost:5432/rallydb|" ./packages/database/prisma/.env

log "schema.prisma inladen"
npm i prisma@4.11.0-dev.40
npx prisma generate --schema=./packages/database/prisma/schema.prisma
npx prisma migrate dev --schema=./packages/database/prisma/schema.prisma
setsebool -P httpd_can_network_connect on

log "starten van rallly"

npm install csstype
npm install -D @prisma/nextjs-monorepo-workaround-plugin
yarn
npm install -D @prisma/nextjs-monorepo-workaround-plugin
yarn build
yarn start > /dev/null 2>&1 &
log "GELUKT"

#------------------------------------------------------------------------------
#  Matrix Commander CLI tool
#------------------------------------------------------------------------------
log "Installing Matrix Commander"

#Dependencies
log "Installing Matrix Commander dependencies"
dnf install -y python3-devel libolm-devel

log "Installing Matrix Commander"
pip install matrix-commander
#Updating PATH
PATH=$PATH:/local/bin
export PATH

#------------------------------------------------------------------------------
# Webserver shutdown script
#------------------------------------------------------------------------------

log "Creating Shutdown script"
mkdir -p /etc/scripts
cat << EOF | tee -a /etc/scripts/shutdown.sh
#!/bin/bash

#Matrix Commander login
matrix-commander --login PASSWORD --user-login admin --password ChangeMe --room-default Webserver --device trinity --no-ssl --homeserver $server_name
#Send a message
matrix-commander -m "Webserver shutting down"
EOF
#Shutdown script executable maken
chmod +x /etc/scripts/shutdown.sh

#------------------------------------------------------------------------------
# Shutdown-task.service
#------------------------------------------------------------------------------
cat << EOF | tee -a /etc/systemd/system/shutdown-task.service
[Unit]
Description=Send a Matrix message when shutting down

[Service]
Type=oneshot
ExecStart=/bin/true
ExecStop=/etc/scripts/shutdown.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

EOF

log "Root mag niet meer inloggen."
usermod --shell /usr/sbin/nologin root

log "SSH connectie zonder wachtwoord in te geven"
mkdir -p "${ssh_locatie}"
cat "/vagrant/provisioning/keys/SEP.pub" >> "${ssh_locatie}/authorized_keys"
cat "/vagrant/provisioning/keys/Vagrant_default.pub" >> "${ssh_locatie}/authorized_keys"
chmod -R 700 "${ssh_locatie}"

log "disable login with PW and root login"
sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/"  "/etc/ssh/sshd_config"
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/"  "/etc/ssh/sshd_config"
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/"  "/etc/ssh/sshd_config"
sed -i "s/ChallengeResponseAuthentication no//"  "/etc/ssh/sshd_config"
echo "ChallengeResponseAuthentication no"  >> "/etc/ssh/sshd_config"

log "Herstart sshd"
systemctl restart sshd
#Herladen en service enablen en starten

systemctl daemon-reload
systemctl enable shutdown-task
systemctl start shutdown-task

log "Shutdown taak toegevoegd"

log "Set default gateway"
#route add default gw 192.168.168.129 eth1
systemctl restart NetworkManager

log "Disable NAT interface"
nmcli device down eth0
#nmcli connection down eth0
#tcpdump -i eth0

log "Webserver installatie compleet"