# Testplan Opdracht DC: DNS

Auteur(s) testplan: Liam Robyns

Stap 1: Zet dns.csv in Documents folder

Stap 2: Voer dns.ps1 uit

Stap 3: Wacht tot executie voltooid is

Stap4:
Zijn de host records aanwezig ?
(Webserver, Matrix.org, MXServer)

Zijn de PTR records voor de host records aanwezig in de reverse lookup zone ?

Zijn de CName records aanwezig voor www en imap ?

Is de MX record aanwezig voor onze MXServer ?

Stap 5:
Voer Get-DnsServerForwarder uit
Is de forwarder aanwezig ?