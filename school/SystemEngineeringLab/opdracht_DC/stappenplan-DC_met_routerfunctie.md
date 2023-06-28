# Stappenplan voor de installatie van de DC (voorlopige manuele versie)

locatie ISO-bestand: op teams gezet onder 'bestanden'

## Installatie Windows server

- hostname: agentsmith
- gebruiker: administrator
- wachtwoord: changeme
- Guest additions installeren
- CPU: 1 (default)
- RAM: 2GB
- Disk space: 50GB (default)
- Netwerk:
    - 1 NAT-adapter
    - 1 intnet adapter met de naam Servers
    - 1 intnet adapter met de naam Crew
    - 1 intnet adapter met de naam Cast

De default toetsenbordindeling is querty. Om deze aan te passen naar azerty, doe je het volgende:

1. open powershell (via CMD): `start powershell`
2. voer dit commando uit: `Set-WinUserLanguageList nl-BE`

## Shared folder aanmaken

zie File-Sharing.md

## Installatie van de AD role

Script: Zie de map ScriptDC (script runnen: ScriptDC2023_03_03)

## Toekomstig script dat volgend doet 
1. keuze maakt tussen fysieke machines / internal netwerk
2. in geval van gesimuleerd netwerk met internal netwerk
    * adapters instellen
    * router rol installeren
3. in geval van fysieke toestellen 
    * adapters instellen
4.  dhcp rol installeren

## dns script 

Script: zie de map scriptdns

## OU's aanmaken

script runnen: ScriptOU

## Computers en users importeren

Zie de map import_users_computers

## Groepen aanmaken en users toevoegen 

zie de map groepenaanmaken. script: alle_users_OU_naar_groep.ps1

## shared folders aanmaken voor crew en cast

zie map "Opstellen shared-folder".

## GPOs

is nog under investigation door Lara
