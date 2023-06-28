---
title: 'Tools'
---



# NMAP

https://nmap.org/book/

Port scanning

Meest gebruikte Scans:

syn "half-open" Scans: `sS` => controle of poort open/gesloten is
UDP Scan: `sU`
TCP Scan: `sT`
TCP Null scans: `sN`
TCP FIN Scans: `sF`
TCP Xmas Scans: `sX`
alle poorten: `-p-`
speciefieke poort: `p80`

## TCP Scan
Three way handshake:
   - Client -> server: SYN
   - Server -> client: SYN/ACK
   - Client -> server: ACK

indien poort niet open: server stuurt een RST ipv SYN/ACK

## SYN Scan

Three way handshake:
   - Client -> server: SYN
   - Server -> client: SYN/ACK
   - Client -> server: RST

SUDO  privileges nodig!
Verschil tussen een SYN en TCP scan is de respons op een open poort

## UDP Scan

Stateless: UDP connectie hoopt dat een packet de bestemming bereikt.
Indien poort open, dan krijg je meestal geen respons. Het wordt dan gemarkeerd met "open|filtered|
Bij een gesloten poort krijg je een ICMP packet terug met een bericht dat de poort niet breikbaar is.
Trager dan TCP Scans.

## NULL, FIN en Xmas

nog meer stealthy dan SYN SCan

## ping sweep

zoeken welke ip adressen er bestaan in het netwerk: `nmap -sn [ip]`

