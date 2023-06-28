# Testrapport Opdracht DC: Shared folders

## Test Shared folders

Uitvoerder(s) test: Liam Robyns
Uitgevoerd op: 28-03-2023
Github commit:  c87707b2afd7d65f3eb98f7d0f0c32bd61ffc19a

## StartSituatie

1. De VM met OS (windowsServer2019 core) is aangemaakt
Active Directory Domain Services zijn geïnstalleerd en de promotie naar DC is gebeurd (d.m.v. script scriptDC2023_03_05.ps1)
2. Via csv-file (OUs.csv) zijn de OUs van de domeinstructuur aangemaakt (d.m.v. script ScriptOUs2023_03_* )
3. Via CSV-file (users_en_computers.csv) zijn de gebruikers en Computers geïmporeerd (gebruik script import-users_computers.ps1)
4. Via import csv-file (groups.csv) zijn de groepen aangemaakt (d.m.v. script scriptOUs2023_03_05.ps1) 
5. Sluit de VM af en neem een snapshot om het script verschillende keren te kunnen runnen vanaf de startsituatie. 

Opmerking : Installatie van de rollen DNS en DHCP zijn niet nodig om deze opdracht te testen

## Acties

* Kopieer Groups.csv en het actuele SharedFoldersDC_NoHardCodedVars.ps1 naar VM via de shared folder (shared tussen Guest en Host). 
De default locatie voor deze opdracht en files is C:\Users\Administrator\desktop
* Start het script op

## Resultaten

### Run script vanaf de startsituatie

Beantwoord de vraag naar de locatie van de csv-file (groups.csv) of behoud de default locatie.

* Lees de boodschappen goed en controleer of de folders voor de shared folders aangemaakt worden
* Lees de boodschappen goed en controleer of de smb_shares aangemaakt worden voor de groepen crew en cast.
* Controleer via cmd-let PS> Get-SmbShare of de shares ook aanwezig zijn in de lijst van alle aanwezige sharedFolders. 
* Controleer specifiek of de groep GRP_Directors geen shared heeft bekomen via cmd-let PS>Get-SmbShare -Name "ShareGRP_Directors.

OK, folders te vinden onder shares en sambashares te zien bij Get-SmbShare.

### Run het script een 2de maal

* Lees de boodschappen en controleer of het script foutloos loopt.
* Volg of er geen boodschap verschijnt waarbij gemeld wordt dat een share is aangemaakt (Bij de 1ste run script werden ze immers aangemaakt)
* Controleer na beëindigen script of de lijst identiek is gebleven via cmd-let PS>Get-SmbShare. 

OK, het slaagt de creatie over.

### Run script vanaf een a-specifieke situatie

Delete één van de 2 gecreeerde shares d.m.v. cmdlet PS> Remove-SmbShare  -name ShareGRP_cast
Run het script opnieuw

* Lees alle boodschappen en controleer of het script opnieuw foutloos loopt
* Bemerk of de enkel melding verschijnt dat de shared folder ShareGRP_cast wordt aangemaakt
* Controleer via cmd-let PS> Get-SmbShare of de shares ook aanwezig zijn in de lijst van alle aanwezige sharedFolders. 
* Controleer specifiek of de groep GRP_cast opnieuw een shared heeft bekomen via cmd-let PS>Get-SmbShare -Name "ShareGRP_cast.

OK, SmbShare wordt opnieuw aangemaakt zonder foutmelding.
De reeds bestaande wordt nog steeds overgeslagen zoals verwacht.

### Testen van de toegankelijkheid van sharedFolders door gebruikers

Log in met volgende gebruikers op een PC (vb DirectorPC) in het domein en controleer volgend:

* inloggen als Lana Wachowski en nazien of er toegang is tot de share "ShareCrew" maar niet tot de share "ShareCast" 
OK, add shared folder.
* inloggen als Keanu Reeves en nazien of er toegang is tot de share "ShareCast" maar niet tot de share "ShareCrew"
OK, add shared folder.
