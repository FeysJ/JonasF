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

# TODO: insert code here

log "installeren bind en bind-utils"
sudo dnf install bind bind-utils -y

log "opstarten en enable van de service"
sudo systemctl enable --now named.service

sudo dnf install nano -y

log "wijzigen /etc/named.conf zodat naar iedere interface en host wordt geluisterd en queries kunnen uitgervoerd worden"

sudo sed -i 's/listen-on p.*/listen-on port 53 { any; };/' /etc/named.conf
sudo sed -i 's/listen-on-v6 p.*/listen-on-v6 port 53 { any; };/' /etc/named.conf
sudo sed -i 's/recursion y.*/recursion no;/' /etc/named.conf
sudo sed -i 's/{ localh.*/ { any; };/' /etc/named.conf
sudo systemctl restart named


log "starten firewall en toevoegen service"

sudo systemctl start firewalld
sudo firewall-cmd --permanent --add-port=53/udp
sudo firewall-cmd --reload

log "forward lookup zone "

cat << EOF >> /etc/named.conf
zone "linux.lan" IN {
  type master;
  file "linux.lan";
  notify yes;
  allow-update { none; };
};
EOF



sudo touch /var/named/linux.lan

cat << EOF > /var/named/linux.lan
$ORIGIN linux.lan.
$TTL 1W

@ IN SOA ns.linux.lan. hostmaster.linux.lan. (
  21120117 1D 1H 1W 1D )

        IN  NS          ns1

        IN  MX          10 mail

ns1     IN  A           192.168.76.254

web     IN  A           192.168.76.4
www     IN  CNAME       web

db      IN  A           192.168.76.3

mail    IN  A           192.168.76.10
EOF


log "reverse lookup zone toevoegen"

cat << EOF >> /etc/named.conf
zone "76.168.192.in-addr.arpa" IN {
  type master;
  file "76.168.192.in-addr.arpa";
  notify yes;
  allow-update { none; };
};
EOF



sudo touch /var/named/76.168.192.in-addr.arpa

cat << EOF > /var/named/76.168.192.in-addr.arpa
$TTL 1W
$ORIGIN 76.168.192.in-addr.arpa.

@ IN SOA ns.linux.lan. hostmaster.linux.lan. (
  21120117 1D 1H 1W 1D )

       IN  NS     ns1.linux.lan.

254    IN  PTR    ns1.linux.lan.
4      IN  PTR    web.linux.lan.
3      IN  PTR    db.linux.lan.
10     IN  PTR    mail.linux.lan.
EOF


log "herstarten van named service"
sudo systemctl restart named


log "installeren van DHCP"

sudo dnf install dhcp-server -y

log "wijzigen configuratiebestand"

cat << EOF >> /etc/dhcp/dhcpd.conf
subnet 192.168.76.0 netmask 255.255.255.0 {
        option routers                  192.168.76.254;
        option subnet-mask              255.255.255.0;
        option domain-search            "linux.lan";
        option domain-name-servers      192.168.76.254;
        range   192.168.76.101   192.168.76.253;       
}
EOF

log "opstarten van dhcpd service"

systemctl enable --now dhcpd.service

log "instellen firewall"

firewall-cmd --add-service=dhcp --permanent
firewall-cmd --reload