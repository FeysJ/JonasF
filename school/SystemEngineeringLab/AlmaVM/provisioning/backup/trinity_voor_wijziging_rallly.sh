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
log "change hostname to $naam"
hostnamectl set-hostname $naam

#### subnet nog wijzigen naar 240!
sed -i -r "s/NETMA.*/NETMASK=255.255.255.248/" /etc/sysconfig/network-scripts/ifcfg-eth1
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
firewall-cmd --reload

log "self signed certificates creation"

dnf install openssl -y
#controle doen of map bestaat nog implementeren
mkdir /etc/ssl/private

# aanmaken van de certificaten zelf
openssl req -newkey rsa:4096  -x509  -sha512  -days 365 -nodes -out /etc/ssl/certs/nginx-selfsigned.crt -keyout /etc/ssl/private/nginx-selfsigned.key -subj '/CN=thematrix.local'


cp /etc/nginx/nginx.conf /etc/nginx/nginx_backup.conf # backup van bestaande conig file 


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

#Change permisions

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

cat << EOF | tee -a /etc/nginx/nginx.conf
server {
    listen 80 default_server;
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
}
EOF

log "restart nginx and php"

systemctl restart nginx
systemctl restart php-fpm