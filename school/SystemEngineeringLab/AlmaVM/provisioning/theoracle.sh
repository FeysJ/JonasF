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
#Change it to a domain one for the demo
adminEmail="liam.robyns@student.hogent.be"
# Location of provisioning scripts and files
export readonly PROVISIONING_SCRIPTS="/vagrant/provisioning/"
# Location of files to be copied to this server
export readonly PROVISIONING_FILES="${PROVISIONING_SCRIPTS}/files/${HOSTNAME}"
#hostname
naam="theoracle"
ssh_locatie="/home/vagrant/.ssh"
server_name=theoracle.thematrix.local
DNS="192.168.168.130"
config_file=/root/synapse/homeserver.yaml
config_dir=/root/synapse
theoracle_link_ip="http://192.168.168.133:8008"
theoracle_ip="192.168.168.133"
adminPass=ChangeMe
#ip address server
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

# TODO: insert code here, e.g. install Apache, add users, etc.

#Change hostname
log "change hostname to $naam"
hostnamectl set-hostname $naam
#Subnet
sed -i -r "s/NETMA.*/NETMASK=255.255.255.240/" /etc/sysconfig/network-scripts/ifcfg-eth1

#DNS
echo "DNS1=$DNS" | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-eth1
systemctl restart NetworkManager
# ++++++++++++
# Installation Matrix Synapse prerequisites
# ++++++++++++
log "Updating packages"

dnf update -y > /dev/null 2>&1
dnf config-manager --set-enabled crb
dnf makecache --refresh

log "Installing pre-requisites"
dnf -y install epel-release > /dev/null 2>&1
dnf -y install libtiff-devel libjpeg-devel libzip-devel freetype-devel \
                 libwebp-devel libxml2-devel libxslt-devel libpq-devel \
                 python3-virtualenv libffi-devel openssl-devel python3-devel \
                 libicu-devel openssl libolm-devel > /dev/null 2>&1
dnf group install -y "Development Tools" > /dev/null 2>&1

log "Adapting Selinux for the port used by Synapse"
semanage port -m -t http_port_t -p tcp 8008
setsebool -P httpd_can_network_relay 1
setsebool -P httpd_can_network_connect 1
setsebool -P httpd_graceful_shutdown 1
setsebool -P nis_enabled 1

log "Setting firewall rules"
firewall-cmd --permanent --add-service http
firewall-cmd --permanent --add-service https
firewall-cmd --permanent --add-port=8008/tcp
firewall-cmd --reload
# ++++++++++++
# Synapse install
# ++++++++++++

log "Installing Synapse"

if [ ! -d $config_dir ]; then
  echo "De map $config_dir wordt aangemaakt."
  mkdir -p $config_dir
  echo "PATH wordt aangepast!"
  PATH=$PATH:/local/bin
  export PATH
else
  echo "$config_dir bestaat reeds!"
fi

cd $config_dir
virtualenv -p python3 env
source env/bin/activate
pip install --upgrade pip virtualenv six packaging appdirs setuptools > /dev/null 2>&1
pip install matrix-synapse > /dev/null 2>&1

log "Updating Synapse"
pip install -U matrix-synapse > /dev/null 2>&1
if [ ! -f $config_file ]; then
    echo "Synapse word geïnstalleerd!"
    python -m synapse.app.homeserver --server-name $server_name --config-path $config_file --generate-config --report-stats=no
    log "Changing the bind address for our reverse proxy"
    sed -i "s/^    bind_addresses: .*/    bind_addresses: ['$theoracle_ip', '127.0.0.1']/g" $config_file
    log "Starting Synapse"
    cd $config_dir
    source env/bin/activate
    synctl start
    # ++++++++++++
    # Default users/rooms
    # ++++++++++++
    log "Registering default users"
    #Admin account
    register_new_matrix_user -u admin -p $adminPass -a -c $config_file
    #Testusers
    register_new_matrix_user -u keanu -p ChangeMe --no-admin -c $config_file
    register_new_matrix_user -u laurence -p ChangeMe --no-admin -c $config_file
    log "Logging into Synapse & retrieving the access token"
    ADMIN_TOKEN=$(curl -s -H 'Content-Type: application/json' -d '{"type":"m.login.password", "user":"admin", "password":"ChangeMe"}' 'http://localhost:8008/_matrix/client/r0/login' | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
    log "Creating the Default room & Webserver room, admin will be added by default"
    curl -H "Authorization: Bearer $ADMIN_TOKEN" -H "Content-Type: application/json" -d '{"preset":"public_chat","room_alias_name":"General"}' "http://localhost:8008/_matrix/client/r0/createRoom"
    curl -H "Authorization: Bearer $ADMIN_TOKEN" -H "Content-Type: application/json" -d '{"preset":"private_chat","room_alias_name":"Webserver"}' "http://localhost:8008/_matrix/client/r0/createRoom"
else
    echo "Synapse werd reeds geïnstalleerd!"
fi
# ++++++++++++
# Starting Synapse
# ++++++++++++

log "Starting Synapse"
cd $config_dir
source env/bin/activate
synctl start > /dev/null 2>&1

# ++++++++++++
# Post install (as found in Webserver)
# ++++++++++++
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
route add default gw 192.168.168.130 eth1
systemctl restart NetworkManager

log "Synapse server installatie compleet"
log "NAT interface wordt uigeschakeld!"
nmcli device down eth0