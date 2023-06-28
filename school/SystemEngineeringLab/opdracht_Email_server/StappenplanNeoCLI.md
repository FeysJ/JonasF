# Installatie Neo mailserver

## Voorbereiding

- Download de nodige installatietools via teams bestanden en download de iso van exchange (https://downloads.academicsoftware.eu/Microsoft/Exchange%20Server%202019%20Standard/mul_exchange_server_2019_cumulative_update_12_x64_dvd_52bf3153.iso).
- Plaats alles in een map die daarna de shared folder wordt
- pas de csv file `Paths.csv` aan voor VBoxManage script
- DomeinController dient klaar te staan om de mailserver toe te kunnen voegen aan het domein en voor integratie, deze dient ook steeds operationeel te zijn tijdens installatie

## Commando's

`powershell` => starten van powershell in cmd omgeving
`Get-Volume` om de mounted drives te zien
`d:`of `z:` om naar folder te gaan
switchen van user:
    - Ctr + alt + del
    - selecteer andere gebruiker
    - Ctr + alt + del
    - 2 x escape
    - selecteer andere gebruiker
    - gebruikersnaam: thematrix.local\administrator
`shutdown /r` herstarten
`shutdown /P` afsluiten

## Stappenplan installatie 

1. Voer het VBoxManage script uit `1.install_Server2019` om de virtuele machine aan te maken
2. open powershell door commando `powershell`uit te voeren en ga naar de shared folder via `z:`
3. script `2.Neo_config.ps1` uitvoeren, naam deels ingeven en vervolledigen met TABpowershell.exe
    - ip adres, dns en gateway worden ingesteld
    - enkele tools worden geïnstalleerd
    - druk op ok button na de gui installatie van Visual C++ 2013
    - herstart automatisch na installatie van tool, open opnieuw powershell na de opstart
4. `Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility,IIS-Metabase -All`
5. installeer via shared folder: `z:\NeoFiles\rewrite_amd64_en-US.msi`z:
6. toevoegen aan domain: `add-computer -domainname TheMatrix.local`
    - login: administrator
    - PW: VeranderMij%123   (dit kan anders zijn)
7. sluit af: `shutdown /P`
8. verwijder server2019 iso en mount de iso van exchange server, start opnieuw op
9. UcmaRuntimeSetup installerenrecd neo 
    - naar schijf van exchange iso gaan =>  `d:`
    - `cd UCMA*` => naar map UCMARedist
    - `.\Setup.exe` => installatie
9. Op dit moment neem je best een snapshot, 
10. login als domein administrator en open powershell.exe, je zal opnieuw azerty moeten instellen
    - ga naar de shared folder `z:`
    - voer nu script `3.scriptInstallExchange.ps1`uit
    - voorbereiding van exchange wordt gedaan en daarna geïnstalleerd, deze stap duurt vrij lang.
    - indien server in sleep mode gaat kan het zijn dat hij vastloopt bij installatie
11. herstart de server: `shutdown /r`
    > Testplan puntje `Test installatie van exchange` is tot hier, de commando's hieronder zijn een ander testplan
12. log opnieuw in met de administrator en voer commando `launchems` uit
13. ga naar de shared folder en voer het script `4.postinstall_naExchange.ps1`uit, je kan eventueel functies in comments zetten om ze niet uit te voeren
14. Op de DomeinController, voer commando uit om Administrator rechten te geven op de Exchange server:
    > `Add-ADGroupMember -Identity "CN=Exchange Servers,OU=Microsoft Exchange Security Groups,DC=TheMatrix,DC=local" -Members Administrator`
15. Op exchange, herstart nu de IIS service: C:\\Windows\System32\iisreset.exe
16. Vanop een PC kan je nu surfen naar `https://mail.thematrix.local`


### TESTEN

open op een domain pc in de browser de pagina https://neo.thematrix.local/owa
log in met de gegevens van de administrator: 
    * user: thematrix.local\administrator
    * PW: VeranderMij%123 

https://neo.thematrix.local/ecp heeft toegang tot het exchange beheer center.
inloggen doe je met de gegevens van de administrator.

Na instellen dns (postinstallscript en herstart IIS service): https://mail.thematrix.local






### AANMAKEN MAILBOX VOOR DOMAIN USERS
> `Get-MailboxDatabase` => toon database
>Get-Mailbox` => toon de huidige accounts> `Get-User -OrganizationalUnit "OU=DomainUsers,DC=TheMatrix,DC=local"` => toon de users in ons domain
> `Get-User -OrganizationalUnit "OU=DomainUsers,DC=TheMatrix,DC=local" | Enable-Mailbox -Database "Mailbox Database 0738242744"` => mailbox aanmaken voor iedere gebruiker

Je kan nu met een andere gebruiker inloggen op https://neo.thematrix.local/owa


### anti-spam
uit te voeren in de EMS shell

> `& $env:ExchangeInstallPath\Scripts\Install-AntiSpamAgents.ps1`
> `Restart-Service MSExchangeTransport`
> `Set-TransportConfig -InternalSMTPServers @{Add="192.168.168.132"}`

Controle: `Get-TransportConfig | Format-List InternalSMTPServers`

> `Set-SenderFilterConfig -BlankSenderBlockingEnabled $true`

### anti-malware

> standaard enabled

### internal/external url's instellen

> geïntegreerd in script `4.postinstall_naExchange.ps1`
> nodige DNS records moeten toegevoegd zijn
> surf naar https://mail.thematrix.local
> Add-Content C:\\Windows\System\drivers\etc\hosts "192.168.168.132`tneo.thematrix.local"
> Add-Content C:\\Windows\System\drivers\etc\hosts "192.168.168.130`tagentsmith.thematrix.local"
> C:\\Windows\System\iisreset.exe

DNS-Records nodig

| Naam of alias| Type     | FQDN van doelhost of IP|
| :---         | :---     | :---                   | 
| mail         | Host (A) | 192.168.168.132        |  => aan te passen van huidige DNS records!
| mail         | MX       | neo.thematrix.local|
| Autodiscover | CNAME    | mail.thematrix.local   |
| owa          | CNAME    | mail.thematrix.local   |

### testfile voor malware 
> https://www.eicar.org/download-anti-malware-testfile/
> file eicar.com
> anti-virus afzetten, anders wordt het meteen in quarantaine geplaatst