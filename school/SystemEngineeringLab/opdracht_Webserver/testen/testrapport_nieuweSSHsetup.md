# Testrapport Opdracht 3.4: Webserver Trinity - SSH

Uitvoerder(s) test: Jonas Feys
Uitgevoerd op: 19/05/2023
Github commit:  COMMIT HASH


## Testen van ssh, ssh authenticatie zonder wachtwoord en niet inloggen met root

1. Test of je geen wachtwoord meer moet ingeven bij maken van connectie via ssh voor de gebruiker vagrant, vanop de test client (opgelet, de public en private keys moeten naar de map .ssh van de gebruiker gekopieerd zijn). 

> RESULTAAT: OK, geen wachtwoord moeten ingeven

1. Maak op de Dozer machine een extra gebruiker aan met wachtwoord (`sudo useradd tester`, gevolgd door `sudo passwd tester`). Je mag vanop de test client nu niet kunnen inloggen via ssh met deze gebruiker.

> RESULTAAT: OK, krijg melding "permission denied" bij ssh via user tester

3. Ingelogd als Vagrant gebruiker op Dozer, stel een wachtwoord in voor root met het commando `sudo passwd root`. Probeer in te loggen als root, ook nu mag je geen connectie kunnen maken.

> RESULTAAT: OK, krijg melding "This account is currently not available"
