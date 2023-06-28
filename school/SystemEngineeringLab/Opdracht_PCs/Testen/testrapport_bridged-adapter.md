# Testrapport Opdracht PC's Bridged adapter


## Test 1

Uitvoerder(s) test: Jonas Feys <br/>
Uitgevoerd op: 23/05/2023 <br/>
Github commit:  COMMIT HASH <br/>
Auteur(s) testplan: Lara Van Wynsberghe <br/>

## Startsituatie

* Een lokale map op de fysieke host pc is aanwezig voor het delen van bestanden met de VM.
* Een Windows 10 iso (gedeeld via Teams) is aanwezig op de fysieke host.
* Er is voldoende vrije schijfruimte om de VM aan te maken.
* De guest additions iso bevindt zich op 'C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso'

## Testen en verwachte resultaten

1. Voer het script 'install_Win10.ps1' uit. Kies voor een "bridged adapter". Controleer nu in Virtualbox onder 'instellingen' > 'netwerk' op de nieuwe VM of een bridged adapter werd ingesteld.

> RESULTAAT: OK

2. Voer het script 'install_Win10.ps1' opnieuw uit en geef een nieuwe PC-naam in. Kies voor een Cast-PC. Controleer nu in Virtualbox onder 'instellingen' > 'netwerk' op de nieuwe VM of een intnet-adapter werd aangemaakt in het ingegeven netwerk (cast).

> RESULTAAT: OK

3. Voer het script 'install_Win10.ps1' opnieuw uit en geef een nieuwe PC-naam in. Kies voor een Crew-PC. Controleer nu in Virtualbox onder 'instellingen' > 'netwerk' op de nieuwe VM of een intnet-adapter werd aangemaakt in het ingegeven netwerk (crew).

> RESULTAAT: OK
