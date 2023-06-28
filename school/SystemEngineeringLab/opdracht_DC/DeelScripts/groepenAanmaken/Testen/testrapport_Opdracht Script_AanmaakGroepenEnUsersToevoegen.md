# Testrapport Opdracht : Powershell script voor aanmaak SharedFolders voor groepen cast en crew

## Test 1

Uitvoerder(s) test: Lara Van Wynsberghe
Uitgevoerd op: 24/04/2023
Github commit:  71b40dbbab110f88e2d0ee2a60da1388ff4cbeeb

## Resultaten

### Run script vanaf de startsituatie

* Beantwoord de vraag naar de locatie van de csv-file (groups.csv) of behoud de default locatie. 
* Lees de boodschappen goed en controleer of de groep GRP_crew, GRP_cast en GRP_directors aangemaakt worden.
<br/> **resultaat: in orde. De groepen bestonden nog niet en werden aangemaakt.**
* Opm: Vooraleer de aanmaak van een nieuwe groep wordt gestart, krijg je telkens berichten over de aanmaak van de bijhorende users die toegevoegd worden aan de groep.
<br/> **resultaat: De melding zegt "user \<voornaam familienaam> wordt toegevoegd als lid van de groep \<naam van de groep>**
* De eerste run van het script dient foutloos te verlopen.
<br/> **resultaat: in orde**
* Controleer via cmd-let PS> Get-ADgroup -filter * | Select-object name , of de groepen GRP_crew, GRP_cast en GRP_ directors ook aanwezig zijn in de lijst van alle aanwezige groepen. 
<br/> **resultaat: De nieuwe groepen staan onderaan in de lijst.**
* Doe een steekproef via cmd-let PS> Get-ADGroupMember -identity `<groupname`> | Select-object name <br/>
En controleer of de gewenste gebruikers toegevoegd zijn aan de groep. Bijv:<br/>
    * Get-ADGroupMember -identity GRP_Cast | Select-object name<br/>
    * Get-ADGroupMember -identity GRP_Crew | Select-object name<br/>
    * Get-ADGroupMember -identity GRP_directors | Select-object name<br/>

    **resultaat: GRP_Cast: ok; GRP_Crew: ok; GRP_directors: ok**

### Run het script een 2de maal

* Lees de boodschappen en controleer of het script foutloos loopt.
<br/> **resultaat: Het script loopt foutloos. Voor elke groep verschijnt de volgende booschap: "\<naam groep> bestaat reeds als groep en werd niet aangemaakt. User \<naam user> is al lid van de groep \<naam groep> en werd niet nogmaals toegevoegd."**
* Volg of er geen boodschap verschijnt waarbij gemeld wordt dat een groep werd aangemaakt of dat er een user werd toegevoegd (Bij de 1ste run van het script, werden de groepen immers reeds aangemaakt en werden de users toegevoegd).<br/>Voor alle groepen en users verschijnt respectievelijk de boodschap "$naam `tbestaat reeds als groep en werd niet aangemaakt" of "user $username is al lid van de groep ..."
<br/> **resultaat: in orde**
* Controleer na beëindigen van het script of de lijst identiek is gebleven via cmd-let `PS> Get-ADgroup -filter | Select-Object name`
<br/> **resultaat: in orde**

### Run script vanaf een a-specifieke situatie

Delete één van de 2 gecreeerde groepen d.m.v. cmdlet PS> Remove-ADgroup -identity `<groupname`> bijv: <br/>
> Remove-ADgroup -identity GRP_Cast    <br/>

Delete ook één van de users uit een andere groep d.m.v. cmdlet  PS> Remove-ADGroupMember -identity `<groupname`> -members `<SamName`> Bijv: <br/>
> Remove-ADGroupMember -identity GRP_crew -members Joel.Silver <br/>

Run het script opnieuw <br/>
* Lees alle boodschappen en controleer of het script opnieuw foutloos loopt
<br/> **resultaat: De groep GRP_Cast werd verwijderd. Bij het opnieuw runnen van het script verschijnt bij deze groep de melding "GRP_Cast bestaat nog niet als groep en wordt aangemaakt." Bij de andere groepen verschijnt de melding "\<naam groep> bestaat reeds als groep en werd niet aangemaakt."**
* Bemerk of de enkel meldingen verschijnen dat de verwijderde groep of user wordt aangemaakt/toegevoegd
<br/> **resultaat: Enkel de verwijderde groep GRP_Cast en bijbehorende gebruikers werden opnieuw toegevoegd, alsook de verwijderde gebruiker uit de groep GRP_Crew.**
* Controleer na beëindigen script of de lijst identiek is gebleven via cmd-let PS>Get-ADgroup -filter * | Select-Object name .
<br/> **resultaat: in orde**

**Algemene opmerking:** De spaties in de omschrijving van de groep zijn ongeldige tekens geworden. Hiervoor werd een bug issue (SEP2223T02-154) aangemaakt.
