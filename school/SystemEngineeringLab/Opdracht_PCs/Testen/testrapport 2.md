# Testrapport Opdracht PC's: Het uitrollen van de PC's via powershell



## Test JoostDC

Uitvoerder(s) test: De Craemer Joost
Uitgevoerd op: 18/03/2023
Github commit:  COMMIT HASH

### Testen uitgevoerd a.d.h.v:
* SEP-2223-sep-2223-t02\Opdracht_PCs\testplan.md (datum van 16/03/2023 (Lara Van Wynsberghe))
* vorige testrapport was verwerkt ()
* script: install_Win10.ps1
* Startsituaties van het testplan:
    * De domain controller is opgestart en het domain is aanwezig (om de computer aan het domein toe te kunnen voegen en een ip-adres te krijgen).
    * De DC heeft een intnet-adapter in het subnet van de aan te maken pc.
    * Een lokale map op de fysieke host pc is aanwezig voor het delen van bestanden met de VM.
    * Een Windows 10 iso (gedeeld via Teams) is aanwezig op de fysieke host.
    * Er is voldoende vrije schijfruimte om de VM aan te maken.
    * De guest additions iso bevindt zich op 'C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso'

### Testresultaten
1. Voer het script 'install_Win10.ps1' uit.
    * Het invoeren van een ongeldige naam voor de VM, breekt het script af. (ongeldig = minder dan 3 tekens of een reeds bestaande naam)</br>
    **Resultaat:** nok: Ingave van de naam "ko" brak het script niet af
    * Het invoeren van een ongeldige locatie voor de gedeelde map, breekt het script af.</br>
    **Resultaat:**  ok: Script brak af na ingave van locatie Z:\joost
    * Het invoeren van een ongeldig iso-bestand, breekt het script af.</br>
    **Resultaat:**  ok 
    * Het invoeren van een keuze [crew/cast], breekt het script af.</br>
    **Resultaat:**  ok, keuze "POL", brak het script af
    * Het invoeren van een ongeldige locatie voor vd-bestand voor de VM , breekt het script af.</br>
    **Resultaat:**  ok. Locatie Q:, brak het script af.
    * invoeren van een ongeldige post-install script, breekt het script af:
    **Resultaat:**  ok. Enkel "C:\Joost files\Bachelor ICT\system engineering project\SharedFolder\win_postinstall.cmd" breekt het script niet af.
    * Het invoeren van een ongeldig netwerk, breekt het script af.</br>
    **Resultaat:**  
2. Controleer in Virtualbox onder 'instellingen' > 'netwerk' op de nieuwe VM of een intnet-adapter werd aangemaakt in het ingegeven netwerk (crew of cast).</br>
**Resultaat:**   ok
3. Controleer of de VM een geldig ip-adres heeft gekregen (of dit in het juiste subnet is, hangt samen met de testen van de DHCP-server)<br/>
**Resultaat:**  Dit was initieel niet het geval. De reden was dat de naam van internalNetwerk voor de machine (intnet = "crew") en de domeincontroller (intnet ="IntnetCrew") niet gelijk was.<br/> Na het aanpassen van de naam van internalNetwerk op de DC, werd het adres goed ontvangen. Een ping naar 192.168.168.129 slaagde vervolgens ook. 
4. Controleer de hostname:
    1. De hostname van de PC, heeft dezelfde naam als de aangemaakte VM. Controleer de hostname met het PowerShell commando `hostname`.</br>
    **Resultaat:** ok, In mijn geval hebben VM en host de naam "CrewTestScript" voor de aanmaak van een crew-VM
5. Controleer de toetsenbordinstelling en toevoeging aan het domein
    1. Het script opent na een volledige installatie een powershell script dat het toetsenbord instelt op azerty en de computer toevoegt aan het domein. Controleer of dit script verschijnt.
    **Resultaat:** niet ok, Dit zie ik niet verschijnen
    2. Voer de credentials in van de domain admin (administrator) om de computer toe te voegen. Hierna herstart de PC
    **Resultaat:** niet ok, Pc is nog lid van workgroep en niet toegevoegd aan domain.
    3. Log in met een domain user, zoals Lilly Wachowski (als de GPO's actief zijn, zal inloggen met het lokale administrator account niet meer mogelijk zijn) en controleer of de PC werd toegevoegd aan het domein. Voer hiervoor het PowerShell commando `systeminfo | Select-String "Domain"`uit.
    **Resultaat:** niet ok. PC is nog lid van workgroep. Via `systeminfo | Select-String "Domain"`, wordt dit bevestigd met info "Domain:       WORKGROUP".
6. Verifieer dat de guest additions werden geïnstalleerd (wacht voldoende lang tot de VM herstart wordt).
    Sinds het postinstall script werd toegevoegd, werkt dit niet meer automatisch. Aan het postinstall script werd nu de manuele versie toegevoegd. **Het is beter te wachten met rebooten, tot de PC aan het domain is toegevoegd** via het volgende commado in hetzelfde postinstall script.
    1. Ga bovenaan in het menu van virtualbox van de VM naar "Machine" en klik op "Sessie-informatie..."
    2. Op het tabblad Runtime-informatie moet er bij Guest Additions een versienummer staan. Indien er "Niet ontdekt" staat, zijn de guest additions niet geïnstalleerd.
</br>**Resultaat:** niet gelukt, Dit alhoewel de guest editions geïnstalleerd werden.


