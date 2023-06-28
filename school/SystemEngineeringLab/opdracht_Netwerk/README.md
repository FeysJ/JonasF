# System Engineering Project - Opdracht Netwerk

## **Overzicht**

In deze map is de uitwerking van de gekozen netwerkadressen, configuratie van de toestellen (router en switch) en de simulatie via packet tracer terug te vinden.</br>
Om een goed visueel overzicht te krijgen van de installatie en de nodige configuratie van adressen zijn er ook schema's uitgewerkt.</br>
Het netwerk en alle servers worden uitgewerkt met IPv4. IPv6 wordt nog niet uitgerold op de apparatuur maar wordt wel al voorzien op de DNS-server.
De Opdracht omschreef ook het gebruik van vlans:
* VLAN 20 Interne servers
    * Vaste, private IP-adressen
    * De IP-adressen corresponderen met de adressering van de servers.
* VLAN 30 Werkstations crew
    * Dynamische, private IP-adressen (via DHCP)
    * Kunnen interne servers en Internet bereiken
* VLAN 40 Werkstations cast
    * Dynamische, private IP-adressen (via DHCP)
    * Kunnen enkel op Internet, interne servers zijn nietbereikbaar met uitzondering van de AD
Inter-VLAN routing wordt uitgevoerd met een router-on-a-stick configuration

De gekozen configuratie gegevens vindt u hier: [Configuratie gegevens](NetwerkconfiguratieGegevens.md)

## Packet Tracer simulatie
De opstelling werd eerst gesimuleerd in packet tracer.<br/>
Commando's voor het configureren van de PT-file, vindt u terug in het bestand: [Configuratiecommandos](Netwerk_PT/commandosPT.md) <br/>
De uitgewerkte packet tracer simulatie vindt u terug in de map: [NetwerkPT](<Netwerk_PT/>)

## Virtual Box met RouterSimulatie 
Het netwerk werd eerst (deels) uitgevoerd op laptops. <br/>
Gebruikmakend van internal netwerken (ter simulatie van vlans), gebeurde dit in virtual box. <br/>
Het verslag vind je hier: [VirtualBoxSimulatie](RouterSimulatie/README.md)

## Uitwerking met fysieke toestellen
De configuration file die gebruikt worden tijdens de demonstratie van het fysiek labo bevindt zich hier: [ConfigFile](<Netwerk_Fysiek/configPT.md>)
* Een visuele weergave vind je terug in dit [Schema](Images/NetwerkSetupExternalSwitchingGearRev6__20230517.jpg)
* Een visuele weergave van de geplande opdeling per laptop vind je terug in dit [Schema](Images/NetwerkSetupExternalSwitchingGearForDemoRev1_20230517.jpg)

## **Links**

1. [Configuratie gegevens](NetwerkconfiguratieGegevens.md)
2. [Fysieke testopstelling](Netwerk_Fysiek)
4. [Packet tracer simulatie](Netwerk_PT)
5. [Routersimulatie](RouterSimulatie)
6. [Lastenboek](lastenboek.md)
7. [Testen](testen)