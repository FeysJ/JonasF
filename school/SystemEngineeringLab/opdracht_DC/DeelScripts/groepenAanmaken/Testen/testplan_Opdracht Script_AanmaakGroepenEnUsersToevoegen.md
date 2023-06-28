# Testplan Opdracht : Powershell script voor aanmaak SharedFolders voor groepen cast en crew

## Auteur(s) testplan: De Craemer Joost (JoostDC)

## StartSituatie

1. De VM met OS (windowsServer2019 core) is aangemaakt
Active Directory Domain Services zijn geïnstalleerd en de promotie naar DC is gebeurd (d.m.v. script scriptDC2023_03_05.ps1)
2. Via csv-file (OUs.csv) zijn de OUs van de domeinstructuur aangemaakt (d.m.v. script ScriptOUs2023_03_* )
3. Via CSV-file (users_en_computers.csv) zijn de gebruikers en Computers geïmporeerd (gebruik script import-users_computers.ps1)
4. Sluit de VM af en neem een snapshot om het script verschillende keren te kunnen runnen vanaf de startsituatie. 

Opmerking : Installatie van de rollen DNS en DHCP zijn niet nodig om deze opdracht te testen

## Acties

* Kopieer Groups.csv en het actuele SharedFoldersDC_NoHardCodedVars.ps1 naar VM via de shared folder (shared tussen Guest en Host). De default locatie voor deze opdracht en files is Z:\project\scripts en Z:\project\csv.
* Start het script op

## Resultaten

### Run script vanaf de startsituatie

* Beantwoord de vraag naar de locatie van de csv-file (groups.csv) of behoud de default locatie. 
* Lees de boodschappen goed en controleer of de groep GRP_crew, GRP_cast en GRP_directors aangemaakt worden.
<br/> **resultaat:** 
<br/>Opm: Vooraleer de aanmaak van een nieuwe groep wordt gestart, krijg je telkens berichten over de aanmaak van de bijhorende users die toegevoegd worden aan de groep. <br/> 
**resultaat:** 
* De eerste run van het script dient foutloos te verlopen.
<br/> **resultaat:**
* Controleer via cmd-let PS> Get-ADgroup -filter * | Select-object name , of de groepen GRP_crew, GRP_cast en GRP_ directors ook aanwezig zijn in de lijst van alle aanwezige groepen. 
<br/> **resultaat:**
* Doe een steekproef via cmd-let PS> Get-ADGroupMember -identity `<groupname`> | Select-object name <br/>
En controleer of de gewenste gebruikers toegevoegd zijn aan de groep. Bijv:<br/>
    * Get-ADGroupMember -identity GRP_Cast | Select-object name<br/>
    * Get-ADGroupMember -identity GRP_Crew | Select-object name<br/>
    * Get-ADGroupMember -identity GRP_directors | Select-object name<br/>
**resultaat:**

### Run het script een 2de maal

* Lees de boodschappen en controleer of het script foutloos loopt.
<br/> **resultaat:**
* Volg of er geen boodschap verschijnt waarbij gemeld wordt dat een groep werd aangemaakt of dat er een user werd toegevoegd (Bij de 1ste run van het script, werden de groepen immers reeds aangemaakt en werden de users toegevoegd).<br/>Voor alle groepen en users verschijnt respectievelijk de boodschap "$naam `tbestaat reeds als groep en werd niet aangemaakt" of "user $username is al lid van de groep ..."
<br/> **resultaat:**
* Controleer na beëindigen van het script of de lijst identiek is gebleven via cmd-let PS> Get-ADgroup -filter * | Select-Object name  <br/> **resultaat:**

### Run script vanaf een a-specifieke situatie

Delete één van de 2 gecreeerde groepen d.m.v. cmdlet PS> Remove-ADgroup -identity `<groupname`> bijv: <br/>
> Remove-ADgroup -identity GRP_Cast    <br/>

Delete ook één van de users uit een andere groep d.m.v. cmdlet  PS> Remove-ADGroupMember -identity `<groupname`> -members `<SamName`> Bijv: <br/>
> Remove-ADGroupMember -identity GRP_crew -members Joel.Silver <br/>

Run het script opnieuw <br/>
* Lees alle boodschappen en controleer of het script opnieuw foutloos loopt
<br/> **resultaat:**
* Bemerk of de enkel meldingen verschijnen dat de verwijderde groep of user wordt aangemaakt/toegevoegd
<br/> **resultaat:**
* Controleer na beëindigen script of de lijst identiek is gebleven via cmd-let PS>Get-ADgroup -filter * | Select-Object name . 
<br/> **resultaat:**
