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

log "Installing Apache and php-mysqlnd php"

dnf install -y httpd php php-mysqlnd

log "Enabling Apache service"

systemctl enable --now httpd.service

log "Setting firewall rules"

firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload

log "download test.php page"

wget http://157.193.215.171/test.php

log "move file from download folder to /var/www/html"

mv -v /home/vagrant/test.php /var/www/html/test.php

log "change db_host ip and db_password"

sudo sed -i 's/db_host=.*/db_host=\x27192.168.76.3\x27;/' /var/www/html/test.php
sudo sed -i 's/db_password=.*/db_password=\x27Kof3Cup.ByRu\x27;/' /var/www/html/test.php

log "change SELinux type from file test.php"

restorecon -R /var/www/

log "set boolean for httpd_can_network_connect_db"

setsebool -P httpd_can_network_connect_db on