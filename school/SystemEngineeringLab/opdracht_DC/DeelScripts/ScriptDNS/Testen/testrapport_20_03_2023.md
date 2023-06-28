# Testrapport Opdracht x: (titel)

## Test y

Uitvoerder(s) test: Jonas Feys 
Uitgevoerd op: 11/03/2023
Github commit:  COMMIT HASH

## testen


Zijn de host records aanwezig ? 
(Webserver, Matrix.org, MXServer)
> Ja

Zijn de PTR records voor de host records aanwezig in de reverse lookup zone ?
> Ja

Zijn de CName records aanwezig voor www en imap ?
>Ja, surfen naar www.thematrix.local werkt ook

Is de MX record aanwezig voor onze MXServer ?
> Ja

Stap 5:
Voer Get-DnsServerForwarder uit
Is de forwarder aanwezig ?
> Deze staat ingesteld als conditional forward server, dit is volgens mij verkeerd.
> moet dit geen standaard forwarder zijn via commando `Add-DnsServerForwarder`?



Nog toe te voegen: 

CNAME nog toe te voegen voor rallly.thematrix.local
     - naam = rallly (3 x een l)
     - redirect naar de webserver
