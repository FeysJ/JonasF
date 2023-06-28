# Testrapport Opdracht Webserver Trinity

Uitvoerder(s) test: Lara Van Wynsberghe
Uitgevoerd op: 11/04/2023 en 17/04/2023
Github commit:  COMMIT HASH

## Installatie van het script

De installatie d.m.v. het script is geslaagd. De firewall blokkeerde het downloaden niet.
`ping 192.168.168.131` vanop de DC naar de webserver is gelukt.

`ping 192.168.168.131` vanop PCCrew1 werkt niet. Dit wijst op een probleem met de routering. pingen naar 192.168.168.129 en 192.168.168.130 gaat wel.

De volgende aanpassing werden gedaan:
subnet toegevoegd aan vagrant-hosts.yml en weggehaald in trinity.sh.
De route naar de default gateway werd toegevoegd.

Andere error bij installatie:

```vagrant
trinity: [LOG]  Database aanmaken postgresql
    trinity: could not change directory to "/home/vagrant/rallly": Permission denied
    trinity: ALTER ROLE
    trinity: could not change directory to "/home/vagrant/rallly": Permission denied
    trinity: CREATE DATABASE
    trinity: [LOG]  aanpassen .env file
    trinity: [LOG]  schema.prisma inladen
```

**Verdere testen hieronder werden gedaan door de PC in het server-netwerk te steken.**

## Testen van de webserver

1. Surf vanop een PC in het domein naar `http://www.thematrix.local`. Nu zou je de startpagina van Wordpress moeten zien.
    > in orde
2. Surf vanop een PC in het domein naar `https://www.thematrix.local`. Nu zou je een beveiligingsscherm moeten zien en aanvaarden dat je het risico aanvaard om door te gaan. Dit komt doordat de certificaten niet officieel gekend zijn. Nu zou je terug op de startpagina van Wordpress moeten uitkomen maar dan met https.
![self-signed waarschuwing](./images/Testen_Jonas/self_signed_waarschuwing.png)
    > in orde
3. Open nu via `F12` de developer tools in firefox en ga naar de tab `Netwerk`
4. Herlaad eventueel de pagina en klik op het eerste GET statement
5. Nu zie je nu `Versie: HTTP/2` en `X-Firefox-Spdy h2staan`, http/2 is actief
![HTTP2](./images/Testen_Jonas/test_http2.png)
    > in orde
6. Voer het commando `nmap -sV -p 80 192.168.168.131` uit, versienummer van nginx mag niet zichtbaar zijn.
    > nginx wordt gedetecteerd, maar niet het versienummer
7. Vul nu gegevens in op de wordpress pagina, onthoud deze om in te loggen. (maakt niet uit wat). Log in op de website.
    > in orde
8. Op de webserver, log nu in op de MariaDB database
    - `mysql --user=www_user --password=PleaseChangeMe`
    - ga naar de database: `use selgroept02;`
    - test of je de aangemaakte gebruiker kan zien: `select * from wp_users;`
    > `vagrant ssh trinity` uitgevoerd om op de webserver te kijken en vervolgens bovenstaande commando's uitgevoerd. De gebruiker werd aangemaakt:

MariaDB [selgroept02]> select * from wp_users;
+----+------------+------------------------------------+---------------+----------------------+-----------------------------+---------------------+---------------------+-------------+--------------+
| ID | user_login | user_pass                          | user_nicename | user_email           | user_url                    | user_registered     | user_activation_key | user_status | display_name |
+----+------------+------------------------------------+---------------+----------------------+-----------------------------+---------------------+---------------------+-------------+--------------+
|  1 | test       | $P$ByiVOVP15YRDBLGKKoJlS4yF4Nh4fQ/ | test          | test@thematrix.local | https://www.thematrix.local | 2023-04-18 14:22:26 |                     |           0 | test         |
+----+------------+------------------------------------+---------------+----------------------+-----------------------------+---------------------+---------------------+-------------+--------------+
1 row in set (0.000 sec)

9.  Surf naar `http://rallly.thematrix.local`, rallly moet nu zichtbaar zijn  (3 x l!) (DNS moet in orde zijn hiervoor)
    > in orde

### Testen van ssh, ssh authenticatie zonder wachtwoord en niet inloggen met root

1. Doe eerst voorgaande testen
2. volg het stappenplan in `ssh_disableRoot_disablePwLogin.md` vanop een windows host, bvb de DC.
    > kleine correctie aangebracht in het ip-adres
3. Test nu of je geen wachtwoord meer moet ingeven bij maken van connectie via ssh
    > in orde
4. maak een extra gebruiker aan met wachtwoord zonder ssh keys in te stellen. Je mag nu niet kunnen inloggen via ssh.
    > op de webserver `sudo useradd tester` en `sudo passwd tester` uitgevoerd, om een testgebruiker aan te maken.
    `ssh tester@192.168.168.131` op de DC, geeft een "Permission denied" terug.
5. ingelogd als Vagrant gebruiker, stel een wachtwoord in voor root met commando `sudo passwd root`
    > in orde
6. Probeer in te loggen als root, ook nu mag je geen connectie kunnen maken.
    > ook hier geeft een poging tot inloggen "Permission denied" terug.
