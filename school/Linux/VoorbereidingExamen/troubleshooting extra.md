---
Extra oefening troubleshooting
---

opstarten van beide vagrant machines


1. Controle Fysieke laag
    - netwerk aangepast naar itnet van 2de interface
    - adapter 1 voor NAT staat niet aan
2. Controle netwerklaag

    - `ip a` voor controle netwerkinterfaces
        => web: eth1 geen ip adres, interface is down => naar stap 1, controle fysieke laagip a
    - We krijgen nu een ip adres op eth1 maar is niet in zelfde netwerk
        => aanpassen bestand /etc/sysconfig/network-scripts/eth1 => netwerk niet correct en ONBOOT staat op off => moet ON
        => herstarten van networkmanager `sudo systemctl restart NetworkManager.service`
        => `sudo nmcli device reapply eth1`
    - We kunnen nu pingen tussen de 3 machines
    - controle van default route via `ip r`. Dit lijkt ok te zijn.

3. Controle van transport Layer

    - Als we de website proberen te bereiken via Mint, lukt dit niet, geen connectie.
    - Testen van de services of deze draaien
        => `sudo systemctl status httpd.service` => deze staat uit, en ook disabled (opstart)
            * `sudo systemctl start httpd.service`
            * `sudo systemctl enable httpd.service`
        => controle firewall services => `sudo firewall-cmd --status-all`
            * `sudo firewall-cmd --add-service=http --permanent`
            * `sudo firewall-cmd --add-service=http --permanent`
            * `sudo systemctl restart firewalld.service`
            * `sudo firewall-cmd --add-port=80/tcp --permanent`
        => we krijgen nu de webpagina van apache te zien, test.php kunnen we nog niet bereiken
    - controle van host_ip van de databank in bestand /var/www/html/test.php
        => ok

    - controle SELinux => /var/www/html/
        => `lz -lZ` => instelling verkeerd tov /var/www
        => `sudo restorecon -Rv /var/www`
        => we hebben nu toegang tot de database maar kunnen deze nog niet inladen

    - controle van booleans
        => `getsebool httpd_can_network_connect_db` => staat nu op off
        => `sudo setsebool -P httpd_can_network_connect_db on`
        => succes!