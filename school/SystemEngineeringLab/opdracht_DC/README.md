# System Engineering Project - Opdracht Domain controller

## **Overzicht functionaliteiten**

De server-infrastructuur omvat voor het domain een noodzakelijke Domain controller (Hostname: AgentSmith). <br/>
Deze DC wordt via een aantal powershell-scripts met bijhorende configuratiebestanden geïnstalleerd en geconfigureerd.<br/>
De scripts maken een basis VM met het besturingssysteem Windows Server 2019 (zonder GUI, enkel CLI) in VirtualBox.<br/>
O.a. volgende zaken worden geïnstalleerd/geconfigureerd:
   * Domainstructuur met OU's, users en computers:<br/>
   ![domainstructuur](pictures/Domainstructuur.jpg?raw=true)
   * DHCP-rol met scopes voor:
        * crew werkstations
        * cast werkstations
   * DNS-rol:
        * Beantwoordt alle queries binnen het domein “thematrix.local”.
        * Queries voor andere domeinen worden geforward naar een geschikte DNS-server.
        * Voor elke host binnen het domein zijn er A (IPv4), AAAA (IPv6) en PTR (IPv4 en(!)IPv6) records voorzien, in de gepaste zonebestanden.
        * Voor elke host zijn geschikte CNAME-records om de functie van een server aan te duiden (bv. www, imap, smtp, ...).
        * Voorzie waar nuttig/nodig ook andere records (bv. NS, MX, SRV, ...)
   * Persoonlijke shared folder voor iedere user (automatisch gekoppelde Y-schijf)
   * Shared folder en bijhorende groepen voor zowel crew- als cast-users (automatisch gekoppelde X-schijf)
   * GPO's die:
        * Iedereen behalve de directors de toegang tot het control panel verbieden.
        * Er voor zorgen dat niemand werkbalken (toolbars) kan toevoegen aan de taakbalk.
        * Iedere user van de cast-groep de toegang tot de eigenschappen van de netwerkadapters verbieden.
        * Enkel AD users kunnen inloggen op de PC's, lokale accounts zijn disabled.
        * Cast members kunnen enkel inloggen in de cast-Pc’s, de crew enkel op de crew-Pc’s en directors kunnen overal inloggen.

## **Links**

1. [Werkwijze installatie](werkwijze.md)
2. [Deelscripts](DeelScripts) <br/>
Elke functionele eis (vb dhcp-rol ) uit de specificatie is apart te installeren via diverse deelscripts die beschreven zijn in een lastenboek en die een aparte subdirectory hebben in de directory via bovenstaande link. Dit is vooral een history van het development process.
3. [Scripts](_GlobaalScript) <br/>
Het resultaat van de deelscripts werd samengevoegd in een 3tal scripts. Deze scripts maken gebruik van diverse csv-configuratiefiles. Deze vindt je via deze link. <br/>
4. [Lastenboek](lastenboek.md)
5. [Testen](Testen)
6. [Afbeeldingen](pictures)

De Overige folders zijn werkfolders.


