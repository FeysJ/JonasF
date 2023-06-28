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

# scp vagrant@192.168.76.245:~/dns-skeleton.sh vagrant@192.168.76.12:~/
# conf-dir=/etc/dnsmasq.d,.rpmnew,.rpmsave,.rpmorig
# sudo sed -i 's/conf-dir=.*/conf-dir=\/var\/dns\/",.rpmnew,.rpmsave,.rpmorig/' /etc/dnsmasq.conf

# sudo sed -i 's/#listen-add.*/listen-address=127.0.0.1,

# sudo chcon -t dnsmasq_etc_t -u system_u /var/dns/db.linux.prep
# sudo chcon -t dnsmasq_etc_t -u system_u /var/dns

# nslookup bert.linux.prep 127.0.0.1
# grep -c "host-record" var/dns/db.linux.prep 
# cat "${DNS_DIR}"/db."${Domain}" | grep -c