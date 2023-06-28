# Testrapport Opdracht Netwerk:

## Test Netwerk 

Uitvoerder(s) test: De Craemer Joost
Uitgevoerd op: 27/02/2023 + 20/05/2023
Github commit:  COMMIT HASH

1. Zijn er voldoende subnetten aangemaakt? <br/>
**status:** Ja, De noodzakelijke subnetten zijn aanwezig
2. Zijn er voldoende IP adressen beschikbaar per subnet?<br/>
**status:** Afhankelijk van hoe we een realisatie moeten maken, zijn de adressen in het Vlan20 mogelijks te beperkt.
Alle adressen zijn reeds opgebruikt en mogelijks vraagt een uitvoering met bridged Adapters om extra adressen in Vlan20.
Ook al is de vraag om geen adressen te verspillen, lijkt het me verantwoord en verdedigbaar om de range wat uit te breiden.
3. Zijn er geen adressen verspild? <br/>
**status:** De subnetten voor cast en crew bevatten 62 hosts. Dit is bewust gekozen om voldoende crew en cast te kunnen voorzien.
4. Is er gewerkt met een privaat IP adres?<br/>
**status:** Private ranges zijn correct toegepast.
5. Opmerkingen/feedback: 
    * DNS server kunnen we als kolom toevoegen
    * adresseringstabel voor IpV6 dient voorzien te worden
    * Voor crew en cast zijn de verwachtte default gateway correct maar worden bekomen via dhcp (zoals voor ipadres is aangegeven)
    * Eventueel verschillende tabellen maken voor fysieke uitvoering en de uitvoering in labo

## packet tracer

1. Is er gewerkt met Router-on-a-stick configuratie? <br/>
**status**: Ja. Zoals je hieronder in de figuur van de routeringstabel ziet, zijn de routes naar de subinterfaces aanwezig.
![RouteTabelRouter](<images/InterVlanRoutingCheckRouter.jpg>)
2. Zijn de VLAN's correct geconfigureerd?<br/>
**status**: Ja. Zoals je hieronder in de figuur van de vlan database ziet, zijn de vlans aanwezig.<br/>
![VlanDB](<images/vlanCheckSwitch.jpg>)
3. Is de router correct geconfigureerd volgens de adresseringstabel? <br/>
**status**: Ja. Zoals je hieronder in de figuur van de vlan database ziet, zijn de vlans aanwezig. <br/>
![RouterIPadresses](<images/InterfaceAdressenRouter.jpg>)
4. Zijn de servers correct geconfigureerd volgens de adresseringstabel? <br/>
**status**: ja alle servers hebben een ipv4 hostadres volgens afspraak en het verwachte routersubinterfaceadres werd ingesteld als default gateway.<br/>
De figuur hieronder geeft dit weer: <br/>
![ServersIPadresses](<images/AddressCheckServer.jpg>)
5. Zijn de pc's correct geconfigureerd volgens de adresseringstabel? <br/>
**status**:09/03/2023: allen staan op dhcp  <br/>
De figuur hieronder geeft dit weer voor de crewPCs: <br/>
![clientIPadresses](<images/AddressCheckcrewPCs.jpg>)
6. Zijn de access ports op de switch correct geconfigureerd? <br/>
**status**: De interfaces die in gebruik zijn voor de Servers en PCs zijn up.<br/>
Daarenboven behoren de interfaces tot de verwachte vlans
Op interfaces f0/20 - 21 zijn castPCs aangesloten en behoren tot vlan 30
Op interfaces f0/10 - 11 zijn crewPCs aangesloten en behoren tot vlan 40
Op interfaces f0/01 - 05 zijn servers aangesloten en behoren tot vlan 20
![SwitchPortsConfig](<images/InterfaceCheckSwitch.jpg>)
7. Is de trunk poort op de switch correct geconfigureerd? <br/>
**status**: De trunkinterface staat ingesteld op mode trunking en de vlans 20,30 en 40 zijn enabled. Ook trunking encapsulation is actief.<br/>
De figuur hieronder geeft dit weer: <br/>
![TrunkPortsConfig](<images/TrunkInterfaceCheckSwitch.jpg>)
8. Kunnen we pingen van DC naar Webserver? <br/>
**status**: ja<br/>
![DCPingWebs](<images/PingwebsCheckDC.jpg>)
9. Kunnen we pingen van DC naar PC crew? <br/>
**status**: ja<br/>
![DCPingToCrew](<images/PingwebsCheckDC.jpg>)
10. Kunnen we pingen van DC naar PC cast? <br/>
**status**: nee
Dit dient nog nagezien te worden tijdens bespreking fysiek labo. Ook Dhcp naar cast werkte niet (zie punt 5 hierboven)


## vergelijk config files Jonas - Joost
Denk dat password niet enabled is bij Jonas (voor global conf mode)=> enable password changeme ipv password changeme<br/>
Bij joost geen console password terwijl we via lab dit wel gebruiken<br/>
Bij Jonas geen vty lijnen maar gebruiken we momenteel minder <br/>
Bij jonas gebruik helper<br/>
Bij joost link van ACLs naar interfaces<br/>
**status**:Deze opmerkingen werden besproken tijdens uitwerking fysieklabo en succesvol beslist/geïmplementeerd