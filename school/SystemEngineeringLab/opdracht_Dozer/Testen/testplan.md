# Testplan Opdracht Dozer: Redmine

Auteur(s) testplan: Lara Van Wynsberghe

## Startsituatie

* Vagrant is geïnstalleerd en up to date
* De DNS-server (op de DC) is bereikbaar en up to date
* Een test-client werd reeds geïnstalleerd
* De test client kan connecteren naar de Dozer (bijv. o.w.v. zelfde intnet-adapter)
* De private key "id_rsa" werd gekopieerd naar de map .ssh van de gebruiker op de test client

## Acties + verwachte resultaten

### Test de installatie van de VM via Vagrant

1. Ga via de windows commandprompt of Visual studio code console naar de map `eigen_path/SEP-2223-sep-2223-t02/AlmaVM`.
2. Voer het commando `vagrant up dozer` uit, waarna het script start.

Het script zal een tijdje lopen. Controleer of er geen foutmeldingen verschijnen. Indien er een fout optreedt, zal het script afbreken.

> RESULTAAT:

### Test de gebruiker Redmine

1. SSH naar Dozer vanop de test client, d.m.v. het commando `ssh vagrant@192.168.168.134`. <br/> 
(zorg ervoor dat de beide keys in de map .ssh van de gebruiker aanwezig zijn, zie Opdracht_PCs\werkwijze.md)
2. Controleer in /etc/passwd of de gebruiker Redmine werd aangemaakt.

> RESULTAAT:

3. Controleer of de gebruiker Redmine "/var/www/Redmine-5.0" als home directory heeft (`getent passwd redmine`).

> RESULTAAT:

4. Controleer of de gebruiker Redmine in de groep Apache zit (`groups apache`).

> RESULTAAT:

5. Controleer of de gebruiker Redmine niet kan inloggen, ook niet indien deze een wachtwoord zou hebben:
   1. Controleer of inloggen niet mogelijk is: `sudo su - redmine`
   2. Stel een wachtwoord in voor de gebruiker Redmine: `sudo passwd redmine`
   3. Controleer of het nog steeds niet mogelijk is om in te loggen: `sudo su - redmine`
   4. Controleer of het nog steeds niet mogelijk is om in te loggen: `su - redmine`. Het wachtwoord wordt gevraagd, maar inloggen wordt niet toegestaan.
   5. Controleer of de login shell ingesteld is op "/usr/sbin/nologin" via `getent passwd redmine`

> RESULTAAT:

### Test de netwerkconnectie

Na het uitvoeren van het script dien je de interne netwerkadapter te wijzigen naar deze van de test servers. Test hierna of je de server kan bereiken via `ping 192.168.168.134` vanop een ander toestel in het netwerk.

> RESULTAAT:

### Test de website

Surf vanop de test client naar <http://192.168.168.134>. De Redmine website verschijnt.

> RESULTAAT:

De gebruikersnaam en het wachtwoord van Redmine bij de initiële opstart zijn:

    * gebruiker: admin
    * wachtwoord: admin

Hierna vraagt Redmine om het wachtwoord van de administrator te wijzigen. (Dit maakt geen deel uit van de test.)

### Test DNS-record

Surf vanop de test client naar <http://dozer.thematrix.local>. De website moet gevonden worden en de Redmine webpagina openen.

> RESULTAAT:

### Test SSL

Surf vanop de test client naar <https://dozer.thematrix.local>. Accepteer indien nodig het self signed certificaat. De website moet bereikbaar en versleuteld zijn.

> RESULTAAT:

### Test de databank

1. SSH naar de Dozer server (via de test client) en log in op de MySQL database (`mysql --user=root --password=ChangeMe`)

> RESULTAAT:

2. Controleer of er geen test-databank aanwezig is (`show databases;`). De verwachte databanken zijn: "information_schema", "mysql", "performance_schema", "redmine" en "sys"

> RESULTAAT:

3. Controleer of de gebruiker 'Redmine' werd aangemaakt:
   1. `use mysql`
   2. `select user from user;`
   3. De volgende gebruikers moeten aanwezig zijn: "mysql.infoschema", "mysql.session", "mysql.sys", "redmine" en "root"

> RESULTAAT:

4. Surf vanop de client naar de Redmine website (of log uit vanop de website) en klik rechtsbovenaan op 'Registreren' . Maak een willekeurige nieuwe gebruiker aan. Ga vervolgens op de server naar de redmine database (`use redmine;`) en test of je de aangemaakte gebruiker kan zien: `select login,firstname,lastname,admin,status from users;`

> RESULTAAT:

### Testen van ssh, ssh authenticatie zonder wachtwoord en niet inloggen met root

1. Test of je geen wachtwoord meer moet ingeven bij maken van connectie via ssh voor de gebruiker vagrant, vanop de test client (opgelet, de public en private keys moeten naar de map .ssh van de gebruiker gekopieerd zijn). Gebruik het volgende commando om een specifieke key mee te geven: `ssh vagrant@192.168.168.134 -i C:\Users\Administrator\.ssh\id_rsa`

> RESULTAAT:

2. Maak op de Dozer machine een extra gebruiker aan met wachtwoord (`sudo useradd tester`, gevolgd door `sudo passwd tester`). Je mag vanop de test client nu niet kunnen inloggen via ssh met deze gebruiker.

> RESULTAAT:

3. Ingelogd als Vagrant gebruiker op Dozer, stel een wachtwoord in voor root met het commando `sudo passwd root`. Probeer in te loggen als root, ook nu mag je geen connectie kunnen maken.

> RESULTAAT:

### Test idempotentie van het script

Voer het Vagrant script nogmaals uit met `vagrant provision dozer`. Er zouden bij de tweede uitvoer geen foutmeldingen mogen verschijnen. (Opgelet: dit zal niet meer werken als de NAT-adapter ontkoppeld is - zoals in de recentste versie van het script)

> RESULTAAT:
