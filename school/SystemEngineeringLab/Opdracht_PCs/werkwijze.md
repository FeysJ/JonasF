# System Engineering Project - Opdracht uitrollen PC 

De opdracht TheMatrix.local bevat de aanmaak van een PC. <br/>
De installatie en configuratie gebeurt door een script dat gebruik maakt van een hulpscript (win_postinstall.cmd). 
De scripts maken geen gebruik van configuratie-files. <br/>
Alle scripts en hulpfiles zijn te vinden in de folder [Scripts](Scripts)

## **Werkwijze** 

Maak op je host een folder aan die als shared folder zal fungeren (virtuele machine van de cast- of crewPC krijgt automatisch toegang via de scripts) en bevat o.a. de files die het hoofdscript (vb install_Win10.ps1) nodig heeft voor de configuratie.<br/>
De folder structuur binnen de shared folder moet zijn:<br/>
* .\project\scripts <br/>Hier worden de scripts geplaatst:
    * install_Win10.ps1
    * win_postinstall.cmd <br/>
> > De overige txt-files zijn hulpbestanden om de invoer foutloos via copy/paste te doen.<br/>
>Een voorbeeld van deze structuur vind je hieronder:<br/>
>![[Afbeelding directoryStructuur]](Images/directoryOrganisatieScripts.jpg)<br/>
* .\project\csv <br/>
Momenteel bevat deze geen configuratieFiles
* .\project\keys<br/>
Bevat de private en de public key om ssh toe te laten naar de linux-machines.
Een voorbeeld van deze structuur vind je hieronder:<br/>
![[Afbeelding directoryStructuur]](Images/directoryOrganisatieKeys.jpg)<br/>

### **Algemene variabelen**
Er dienen geen variabelen aangepast te worden in het script. <br/>
De noodzakelijke gegevens worden opgevraagd via cli.
Download het iso-bestand (Windows10.iso)

### **uitvoering**
* Start de domein controller op. <br/>
Een actieve domeincontroller is nodig om de PC toe te voegen aan het domein.
* Run het script install_Win10.ps1 <br/> 
Dit script maakt de VM aan voor de domein-PC (crew-PC of cast-PC). <br/> 
Run dit script vanop de host PC. Doe dit via powershell vanuit de locatie/prompt `<path sharedFolder`>\project\scripts 
Via cli wordt er gevraagd naar:
    * Naam machine <br/> 
    (opm: In de domeinstructuur zijn nu volgende PCs opgenomen: PCCast1, PCCast2, PCCrew1, PCCrew2 en DirectorPC)
    * absoluut pad van het iso-bestand 
    * absoluut pad voor de locatie waar je de vdi wenst te plaatsen
    * absoluut pad van de folder die je als shared folder tussen VM en host wenst te gebruiken.
    * absoluut pad van het postinstall-script (win_postinstall.cmd)
* Afhankelijk van je keuze die je maakt via cli, voorziet het script deze VM vervolgens van een bridged adapter (keuze i.g.v. fysiek labo) of internal netwerk adapter (keuze i.g.v. laptop simulatie)<br/>
Opm: Indien er gekozen werd voor internal netwerk, dient er ook gekozen te worden voor een cast of crew PC. Dit om het relevante internal netwerk toe te wijzen aan de internal adapter. Respecievelijk internal netwerk "crew" in geval van een crew-PC en "cast" in geval van een cast-PC.<br/>
Voor de fysieke labo's (i.g.v. keuze bridged adapter) is de keuze (crew/cast) niet nodig omdat de PC tot een subnet wordt ingedeeld d.m.v. aangesloten switch-port (met bijhorend vlan) en intervlan routing. <br/>
![[VoorbeeldIngaveCli]](Images/CliIngaveScript.jpg)<br/>
* Vervolgens voorziet het script toegang tot de shared folder (host <> VM), installeert windows10.<br/>
* Tijdens de aanmaak VM, wordt een post-install-script (win_postinstall.cmd) aangesproken.
Dit post-install-script selecteert de taal en installaleert de guest-editions.
Nadat de guest-editions geïnstalleerd zijn, kiest u echter voor "I want to manually reboot later"! <br/>
![[EindeguestEditons]](Images/EindeguesteditionsSmall.jpg)<br/>
* Daardoor loopt het postinstall-script verder en wordt er naar credentials gevraagd om de PC zo toe te voegen aan het domein.<br/>
(domein-user: administrator; password: VeranderMij%123) <br/> 
![[IngaveCred]](Images/IngaveCredentials.jpg)<br/>
* Omdat de VM toegevoegd wordt aan het domein, voert het script een noodzakelijke restart uit<Br/>
Na deze herstart, krijgt de VM ook toegang tot de shared folder omdat zo ook de guest-editions geactiveerd worden.<br/>
![[RestartAdvies]](Images/RestartAdvies.jpg)<br/>

## Werkwijze voor Windows machines om SSH te kunnen doen naar de Linux servers
1. Bepaal welke Windows gebruiker SSH moet kunnen doen naar de Linux machines.
2. Log met deze gebruiker in op de windows machine.
3. Maak voor deze gebruiker op de locatie `C:\Users\<GEBRUIKERSNAAM>` een map aan met de naam ".ssh", indien deze nog niet bestaat.
4. Kopieer de private en de public key uit `Z:\project\keys` naar de nieuw aangemaakte map `C:\Users\<GEBRUIKERSNAAM>\.ssh` <br/>
De keys vindt u hier: [keys](../../Gedeelde_Map_Windows/project/keys)

Op de Linux machines werd de public key reeds toegevoegd aan de "authorized hosts" voor de gebruiker **Vagrant**. Indien SSH nodig zou zijn voor een andere Linux gebruiker, moet de public key voor deze gebruiker toegevoegd worden aan het bestand `/home/<LINUX-GEBRUIKERSNAAM>/.ssh/authorized_keys`. Voor een snelle demo is deze stap niet meer nodig en zou het volstaan om nu via de CLI het commando `ssh vagrant@<ip-adres Linux-machine>` uit te voeren.

## Toevoeging RSAT voor DirectorPC
Servers dienen via RSAT vanop de DirectorPC (Windows 10) kunnen geconfigureerd worden. <br/>
Open een powershell venster als administrator op de DirectorPC en voer het script **install_RSAT.ps1** uit. <br/>
Het script vindt u hier : [install_RSAT.ps1](./RSAT) <br/>
Het testplan en -rapport is een mooie quickguide voor de mogelijkheden: [testrapport](./RSAT/testrapport.md)
