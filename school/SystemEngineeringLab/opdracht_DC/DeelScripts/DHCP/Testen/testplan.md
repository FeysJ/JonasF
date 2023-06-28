# Testplan Opdracht 3.3: DC deel DHCP

Auteur(s) testplan: Lara Van Wynsberghe

## Voorwaarden om te kunnen testen

De volgende zaken zijn reeds geïnstalleerd:

* volledig opgezette DC
* Een router met minstens de volgende netwerkadapters:
    * intnet adapter voor de server (DC)
    * intnet adapter voor de cast
    * intnet adapter voor de crew
* een PC voor de cast in het vlan (intnet adapter) van de cast
* een PC voor de crew in het vlan (intnet adapter) van de crew

**Indien de DC als router wordt gebruikt, wordt het ip-adres van de DC hetzelfde als de gateway voor dat vlan.**

## Teststappen voor de DHCP-implementatie

1. Log in met het account van een director, zoals Lilly Wachowski op een Cast PC en zorg dat deze een dynamisch IP toegewezen krijgt. Voer eventueel de commando's `ipconfig /release`, gevolgd door `ipconfig /renew` uit. Het nieuwe IP-adres dat via DHCP ontvangen zou moeten worden, zou in de range 192.168.168.66 - 192.168.168.126 moeten zitten.
2. Log in met het account van een director, zoals Lilly Wachowski op een Crew PC en zorg dat deze een dynamisch IP toegewezen krijgt. Voer eventueel de commando's `ipconfig /release`, gevolgd door `ipconfig /renew` uit. Het nieuwe IP-adres dat via DHCP ontvangen zou moeten worden, zou in de range 192.168.168.2 - 192.168.168.62 moeten zitten.
