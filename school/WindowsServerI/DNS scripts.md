# DHCP SCRIPTS

## DNS Client

1. Schrijf een script dat de huidige ingestelde DNS-servers uitschrijft naar het scherm. Toon hierbij enkel de DNS servers voor de LAN interface, en enkel voor IPv4.
```
Get-DnsClientServerAddress -InterfaceAlias LAN -AddressFamily IPv4
```
2. Schrijf een script dat de gebruiker vraagt om een bepaalde naam in te geven (bv. www.google.com). Nadien controleert het script of deze naam voorkomt in de DNS client cache. Indien dit het geval is, schrijft het script het data veld uit van deze entry, indien niet schrijf je een gepaste boodschap uit.

```
[string] $naam = Read-Host "Geef adres"
$entry = Get-DnsClientCache -Entry $naam

if($entry) {
   $data = $entry.data
   Write-Host "$naam gevonden in DNS cache, waarde is $data"
} else {
Write-Host "$naam niet gevonden"
}
```

3. Schrijf een script dat nagaat of de DNS-server voor de LAN-interface reeds ingesteld is op 192.168.0.1. Indien dit het geval is, schrijf je een bevestiging naar het scherm. Indien dit niet het geval is, pas je de DNS-server aan naar 192.168.0.1 en schrijf je hiervan een melding op het scherm.

```
$dns = Get-DnsClientServerAddress -InterfaceAlias LAN -AddressFamily IPv4
$winserver1 = "192.168.0.1"

if($dns.ServerAddresses -eq $winserver1){
   Write-Host "DNS reeds ingesteld op $winserver1"
} else {
Get-DnsClient | Set-DnsClientServerAddress -ServerAddresses ($winserver1)
Write-Host "DNS aangepast naar $winserver1"
}
```

4. Schrijf een script dat eerst toont hoeveel entries er in de DNS client cache zitten. Daarna zal het script de DNS client cache leegmaken, en vervolgens opnieuw uitschrijven hoeveel entries er in de cache zitten.

```
$aantal = (Get-DnsClientCache | measure).Count
Write-Host "Er zitten $aantal entries in de DNS Client cache"
Clear-DnsClientCache
$aantal = (Get-DnsClientCache | measure).Count
Write-Host "Er zitten $aantal entries in de DNS Client cache"
```

5. Schrijf een script dat aan de gebruiker vraagt om een adres op te geven (bv. www.hogent.be). Daarna schrijft het script het overeenkomstige IPv4 adres uit op het scherm, samen met de TTL.
```
[string]$naam = Read-Host "Geef adres"
$answer = Resolve-DnsName -Name $naam -Type A
Write-Host "$naam heeft als IP adres $($answer.IP4Address) en TTL $($answer.TTL)"
```

## DNS Server

1. Schrijf een script dat nagaat of de DNS server gebruikmaakt van 8.8.8.8 als forwarder. Indien dit (nog) niet het geval is, zal het script 8.8.8.8 instellen als forwarder. Tenslotte schrijft het script de forwarder uit naar het scherm.

```
$forwarder = "8.8.8.8"
$current = Get-DnsServerForwarder

if($current.IPAddress -ne $forwarder){
   Set-DnsServerForwarder -IPAddress $forwarder
   Write-Host "Forwarder aangepast naar $forwarder"
} else {
Write-Host "Forwarder reeds in orde"
}

Write-Host (Get-DnsServerForwarder).IPAddress
```

2. Vraag een lijst op van alle DNS zones die de server beheert. Geef voor elke zone het type van de zone (Primary, ...) en vermeld ook of het om een Forward of Reverse Lookup zone gaat.

```
$zones = Get-DnsServerZone^

foreach($zone in $zones){
if($zone.IsReverseLookupZone){
   Write-Host "$($zone.ZoneName) - $($zone.ZoneType) - Reverse Lookup"
} else {
   Write-Host "$($zone.ZoneName) - $($zone.ZoneType) - Forward Lookup"
}
}
```

3. Gebruik PowerShell om een primaire forward lookup zone example.temp aan te maken binnen DNS. Schrijf nadien (via PowerShell) alle records uit van deze nieuwe zone. Welke records zijn er automatisch aangemaakt?

```
$zone = "example.temp"
Add-DnsServerPrimaryZone -Name $zone -ZoneFile $zone
Get-DnsServerResourceRecord -ZoneName $zone
# SOA en NS records worden automatisch aangemaakt
```

4. Voeg aan de zone example.temp enkele A-records toe via PowerShell, met als hostname laptop<XX> en als IP-adres 192.168.10.<XX>. XX krijgt een waarde van 20 tot en met 29, dus in totaal voeg je 10 A-records toe (laptop20 -> 192.168.10.20, laptop21 -> 192.168.10.21, ...).

```
$zone = "example.temp"

for($i = 20; $i -lt 30; $i++){
   $naam = "laptop$i"
   $ip = "192.168.10.$i"
   Add-DnsServerResourceRecordA -Name $naam -ZoneName $zone -IPv4Address $ip
   Write-Host "$naam - $ip toegevoegd"
}
```

5. Maak via PowerShell een reverse lookup zone aan voor het netwerk 192.168.10.0/24. Voeg nadien via PowerShell voor de 10 laptops uit de vorige vraag een PTR record toe aan deze zone. Voor laptop20 maak je dus een PTR record aan 20 -> laptop20.example.temp.

```
$zone = "example.temp"
$netID = "192.168.10.0/24"
$r_zone = "10.168.192.in-addr.arpa"
# Merk op: $netID kan niet gebruikt worden als naam voor het bestand (ongeldige karakters!)

Add-DnsServerPrimaryZone –NetworkID $netID -ZoneFile $r_zone
for($i = 20; $i -lt 30; $i++){
   $naam = "laptop$i.$zone"
   Add-DnsServerResourceRecordPtr -ZoneName $r_zone -Name $i -PtrDomainName $naam
}
```

6. Gebruik PowerShell om het A-record op te halen voor laptop25. Haal nadien het PTR record op voor het IP-adres dat je verkreeg via het A-record.

```
$record = Get-DnsServerResourceRecord -ZoneName $zone –Name $name
Write-Host "$($record.HostName) - $($record.RecordData.IPv4Address)"
# Host halen uit IP-adres
$r_host = ($record.RecordData.IPv4Address).GetAddressBytes()[3]
$r_record = (Get-DnsServerResourceRecord -ZoneName $r_zone -Name $r_host)
Write-Host "$($r_record.HostName) - $($r_record.RecordData.PtrDomainName)"
```

7. Verwijder via PowerShell de zone example.temp en de reverse lookup zone voor netwerk 192.168.10.0/24. Maak hierbij gebruik van de parameter -Force zodat de gebruiker geen bevestiging moet geven bij uitvoeren van het script.

```
$zone = "example.temp"
$r_zone = "10.168.192.in-addr.arpa"
Remove-DnsServerZone $zone -Force
Remove-DnsServerZone $r_zone -Force
```