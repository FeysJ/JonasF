# Router voor de simulatie-omgeving

## Omschrijving opzet

Om de Cisco router te simuleren werd de routerfunctie oorspronkelijk op de DC geïnstalleerd. Dit brengt later echter problemen met zich mee omdat de ip-adressen dan niet meer kloppen, gezien 192.168.168.130 voor de DC en 192.168.168.129 voor de router gekozen werden.

In een volgende poging werd geprobeerd om een virtuele Cisco-router te gebruiken. Bij deze opzet slaagden we er echter niet in om de interfaces handmatig te configureren (enkel via Ansible, maar die optie is uitgesloten voor deze opdracht).

Tot slot werd een aparte Windows server opgezet die enkel de routerfunctie op zich neemt. Gezien het echter niet mogelijk is om alle VM's op een enkele machine te draaien en de ACL's hier ook niet op werden geconfigureerd, werd deze deelopdracht niet meer verder uitgewerkt. Hieronder staat de configuratie zoals deze op de Windows server werd geconfigureerd.

Locatie van de image: zie Teams > Bestanden > Router.ova

## VM instellingen

RAM: 2 GB

Netwerkinstellingen:
    1. NAT
    2. intnet: servers
    3. intnet: crew
    4. intnet: cast

## Ondernomen stappen (ter info)

De volgende stappen zijn ondernomen om een router te configureren voor de simulatie-omgeving:

1. IP-adressen ingesteld van de adapters (de DNS-server is bij elke intnet adapter 192.168.168.130):
adapter 1: via dhcp
adapter 2: 192.168.168.129/28
adapter 3: 192.168.168.1/26
adapter 4: 192.168.168.65/26

2. roles toegevoegd:
    Functie: Externe toegang
    Onderdelen: RAS
    Functieservices:
        DirectAccess en VPN
        Routering

3. Het programma 'Routering en RAS' geopend en als volgt ingesteld:
    1. Inschakelen van routering:
        1. Klik met de rechter muisknop op de naam van de server
        2. "Routering en RAS configureren en inschakelen" > Aangepaste configuratie
        3. "LAN-routering" en "NAT" aanvinken
        4. voltooien en service starten

    2. NAT instellen:
        1. Klik met de rechter muisknop op NAT, onder IPv4.
        2. Kies "Nieuwe interface"
        3. Ethernet
        4. Kies voor "Openbare interface verbonden met internet" en vink "NAT voor deze interface inschakelen" aan

4. DHCP relay inschakelen
   1. Klik met de rechter muisknop op IPv4 > Algemeen en selecteer "Nieuw routeringsprotocol"
   2. Kies voor DHCP Relay Agent
   3. Er verschijnt nu DHCP Relay-agent in de navigatiebalk. Klik hier met de rechter muisknop op en kies "nieuwe interface".
   4. Voeg alle ethernet interfaces een voor een toe en laat hierbij de default waarden staan.
   5. Klik hierna met de rechter muisknop op DHCP Relay-agent, klik op "eigenschappen" en voeg het serveradres van de DHCP-server (192.168.168.130) toe. Pas de instellingen toe.

## Bronnen

* <https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapter?view=windowsserver2022-ps>
* <https://akyriako.medium.com/install-the-routing-and-remote-access-server-rras-on-windows-server-2022-8b0c2d880507>
* <https://learn.microsoft.com/en-us/powershell/module/dnsclient/set-dnsclientserveraddress?view=windowsserver2022-ps>
* <https://www.youtube.com/watch?v=jmxUmgedTpc>
