# Testrapport Opdracht: RSAT vanop DirectorPC

## Test RSAT vanop DirectorPC

Uitvoerder(s) test: De Craemer Joost
Uitgevoerd op: 25/03/2023 
Github commit:  

## Startsituatie

* De domain controller en de director PC zijn opgestart.
* De DirectorPC werd toegevoegd aan het domein.
* De DirectorPC heeft een geldig ip-adres
* De DirectorPC heeft een internetverbinding (via de router).
* De DHCP role werd op de DC geïnstalleerd
* Je bent ingelogd als domain admin (!)

## Uit te voeren stappen

1. Open een powershell venster als administrator op de DirectorPC en voer het script install_RSAT.ps1 uit. <br/>
**resultaat:** Script runde niet foutloos omwille van corrupte backticks. Dit werd gecorrigeerd en het script liep vervolgens <br/>

## Verwachte resultaat

1. Verifieer de installatie van de tools

Ga op de DirectorPC naar Start > Windows Systeembeheer. De volgende tools zouden erbij gekomen moeten zijn:<br/>
**Opmerking:** Dit resultaat was initieel niet het geval. Dit komt omdat de directorPC de DC niet vond. Daarom tijdelijk de DirectorPC in het servers netwerk opgenomen ipv crew-netwerk. Op die manier kon de test uitgvoerd worden
* Active Directory - gebruikers en computers<br/>
**resultaat:** ok
* Active Directory - sites en services<br/>
**resultaat:** ok
* Active Directory - Module voor Windows PowerShell<br/>
**resultaat:** ok
* Active Directory - domeinen en vertrouwensrelaties<br/>
**resultaat:** ok
* Active Directory-beheercentrum<br/>
**resultaat:** ok
* DHCP<br/>
**resultaat:** ok
* DNS<br/>
**resultaat:** Dit is niet zichtbaar. Omdat momenteel de DNS nog niet is geïnstalleerd op DC?
* Groepsbeleidsbeheer<br/>
**resultaat:** ok
* Routering en RAS<br/>
**resultaat:** ok
* Onder de 'S' is de applicatie 'Serverbeheer' erbij gekomen.<br/>
**resultaat:** ok

2. Controleer ADUC connectie kan maken naar het domein.

* Open 'Active Directory - gebruikers en computers'.
* Verifieer dat je de domeinstructuur, zoals deze op de DC werd opgezet kan herkennen. <br/>
**resultaat:** ok 

3. Controleer of Groepsbeleidsbeheer connectie kan maken naar het domein.

* Open de applicatie 'Groepsbeleidsbeheer'.
* Verifieer dat het domein TheMatrix.local aanwezig is.<br/>
**resultaat:** ok 

4. DHCP

* Open de applicatie 'DHCP'.
* Klik onder 'Actie' op 'Server toevoegen'.
* Gebruik de DHCP-server agentsmith.thematrix.local.
* Verifieer dat dezelfde scopes aanwezig zijn als op de DHCP-server.<br/>
**resultaat:** ok? Onder de adresleases van scope cast, is de directorPC zichtbaar.
  
5. DNS

* Open de applicatie 'DNS'.
* Klik onder 'Actie' op 'Verbinding maken met DNS-server'.
* Voer het ip-adres van de DC in (bij de virtuele opstelling: 192.168.168.129).
* Verifieer dat de forward lookup zone TheMatrix.local aanwezig is.<br/>
**resultaat:** Dit is niet zichtbaar. Omdat momenteel de DNS nog niet is geïnstalleerd op DC? Test later te vervolledigen

6. Routering en RAS (enkel indien de DC de routerfunctie heeft)

* Open de applicatie 'Routering en RAS'.
* Klik onder 'Actie' op 'Server toevoegen'.
* Kies voor 'Een andere computer' en vul hier het ip-adres 192.168.168.129 in.
* Controleer dat onder IPv4 > NAT, de interfaces van de DHCP-server aanwezig zijn.<br/>
**resultaat:** ok. Echter in de virtuele omgeving is het 192.168.168.130

7. Serverbeheer

* Open de applicatie 'Serverbeheer'.
* Klik met de rechter muisknop op 'Alle servers' en klik op 'Servers toevoegen'.
* Vul bij Naam (CN) de naam "agentsmith" in en klik op 'Nu zoeken'.
* Voeg agentsmith toe aan de geselecteerde computers en klik op ok.
* De server en de serverrollen zouden nu toegevoegd moeten zijn in het serverbeheer.<br/>
**resultaat:** ok

8. Shares 
* open de applicatie "Server Manager"
* Klik rechermuis onder 'Alle servers' op 'Server toevoegen'.
    * Onder "naam (CN)" , "AgentSmith" ingeven, zoeken en toevoegen 
    * Wanneer gevonden, selecteren via pijl + ok 
* Bestands- en opslagservices kiezen
    * shares selecteren
* bekijken of je de shares op de DC kunt zien voor cast, crew en de users<br/>
**resultaat:** ok

