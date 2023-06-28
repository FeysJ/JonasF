# Instellen DHCP-, web-, DNS-server en MySQL

Naam student: Jonas Feys
## Algemeen

zoeken package: `dnf search NAAM`
lijst firewall: `sudo firewall-cmd --list-all`
overzicht poorten: `ss -tlnp`
overzicht standaard poorten: `getent services SERVICE`
testen connectie met bvb databankserver: `nc -nvz IP POORT`
Status service: `journalctl -fu dhcpd.service`
port list: /etc/services

## Stappenplan DHCP
configuratie: /etc/dhcp/dhcpd.conf


1. Installeren package: `sudo dnf install dhcp-server -y`
2. Wijzigen van configuratiebestand met instellingen `sudo nano /etc/dhcp/dhcpd.conf`
        subnet 192.168.76.0 netmask 255.255.255.0 {
        range 192.168.76.100 192.168.76.150;
        default-lease-time 14400;
        max-lease-time 28800;
        }
3. enable dhcpd.service `sudo systemctl enable dhcpd.service`
4. opstarten dhcpd.service `sudo systemctl start dhcpd.service`
5. Toevoegen aan firewall: `sudo firewall-cmd --add-service=dhcp --permanent`
6. Herstarten firewall: `sudo firewall-cmd --reload`

## Stappenplan webserver
map: /var/www/html => bestanden moeten root als eigenaar hebben om te functioneren!
config: /etc/httpd/conf/httpd.conf

1. Installeren package apache: `sudo dnf install httpd -y`
2. Installeren package php: `sudo dnf install php -y`
3. Toevoegen aan firewall: http: `sudo firewall-cmd --add-service=http --permanent`
4. Toevoegen aan firewall: https: `sudo firewall-cmd --add-service=https --permanent`
5. Herstarten firewall: `sudo firewall-cmd --reload`
6. opstarten en enable http service: `sudo systemctl enable --now httpd`
7. Toevoegen aan firewall: poort 80: `sudo firewall-cmd --add-port=80/tcp --permanent`
8. Toevoegen aan firewall: poort 443: `sudo firewall-cmd --add-port=443/tcp --permanent`

## Stappenplan databank

config: /etc/my.cnf.d/mariadb-server.cnf
data: /var/lib/mysql => indien andere map moet eignaar van map mysql zijn!

1. Installeren package mariadb: `sudo dnf install mariadb-server -y`
2. opstarten en enable:  `sudo systemctl enable --now mariadb`
3. uitvoeren script op ww in te stellen: `sudo mysql_secure_installation`

## Stappenplan hardening webserver
standaard poort databank: 3306

1. copie maken van config mariadb: `sudo cp /etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/mariadb-server-backup.cnf`
2. wijzigen van bind adres in mariadb-server.cnf naar IP van de server
3. herstarten van de service:  `sudo systemctl restart mariadb`
4. controle dat IP effectief werd gewijzigd: `ss -at` of `ss -tlnp`
5. testen of verbinding werkt: `nc -nvz 192.168.76.245 3306` (sudo dnf install nc -y)
6. toevoegen van alternatioeve poort in mariadb-server.cnf onder bind_adress: `port=1978`
7. nieuwe poort toevoegen aan SELinux context: `sudo semanage port -a -t mysqld_port_t -p tcp 1978`
8. herstarten van de service:  `sudo systemctl restart mariadb`
9. `sudo mkdir /dbdata` en eigenaar wijzigen naar mysql `sudo chown mysql:mysql /dbdata` 
10. Copy van bestaande bestanden naar nieuwe datamap: `cp -R -p /var/lib/mysql/* /dbdata`
11. permissies correct zetten: `sudo semanage fcontext -a -t mysqld_db_t "/dbdata(/.*)?"`
12. permissies correct zetten: `sudo restorecon -Rv /dbdata`
13. Wijzigen van configuratiebestand: `datadir=/dbdata` en `socket=/dbdata/mysql.sock`
14. Toevoegen aan configuratiebestand:  [client]
                                        port=1978
                                        socket=/dbdata/mysql.sock
15. herstarten van de service:  `sudo systemctl restart mariadb`
16. testen of datadir correct staat: `mysql -u root -p -e "SELECT @@datadir;"`
17. Databank aanmaken en testen met script of dit werkt
18. Installeren php-mysqlnd: `sudo dnf install php-mysqlnd -y`
18. File downloaden voor een webpagina: `curl -o NAAM URL`
19. Bestand verplaatsen naar /var/www/html
20. eigenaar controleren via `ls -Z` en aanpassen indien nodig: `sudo restorecon -R /var/www/`
21. eigenaar ook naar root gewijzigd
22. Boolean correct zetten: `setsebool -P httpd_can_network_connect_db on`
23. in var/www/html.test.php: `IP correct instellen` en `PORT toevoegen bij connectiestring` => `;` niet vergeten!


## Stappenplan DNS server
configuratie: /etc/named.conf

1. Installeren package bind: `sudo dnf install bind -y`
2. 
3. Forward lookup zone toevoegen in configuratiebestand
        zone "linux.lan" IN {
        type master;
        file "linux.lan";
        notify yes;
        allow-update { none; };
        };
4. aanmaken van zonebestand: `touch /var/named/linux.lan`
5. toevoegen van nodige gegevens
        \$ORIGIN linux.lan.
        \$TTL 1W

        @ IN SOA ns.linux.lan. hostmaster.linux.lan. (
        21120117 1D 1H 1W 1D )

                IN  NS          ns1

                IN  MX          10 mail

        ns1     IN  A           192.168.76.244

        web     IN  A           192.168.76.4
        www     IN  CNAME       web

        db      IN  A           192.168.76.3

        mail    IN  A           192.168.76.10

6. Reverse lookup zone toevoegen in configuratiebestand
        zone "76.168.192.in-addr.arpa" IN {
        type master;
        file "76.168.192.in-addr.arpa";
        notify yes;
        allow-update { none; };
        };
7. aanmaken van zonebestand: `touch /var/named/76.168.192.in-addr.arpa`
8. toevoegen van nodige gegevens
        \$TTL 1W
        \$ORIGIN 76.168.192.in-addr.arpa.

        @ IN SOA ns.linux.lan. hostmaster.linux.lan. (
        21120117 1D 1H 1W 1D )

                IN  NS     ns1.linux.lan.

        244     IN  PTR    ns1.linux.lan.
        4       IN  PTR    web.linux.lan.
        3       IN  PTR    db.linux.lan.
        10      IN  PTR    mail.linux.lan.

9. reload de service: `sudo systemctl restart named`