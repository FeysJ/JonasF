# Testplan Opdracht DC: Het aanmaken van de OU's via Powershell

Auteur(s) testplan: Lara Van Wynsberghe

## Startsituatie

* Een standaard Windows server werd geïnstalleerd.
* Active Directory Domain Services zijn geïnstalleerd en de promotie naar DC is gebeurd (d.m.v. script )
* Een gedeelde map werd aangemaakt, met hierin de nodige scripts en csv-bestand (OUs.csv)
* Het script om van de server een domain controller te maken, werd uitgevoerd (scriptDC2023_03_05.ps1)
* Neem een snapshot om verschillende scenario's te testen

## Uit te voeren acties

Zet het CSV-bestand op de default locatie (shared folder Z:\project\csv) en voer het script scriptOUs20230305.ps1 uit.

## Resultaten

### Run script vanaf de startsituatie

1. Controleer in ADUC of na het uitvoeren van het script, de nodigeOU's werden aangemaakt.
Powershell cmd-let PS> Get-ADOrganizationalUnit -filter * | Select-Object name, distinguishedName
<br/> **resultaat:** 

### Run script vanaf de a-specifieke locatie

Zet het CSV-bestand op een andere locatie en voer het script opnieuw uit. Vanaf deze locatie moet script evenzeer foutloos runnen.

1. De OU's die de vorige keer werden aangemaakt, worden nu niet opnieuw aangemaakt. Dit wordt voor iedere OU via de console gemeld.
<br/> **resultaat:** 

2. Controleer of alle OUs nog aanwezig zijn via Powershell cmd-let PS> Get-ADOrganizationalUnit -filter * | Select-Object name, distinguishedName
<br/> **resultaat:** 

### run script na verwijderen van een aantal OUs

Verwijder een aantal OUs. Besef echter dat OUs zijn beschermd tegen accidental deletion. Daarom is parameter.

1. Roep de lijst van OUs nogmaals op via Powershell cmd-let PS> Get-ADOrganizationalUnit -filter * | Select-Object name, distinguishedName . Bepaal een OU die je wilt wissen
2. Wijzig het kenmerk "Protect object from accidental deletion"van de OU die je wilt wissen naar false. Bijv: <br/>
Set-ADObject -Identity "OU=cast,OU=DomainUsers,DC=TheMatrix,DC=local" -ProtectedFromAccidentalDeletion $false
<br/> **resultaat:** 
3. Wis één of meerdere OUs. Bijv: <br/>
Remove-ADOrganizationalUnit -Identity "OU=cast,OU=DomainUsers,DC=TheMatrix,DC=local" -Recursive 
<br/> **resultaat:** 
4. Run het script nogmaals en detecteer of script foutloos loopt.
<br/> **resultaat:** 
5. Volg de uitvoer en detecteer of enkel voor de gewiste OU (en zijn child OUs), de boodschap volgt dat hij wordt aangemaakt. 
<br/> **resultaat:** 
6. Controleer of alle OUs nog aanwezig zijn via Powershell cmd-let PS> Get-ADOrganizationalUnit -filter * | Select-Object name, distinguishedName
<br/> **resultaat:** 
