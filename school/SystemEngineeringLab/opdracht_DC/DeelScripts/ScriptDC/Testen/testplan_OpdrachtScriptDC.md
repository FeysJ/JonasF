# Testplan Opdracht : (powershell script maken voor aanmaak DC)

Auteur(s) testplan: De Craemer Joost (JoostDC)

## StartSituatie

De VM met OS (WindowsServer2019 core) is aangemaakt:
Instelling  | waarde
------------- | -------------
Processors | 1
RAM  | 2 Gb
Graf. Controller |  VBoxSVGA|
Videogeheugen |  128MB|
Adapter1 | NAT  
iso | nl_windows_server_2019_x64_dvd_82f9a152.iso

GuestAdditionsgeïnstalleerd </br>
Gedeeld klembord: bidirectioneel

Snapshot van deze toestand VM werd genomen om zo tijdens testen terug te gaan.

Voor het overplaatsen scripts en files werd een shared folder aangemaakt

## Acties

Start de VM op
Kopieer het actuele script scriptDCXXX.ps1 naar VM via de shared folder
( Ofwel, copy/paste het script vanaf de host en notepad (op de guest) naar de guest en bewaar.  )

Tips:

* powershell command om de driveLetter van de shared-folder te kennen: Get-PSDrive
* Wijzigen naar drive door `\PS> cd <driveletter>:`

Voer het script uit maar negeer de onderdelen voor het wijzigen netwerk-adapters (is onderdeel van andere taak)

## Resultaat

### wijzigen computernaam

* Beantwoord de vraag positief om computernaam te wijzigen.</br>
Geef de correcte computernaam in (AgentSmith)
(Om de wijziging te laten doorgaan dient u positief te antwoorden op de vraag om de machine te herstarten)

### promoveer de VM tot DC

* Voer het script na de herstart opnieuw uit. </br>
Skip de onderdelen over netwerk-adapters ook nu. </br>
Controleer a.d.h.v. de huidige naam of de computernaam correct werd aangepast en antwoord nu negatief de vraag tot wijzigen van de computernaam.</br>
* Antwoord positief (Y/y) op het installeren van AD DS </br>
Controleer of de installatie van ADDS opgestart wordt en voltooid wordt zonder error-messages.
* Antwoord positief op het aanmaken van domein TheMatrix.local (Y/y)
* Doorloop de stappen voor de aanmaak van het domein</br>
Geef een SafeModeAdminPaswoord in (voorstel: AgentSmith2023) en bevestig het bij de vraag naar 2de ingave.
* Controleer of de computer automatisch herstart na de voltooiing van de aanmaak domein.</br>
Heb vervolgens geduld en wacht tot de boodschap "computerinstellingen toepassen" verdwijnt.</br>
opm: dit duurt zeer lang en er is geen progress bar of andere indicatie of de configuratie loopt.

### Wijzig de sitename

* Voer het script na de herstart opnieuw uit. </br>
Skip de onderdelen over netwerk-adapters opnieuw maar skip nu ook de installatie ADDS en de aanmaak forest. </br>
Beantwoord positief de vraag om de sitenaam te wijzigen (default optie leidt tot site-name "SiteTi02")

### finale tests

* Start powershell op en controleer tot slot nog a.d.h.v. een aantal manuele commando's:</br>
    * Controleer de computernaam:</br>
    PS> $env:COMPUTERNAME
    * Controleer het forest: </br>
    PS> $ster=Get-ADDomain</br>
    PS> $ster.forest
