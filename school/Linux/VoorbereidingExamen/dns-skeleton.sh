#!/bin/bash
#
# Nice DNS: the script builds up an authoritative DNS server using DNSmasq,
# and offers options to populate and ask questions to the local DNS server run by the daemon.
#
# Author: Andy Van Maele <andy.vanmaele@hogent.be>

# Stop het script bij een onbestaande variabele


### Algemene variabelen worden eerst gedefinieerd
DNS_DIR=/var/dns
DOMAIN=linux.prep
RANGE=10.20.33.0/24
IPSERVER=`ip addr show eth1 | grep 'inet ' | awk '{ print $2}' | cut -d'/' -f1`
NATINTERFACE=eth0
DNS_IP=192.168.76.1
NAAMLIJST=~/voornamen.list

### --- functions ---

# installeer de DNS server, ook al zou de service al geïnstalleerd zijn. 
# Gebruik idempotente commando's waar mogelijk.
function install_dnsserver {
  # Installeer de DNSserver software 
  sudo dnf install dnsmasq -y
  sudo dnf install epel-release -y 
  sudo dnf install figlet cowsay -y
  # Ga na of de map voor de DNS-inhoud bestaat. Indien niet, maak ze aan
  if [ ! -d "${DNS_DIR}"  ] ; then
    sudo mkdir ${DNS_DIR}
    echo "Custom map ${DNS_DIR} is aangemaakt"
  fi
  
  # Pas de configuratie van de DNS server aan
  
  ##standaard map wijzigen
  sudo sed -i 's/conf-dir=.*/conf-dir=\/var\/dns,.rpmnew,.rpmsave,.rpmorig/' /etc/dnsmasq.conf
  echo "map gewijzigd"
  sudo sed -i 's/#listen-add.*/listen-address=127.0.0.1,'"$IPSERVER"'/' /etc/dnsmasq.conf
  echo "listen addres gewijizgd"
  sudo sed -i 's/#except-i.*/except-interface='"$NATINTERFACE"'/' /etc/dnsmasq.conf 
  echo "exept interface toegevoegd"
  
  # aanpassen firewall

  sudo firewall-cmd --add-service=dns --permanent
  sudo firewall-cmd --reload
  sudo firewall-cmd --zone=public --add-port=53/tcp

  sudo systemctl enable --now dnsmasq
  # Herstart de service
  sudo systemctl restart dnsmasq 

}

# Initialiseer een nieuwe database voor het opgegeven domain;
# voeg drie eerste gebruikers toe.
# Bemerk: de range wordt hier hardcoded gebruikt - dit kan in se beter!
function init_dns_db {
  local Domain=${1}
  
  if ! [ -f "${DNS_DIR}"/db."${Domain}" ] ; then
	# Generate an empty file, let everybody write to it
        sudo touch ${DNS_DIR}"/db."${Domain}
        sudo chmod 722 ${DNS_DIR}"/db."${Domain}
        sudo chcon -t dnsmasq_etc_t -u system_u /var/dns/db.linux.prep
        sudo chcon -t dnsmasq_etc_t -u system_u /var/dns
    cat << EOF > "${DNS_DIR}"/db."${Domain}"
# SOA config
# ----------------------------------------------------------------------------
auth-soa=2016021014,hostmaster.${Domain},1200,120,604800
auth-server=${DOMAIN},${DNS_IP}
auth-zone=${DOMAIN},${RANGE}

# A records
# ----------------------------------------------------------------------------
host-record=andy.linux.prep,10.22.33.1
host-record=bert.linux.prep,10.22.33.2
host-record=thomas.linux.prep,10.22.33.3
EOF
  fi 
}

# De functie neemt een naam en een domain als input, en voegt een RR
# (resource record) toe in de database file in de juiste map (globale variabelen)
function create_resource_record {
  local Name=${1}
  local Domain=${2}
  local NextIP=`sudo tail -n +9 "${DNS_DIR}"/db."${Domain}" | wc -l `
  local Record=""
  
#  ${Record}=` "host-record=${Name}.${Domain}" | sed -e 's/\(.*\)/\L\1/'`

  echo "host-record=${Name}.${Domain},10.22.33.$(( NextIP + 1 ))" | sed -e 's/\(.*\)/\L\1/' >> "${DNS_DIR}"/db."${Domain}"

# echo "${Record},10.22.33.$(( NextIP + 1 ))" >> "${DNS_DIR}"/db."${Domain}"
 echo "Added ${Name}.${Domain}" | sed -e 's/\(.*\)/\L\1/'

 sudo systemctl restart dnsmasq 2> /dev/null
}

# Gebruik de bovenstaande functie om N aantal records toe te voegen aan het 
# opgegeven domain. De lijst met namen is opnieuw een globale variabele.
# Bemerk: werken met een tempfile is slechts één mogelijkheid.
# Een oplossing met een array van namen is een andere.
function generate_RRs {
  local Number=${1}
  local Domain=${2}    
  local tempfile=$(mktemp)
  
  shuf -n ${Number} ${NAAMLIJST}  > "${tempfile}"

  local Record=""

# iedere lijn in de tempfile lezen en actie uitvoeren
  while read -r Record ; do

   create_resource_record ${Record} ${Domain}

  done < "${tempfile}"
  
  rm "${tempfile}"
}

# de short lookup geeft enkel het IP-adres weer in grote letters.
# Hint: figlet
function short_lookup {
  local URL=${1}
  local Serv=${DNS_IP}
  local Exists=`sudo grep -c "host-record=${URL}.${DOMAIN}" "${DNS_DIR}"/db."${DOMAIN}"` 
  # grep return waarde is 0 bij een match, 1 bij geen match en 2 bij error
  if ! [ ${Exists} -eq 0 ]; then
   
    local IPURL=`nslookup ${URL}.${DOMAIN} ${DNS_IP} |  grep "Address: " | cut -d " " -f2 `  
    figlet ${IPURL} 
  fi
  
  

}

# de fancy lookup geeft eerst een newline, de datum, 
# en dan het resultaat van een lookup in een tekstballon van een koe
# Hint: cowsay
function fancy_lookup {
  local URL="${1}"
  local Serv=${DNS_IP}
  local IPURL=`nslookup ${URL}.${DOMAIN} ${Serv} | grep "Address: " | cut -d " " -f2`
  local IP53=`nslookup ${URL}.${DOMAIN} ${Serv} | grep 53 | cut -d ":" -f2 | sed 's/[[:space:]]//g'`
  local Date=$(date +'%Y/%m/%d')

  echo -e "\nVandaag is het ${Date}"
  echo -e "Server: ${DNS_IP} Address: ${IP53} \n\n Name:${URL}.${DOMAIN} Address:  ${IPURL}"| cowsay   

}
# Deze functie neemt als input een (hoofd)letter en een domain.
# De namenlijst is opnieuw een globale variabele.
# Alle namen beginnend met de letter worden (short) opge
function start_with_letter {
   local Letter=${1}
   local Domain=${2} 
   local tempfile=$(mktemp)
 ##  ... Hergebruik wat je schreef voor de functie "generate_RRs" 
 ## Niet duidelijk of gveraagd wordt om de functie aan te roepen of gewoon code te hergebruiken, functie aanroepen lijkt mij onlogisch en onduidelijk 
 
 # namen uit lijst halen via hoofdletter en in temp file plaatsen
  grep "^${Letter^^}" voornamen.list > "${tempfile}"

  local Record=""

# iedere lijn in de tempfile lezen en actie uitvoeren
  while read -r Record ; do
     echo Looking up ${Record}
     # naar lowercase omzetten 
     short_lookup ${Record,,} $
     wait
  done < "${tempfile}"
  
  rm "${tempfile}"


}


### --- main script ---
### Voer de opeenvolgende taken uit

# wijzig SELinux to permissive
sudo sed -i 's/SELINUX=.*/SELINUX=permissive/' /etc/selinux/config

# installeer DNS server, ook al is het reeds geïnstalleerd. 
install_dnsserver > /dev/null 2>&1

# initialiseer de local DNS database, indien nodig
init_dns_db "${DOMAIN}"

# Ga na of er argumenten zijn of niet; zoniet onderbreek je het script
if [ "$#" -eq "0" ]; then
  echo "At least one argument expected, exiting..."
  exit 1
fi

# With a case statement, check if the positional parameters, as a single
# string, matches one of the text the script understands.
case "${1}" in
  # korte lookup van naam
 -s|--short)
   short_lookup "${2}"    
   ;;
  
  # voeg gebruiker toe aan lokale DNS database
 -a|--add)
   create_resource_record "${2}" "${DOMAIN}"
   fancy_lookup "${2}"
   ;;
  
  # selecteer random namen uit bestand
 -g|--gen)
   generate_RRs "${2}" "${DOMAIN}"
   ;;
  
  # alle namen uit bestand starten met letter
 -r|--range)
   start_with_letter "${2}"
   ;;
  
 #verkeerde parameter
 -*)
  echo "Wrong parameter was given, exiting..."
  exit 2
  ;;
 
 #alle andere cases
 *)
  fancy_lookup "${1}"
  ;;
 
esac

# Einde scripts
