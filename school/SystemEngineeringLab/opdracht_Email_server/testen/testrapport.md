# Testrapport Opdracht Email-server

## Test Email Server

Uitvoerder(s) test: Liam Robyns
Uitgevoerd op: 6/05/2023
Github commit:  COMMIT HASH

## Test installatie van exchange

### Voorbereiding

- Volg het stappenplan in `StappenplanNeoCLI.md` tot en met stap 11 (zie ook hier eest bij voorbereiding)
- Start de email-server en DC op, beide met intern netwerk `servers`
- Zorg voor een host of crew pc die ook in het intern netwerk zit van de servers voor testen uit te voeren
- zorg dat je als domein administrator ingelogd bent op de mailserver

### testen

1. op de mailserver, voer het commando `launchems`uit in powershell, je komt nu in een nieuw powershell scherm terecht, de Exchange Management Shell.
   Installatie is geslaagd van exchange.
   Zorg dat je ingelogd bent als domeinadministrator.

2. Voer het commando `launchems`uit vanuit powershell-omgeving. Je komt nu terecht in de exchange management shell => indien geen errors geslaagd!

launchems -> OK.

3. Voer commando `Get-ExchangeServer` of `(Get-ExchangeServer).Site`uit. Neo moet in de juiste site zitten, namelijk TheMatrix.local

Site is correct -> OK.

4. Voer commando `Get-MailboxDatabase`uit. Nu moet je de database met bijhorend nummer te zien krijgen (dit zal steeds anders zijn!)

OK.

5. Surf vanop een PC in het domein naar `https://neo.thematrix.local/owa`. accpteer het risico en login met de administrator (mailbox)

Login owa -> OK.

6. Surf vanop een PC in het domein naar `https://neo.thematrix.local/ecp`. accpteer het risico en login met de administrator (beheercentrum)

Login ecp -> OK.

Indien al deze stappen goed doorlopen zijn, werd exchange goed geïnstalleerd om de volgende stappen uit te kunnen voeren.

## Test synchronizatie users

### Voorbereiding

- Installatie van exchange moet gedaan zijn en script `4.postinstall_naExchange.ps1` function `ImportAccounts` > Je kan de andere functies in commentaar zetten voor te testen
- Start de email-server en DC op, beide met intern netwerk `servers`
- Zorg voor een host of crew pc die ook in het intern netwerk zit van de servers voor testen uit te voeren
- zorg dat je als domein administrator ingelogd bent op de mailserver in de EMS

### testen

1. Voer commando `Get-Mailbox -OrganizationalUnit "OU=DomainUsers,DC=TheMatrix,DC=local"` uit, je moet nu de accounts van het domein te zien krijgen die een mailbox hebben.

Accounts verschijnen -> OK

2. Log op de PC in met het account van joel silver, na ingeven tijdszone moet je de mailbox te zien krijgen

Login lukt -> OK.

3. verstuur een mail naar `administrator@thematrix.local`en test of deze toekomt door in te loggen bij de administrator

Mail verschijnt -> OK.

## Test Anti-Spam

### Voorbereiding

- Installatie van exchange moet gedaan zijn en script `4.postinstall_naExchange.ps1` function `spam`
- Start de email-server en DC op, beide met intern netwerk `servers`
- Zorg voor een host of crew pc die ook in het intern netwerk zit van de servers voor testen uit te voeren
- zorg dat je als domein administrator ingelogd bent op de mailserver in de EMS

### testen 
(volgens dat ik online terugvind zou exchange enkel filteren bij binnenkomend verkeer, filter op content werkt niet als ik intern test)

1. op exchange server, voer commando `Get-TransportConfig | Format-List InternalSMTPServers` uit, je krijgt IP van mailserver te zien.
OK.
2. voer commando `Get-TransportAgent` uit, onderaan zie je content filter agent, sender id agent, sender filter agent en  recipient filter agentstaan. In de kolom "Enabled" moet True staan.
OK.
3. voer commando `Get-SenderFilterConfig | Format-List *Enabled,*Block*`uit. 
      > naast BlankSenderBlockingEnabled moet true staan
      > naast BlockedSender moet test@hogent en hallo@hogent staan
      > naast BlockedDomains moet hln.be staan
Komt overeen, OK.      
4. voer commando `Get-ContentFilterPhrase | Format-Table -Auto Influence,Phrase` uit, naast BadWord moet je "dit is een test" zien staan

OK.

## Test Anti-Malware

### Voorbereiding

- Installatie van exchange moet gedaan zijn en script `4.postinstall_naExchange.ps1` function `Malware`
- Start de email-server en DC op, beide met intern netwerk `servers`
- Zorg voor een host of crew pc die ook in het intern netwerk zit van de servers voor testen uit te voeren
- zorg dat je als domein administrator ingelogd bent op de mailserver in de EMS

### testen 

1. voer commando `Get-TransportAgent` uit, naast Malware Agent zie je in de kolom "Enabled" True staan.
OK.
2. voer commando `Get-MalwareFilterPolicy` uit, bij action zie je `DeleteAttachementAndUseCustomAlertText` staan 
OK.
3. Surf naar `https://neo.thematrix.local/ecp` en log in met administrator. Ga naar tabblad beveiliging en open de instelling van de Default policy via bewerken.
      >  controlleer dat bolltje staat bij: Alle bijlagen verwijderen en standaard waarschuwingstekst gebruiken
      > Interne afzender inlichten moet aangevinkt staan
OK.
4. Verstuur een email met de malware test file (zie StappenplanNeoCLI.md puntje testfile voor malware)
      > Je dient een mail terug te krijgen met de boodschap dat er malware gedetecteerd is
OK.

## Test https://mail.thematrix.local

### Voorbereiding

- Installatie van exchange moet gedaan zijn en script `4.postinstall_naExchange.ps1` function `url()` en `dnsRecords()`
- Start de email-server en DC op, beide met intern netwerk `servers`
- Zorg voor een host of crew pc die ook in het intern netwerk zit van de servers voor testen uit te voeren
- zorg dat je als domein administrator ingelogd bent op de mailserver in de EMS
- DNS records zijn ingesteld op de DC

### testen 

1. voer commando `Get-TransportAgent` uit, naast Malware Agent zie je in de kolom "Enabled" True staan.
OK.
2. voer commando `C:\>Get-OwaVirtualDirectory -Server neo | Format-List InternalUrl, ExternalUrl` uit, bij de url's zie je `https://mail.thematrix.local/owa`staan
OK.
2. voer commando `C:\>Get-EcpVirtualDirectory -Server neo | Format-List InternalUrl, ExternalUrl` uit, bij de url's zie je `https://mail.thematrix.local/ecp`staan
OK.
4. surf naar `https://mail.thematrix.local`, je zal doorgestuurd worden naar /owa en toegang krijgen tot de mailserver
OK.