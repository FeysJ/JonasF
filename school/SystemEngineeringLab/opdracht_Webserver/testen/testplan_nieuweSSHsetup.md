# Testplan Opdracht 3.4: Webserver Trinity - SSH

Auteur(s) testplan: Lara Van Wynsberghe

## Startsituatie

* Vagrant is geïnstalleerd en up to date
* Een test-client werd reeds geïnstalleerd
* De test client kan connecteren naar de webserver (bijv. o.w.v. zelfde intnet-adapter)
* De private key "id_rsa" werd gekopieerd naar de map .ssh van de gebruiker op de test client

## Testen van ssh, ssh authenticatie zonder wachtwoord en niet inloggen met root

1. Test of je geen wachtwoord meer moet ingeven bij maken van connectie via ssh voor de gebruiker vagrant, vanop de test client (opgelet, de public en private keys moeten naar de map .ssh van de gebruiker gekopieerd zijn). 

> RESULTAAT:

1. Maak op de Dozer machine een extra gebruiker aan met wachtwoord (`sudo useradd tester`, gevolgd door `sudo passwd tester`). Je mag vanop de test client nu niet kunnen inloggen via ssh met deze gebruiker.

> RESULTAAT:

3. Ingelogd als Vagrant gebruiker op Dozer, stel een wachtwoord in voor root met het commando `sudo passwd root`. Probeer in te loggen als root, ook nu mag je geen connectie kunnen maken.

> RESULTAAT:
