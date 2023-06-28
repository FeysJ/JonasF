# Testplan Opdracht PC's: Het uitrollen van de PC's via powershell

Auteur(s) testplan: Lara Van Wynsberghe

## Startsituatie

* De domain controller is opgestart en het domain is aanwezig (om de computer aan het domein toe te kunnen voegen en een ip-adres te krijgen).
* DHCP is geïnstalleerd op de DC.
* De DC heeft een intnet-adapter in het subnet van de aan te maken pc.
* Een lokale map op de fysieke host pc is aanwezig voor het delen van bestanden met de VM.
* Een Windows 10 iso (gedeeld via Teams) is aanwezig op de fysieke host.
* Er is voldoende vrije schijfruimte om de VM aan te maken.
* De guest additions iso bevindt zich op 'C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso'

## Testen en verwachte resultaten

1. Voer het script 'install_Win10.ps1' uit.
    * Het invoeren van een ongeldige naam voor de VM, breekt het script af. (ongeldig = te korte of een reeds bestaande naam)
    * Het invoeren van een ongeldige locatie voor de gedeelde map, breekt het script af.
    * Het invoeren van een ongeldig iso-bestand, breekt het script af.
    * Het invoeren van een ongeldige locatie voor de VM, breekt het script af.
    * Het invoeren van een ongeldig netwerk, breekt het script af.
2. Als de VM klaar is met opstarten, verschijnt het postinstall script.
   * Het eerste commando zorgt ervoor dat het toetsenbord wordt omgeschakeld naar azerty.
   * Het tweede commando maakt het mogelijk om manueel de guest additions te installeren. **LET OP: Klik NIET op reboot now, maar stel het rebooten uit totdat de pc werd toegevoegd aan het domein.**
   * Het derde commando voegt de PC toe aan het domein. Geef de credentials in van de domain admin. **De PC wordt nu vanzelf herstart.**
3. Controleer in Virtualbox onder 'instellingen' > 'netwerk' op de nieuwe VM of een intnet-adapter werd aangemaakt in het ingegeven netwerk (crew of cast).
4. Controleer of de VM een geldig ip-adres heeft gekregen (of dit in het juiste subnet is, hangt samen met de testen van de DHCP-server)
5. Controleer de hostname:
    1. De hostname van de PC, heeft dezelfde naam als de aangemaakte VM. Controleer de hostname met het PowerShell commando `hostname`.
6. Controleer de toetsenbordinstelling en toevoeging aan het domein
    1. Het script opent na een volledige installatie een powershell script dat het toetsenbord instelt op azerty en de computer toevoegt aan het domein. Controleer of dit script verschijnt.
    2. Voer de credentials in van de domain admin (administrator) om de computer toe te voegen. Hierna herstart de PC
    3. Log in met een domain user, zoals Lilly Wachowski (als de GPO's actief zijn, zal inloggen met het lokale administrator account niet meer mogelijk zijn) en controleer of de PC werd toegevoegd aan het domein. Voer hiervoor het PowerShell commando `systeminfo | Select-String "Domain"`uit.
7. Verifieer dat de guest additions werden geïnstalleerd (wacht voldoende lang tot de VM herstart wordt).
    1. Ga bovenaan in het menu van virtualbox van de VM naar "Machine" en klik op "Sessie-informatie..."
    2. Op het tabblad Runtime-informatie moet er bij Guest Additions een versienummer staan. Indien er "Niet ontdekt" staat, zijn de guest additions niet geïnstalleerd.
