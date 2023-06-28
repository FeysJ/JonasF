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
naam="dozer"



#------------------------------------------------------------------------------
# Functions
#------------------------------------------------------------------------------

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
# route add default gw 192.168.168.129 eth1
systemctl restart NetworkManager

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
# Installatie requirements
# ++++++++++++

log "Installing Ruby"
dnf install -y ruby

log "installing sqlite3 (voor Rails)"
dnf install -y sqlite

log "installing node.js (voor Rails)"
dnf module install nodejs:18/common -y

log "installing yarn (voor Rails)"
npm install --global yarn

dnf install -y ruby-devel
dnf install -y make
dnf install -y automake
dnf install gcc
dnf install gcc-c++
#gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison iconv-devel sqlite-devel wget mysql-devel httpd mod_ssl

log "Installing Rails"
gem install rails

dnf install -y mysql-server

log "Installing requirements"
# bron: https://tecadmin.net/setup-subversion-server-on-centos

log installing "SVN (Apache and subversion)"
dnf install httpd -y
systemctl enable httpd

log "restarting httpd service"
service httpd restart

dnf install subversion mod_dav_svn -y

log "Configure Subversion with Apache"
cat << EOF | tee /etc/httpd/conf.d/subversion.conf
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so

Alias /svn /var/svn

<Location /svn>
   DAV svn
   SVNParentPath /var/svn
   AuthType Basic
   AuthName "Subversion User Authentication "
   AuthUserFile /etc/svn-users
   Require valid-user
</Location>
EOF

# log "SVN: Create Users for Authenctication"
# touch /etc/svn-users
# htpasswd -m /etc/svn-users user1

mkdir /var/svn

svn co https://svn.redmine.org/redmine/branches/5.0-stable /var/svn/redmine-5.0

log "Firewall rules worden ingesteld"
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

log "self signed certificates creation"

dnf install openssl -y
#controle doen of map bestaat nog implementeren (idem Trinity)
mkdir /etc/ssl/private

# aanmaken van de certificaten zelf
openssl req -newkey rsa:4096  -x509  -sha512  -days 365 -nodes -out /etc/ssl/certs/dozer.crt -keyout /etc/ssl/private/dozer.key -subj '/CN=dozer.thematrix.local'

log "Back-up maken van de httpd config file"
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd_orig.conf

# ++++++++++++
# Installatie Redmine
# ++++++++++++

# Installatie van Redmine:
# Bron: https://www.redmine.org/projects/redmine/wiki/RedmineInstall

chmod 775 .bundle/config




cd /var/svn/redmine-5.0
gem install bundler
bundle install --without development test

log "back-up van de database-config"
cp config/database.yml.example config/database.yml
vi config/database.yml

