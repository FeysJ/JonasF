#! /bin/bash
#
# Provisioning script for Dozer

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
export PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
export PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/files/${HOSTNAME}"
#hostname
naam="dozer"

# Database root password
readonly db_root_password='ChangeMe'
# Database name
readonly db_name=redmine
# Database table
#readonly db_table=selgroept02_tbl
# Database user
readonly db_user=redmine
# Database password
readonly db_password='my_password'
redmine_locatie="/var/www/redmine-5.0"
# redmine_locatie="/opt/redmine"
ssh_locatie="/home/vagrant/.ssh"

#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

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

# change hostname
log "change hostname to $naam"
hostnamectl set-hostname $naam

#### subnet nog wijzigen naar 240 - lukt niet via vagrant-hosts.yml!
sed -i -r "s/NETMA.*/NETMASK=255.255.255.240/" /etc/sysconfig/network-scripts/ifcfg-eth1

systemctl restart NetworkManager

log "self signed certificates creation"

dnf install openssl -y
log "Map voor ssl-certificaten aanmaken, als deze nog niet bestaat"
mkdir -p /etc/ssl/private

log "Certificaat aanmaken"
openssl req -newkey rsa:4096  -x509  -sha512  -days 365 -nodes -out /etc/ssl/certs/dozer.crt -keyout /etc/ssl/private/dozer.key -subj '/CN=dozer.thematrix.local'

# ++++++++++++
# Update system + enable EPEL
# ++++++++++++

log "Updating packages"

dnf update -y
dnf config-manager --set-enabled crb
dnf makecache --refresh

log "Installing pre-requisites"
dnf -y install epel-release

# ++++++++++++
# Firewall instellingen aanpassen
# ++++++++++++

log "Firewall rules worden ingesteld"
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
# firewall-cmd --add-port=3000/tcp --permanent # In de tutorials draait redmine op poort 3000; verplaatst naar poort 80 en 443.
firewall-cmd --reload

# ++++++++++++
# Installatie requirements
# ++++++++++++

log "Installing Ruby"
dnf install -y ruby
dnf install -y ruby-devel

log "installing sqlite3 (voor Rails)"
dnf install -y sqlite

log "installing node.js (voor Rails)"
dnf module install nodejs:18/common -y

log "installing yarn (voor Rails)"
npm install --global yarn

log "installatie van make en automake"
dnf install -y make
dnf install -y automake

log "installatie van gcc en gcc-c++"
dnf install -y gcc
dnf install -y gcc-c++

log "Installatie van Rails"
gem install rails

log "installatie van mysql"
dnf install -y mysql-server
dnf install -y mysql-devel

log "Installatie van Apache/httpd"
dnf install -y httpd
dnf install -y httpd-devel
# optioneel: dnf install httpd-tools -y
systemctl enable httpd

log "restarting httpd service"
service httpd restart

# ++++++++++++
# Installatie van Redmine 
# ++++++++++++

# Bronnen:
# https://www.redmine.org/projects/redmine/wiki/RedmineInstall
# https://www.redmine.org/projects/redmine/wiki/RedmineInstall#Step-3-Database-connection-configuration-
# https://idroot.us/install-redmine-almalinux-8/
# https://www.redmine.org/projects/redmine/wiki/Install_Redmine_421_on_Centos_7


log "Redmine user aanmaken en aan apache groep toevoegen"
useradd -r -m -d "${redmine_locatie}" redmine || echo "De gebruiker Redmine werd reeds aangemaakt."
usermod --shell /bin/bash redmine # nodig voor idempotentie van het script
usermod -aG redmine apache


log "Redmine release downloaden en naar de juiste locatie verplaatsen"
mkdir -p "${redmine_locatie}"
wget https://www.redmine.org/releases/redmine-5.0.5.tar.gz -P /tmp
tar xzf /tmp/redmine-5.0.5.tar.gz -C "${redmine_locatie}"/ --strip-components=1

log "Redmine configuratie-bestand aanmaken a.d.h.v. de sample"
cp "${redmine_locatie}"/config/configuration.yml{.example,}

log "sample dispatch CGI configuration file aanmaken a.d.h.v. de sample"
cp "${redmine_locatie}"/public/dispatch.fcgi{.example,}

log "Database configuratie file aanmaken a.d.h.v. de sample"
cp "${redmine_locatie}"/config/database.yml{.example,}

log "Back-up maken van de httpd config file"
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd_orig.conf



log "De databank opstarten"
systemctl start mysqld
systemctl enable mysqld

log "De databank beveiligen en een lege databank en user aanmaken"
if is_mysql_root_password_empty; then
mysql <<_EOF_
  alter user 'root'@'localhost' identified by '${db_root_password}';
  FLUSH PRIVILEGES;

  CREATE DATABASE ${db_name} CHARACTER SET utf8mb4;
  CREATE USER '${db_user}'@'localhost' IDENTIFIED BY '${db_password}';
  GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user}'@'localhost';
_EOF_
fi

log "Database configuratiebestand aanpassen"
cp /vagrant/provisioning/dozer/database.yml "${redmine_locatie}"/config/database.yml

log "Dependencies installeren via Gem"
su - redmine # hiervoor is het nodig dat de gebruiker een login shell heeft, ook al is dit eigenlijk een system user. 
cd "${redmine_locatie}"
gem install bundler
bundle config set --local without 'development test' 
bundle install

log "installatie van rake en generatie van secret token"
dnf install -y rake
bundle exec rake generate_secret_token

log "Database schema objects creation"
RAILS_ENV=production bundle exec rake db:migrate

log "Database default data set"
RAILS_ENV=production REDMINE_LANG=en bundle exec rake redmine:load_default_data

log "File system permissions"
mkdir -p tmp tmp/pdf public/plugin_assets
chown -R redmine:redmine files log tmp public/plugin_assets # sudo !!
chmod -R 755 files log tmp public/plugin_assets # sudo !!

# Installatie van Passenger 
# bron: https://www.phusionpassenger.com/library/install/apache/install/oss/el7

log "Installatie van Passenger"
gem install passenger --no-document # --no-document is de nieuwe optie voor -no-ri en -no-rdoc

curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo # sudo!!
yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yum install -y mod_passenger # sudo!!
# passenger-install-apache2-module # If you use these packages (yum) to install Passenger then you do not need to run passenger-install-apache2-module.

log "Maak Apache configuratie-bestand aan indien deze nog niet bestaat"
# [ ! -f "/etc/httpd/conf.d/redmine.conf" ] && touch /etc/httpd/conf.d/redmine.conf # test is niet nodig. Als bestand niet bestaat, wordt deze gewoon aangemaakt
touch /etc/httpd/conf.d/redmine.conf
 
cat << EOF | tee -a /etc/httpd/conf.d/redmine.conf
PassengerRuby /usr/bin/ruby

<VirtualHost *:80>
    ServerName www.dozer.thematrix.local

    Redirect 301 "/" "https://dozer.thematrix.local/"

    CustomLog logs/redmine_access.log combined
    ErrorLog logs/redmine_error_log
    LogLevel warn

    <Directory "/var/www/redmine-5.0/public">
        Options Indexes ExecCGI FollowSymLinks
        Require all granted
        AllowOverride all
    </Directory>
</VirtualHost>

NameVirtualHost *:443
<VirtualHost *:443>
    ServerName dozer.thematrix.local

    SSLEngine on

    DocumentRoot "/var/www/redmine-5.0/public/"

    SSLCertificateFile /etc/ssl/certs/dozer.crt
    SSLCertificateKeyFile /etc/ssl/private/dozer.key

</VirtualHost>
EOF

dnf install mod_ssl -y

log "SSL configuratie aanpassen"
sed -i 's$/etc/pki/tls/certs/localhost.crt$/etc/ssl/certs/dozer.crt$' /etc/httpd/conf.d/ssl.conf
sed -i 's$/etc/pki/tls/private/localhost.key$/etc/ssl/private/dozer.key$' /etc/httpd/conf.d/ssl.conf

# voeg redirection www -> non-ww toe, onderaan de ssl.conf
sed -i 's$</VirtualHost>$$' /etc/httpd/conf.d/ssl.conf
cat << EOF | tee -a /etc/httpd/conf.d/ssl.conf
    <If "%{HTTP_HOST} == 'dozer.thematrix.local'">
      Redirect permanent "/" "https://www.dozer.thematrix.local/"
    </If>
</VirtualHost>
EOF

log "Apache instellen als eigenaar van de redmine folder"
chown -R apache:apache "${redmine_locatie}"

log "SELinux instellingen aanpassen"
chcon -R -t httpd_log_t "$redmine_locatie"/log/
chcon -R -t httpd_tmpfs_t "$redmine_locatie"/tmp/
chcon -R -t httpd_sys_script_rw_t "$redmine_locatie"/files/
chcon -R -t httpd_sys_script_rw_t "$redmine_locatie"/public/plugin_assets/
restorecon -Rv "$redmine_locatie"/ 

# Passenger might complain that it isn't able to install a native support .so file. We can suppress this warning by adding the following lines:
cat << EOF | tee -a /etc/sysconfig/httpd
  PASSENGER_COMPILE_NATIVE_SUPPORT_BINARY=0
  PASSENGER_DOWNLOAD_NATIVE_SUPPORT_BINARY=0 
EOF

log "Apache wordt herstart"
systemctl restart httpd

# Voer de rest van dit script uit als gebruiker Vagrant 
su - vagrant 
log "Zorg ervoor dat de system user Redmine niet meer kan inloggen."
usermod --shell /usr/sbin/nologin redmine

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

log "Set default gateway"
route add default gw 192.168.168.129 eth1
systemctl restart NetworkManager

log "De installatie van Dozer is compleet"
# opgelet: hierna sluit ook de connectie met de host!
log "Disable NAT interface"
nmcli device down eth0
#nmcli connection down eth0
#tcpdump -i eth0
