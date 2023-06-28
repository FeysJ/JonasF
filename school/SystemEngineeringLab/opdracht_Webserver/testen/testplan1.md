# Testplan Opdracht 3.4: Webserver Trinity

Auteur(s) testplan: Jonas Feys

## Voorbereiding

* DC met DNS geïnstalleerd
* Toegang tot nmap voor het testen van onzichtbaar maken versie webserver
* Firefox installeren voor test http/2
* Testen met DC of andere indien routering volledig werkt

## Stappenplan testen

### Installatie van script

1. ga via de windows commandprompt of Visual studio code console naar de map `eigen_path/SEP-2223-sep-2223-t02/AlmaVM`
2. voer het commando `vagrant up trinity`uit, jet script zal nu starten
     * Het kan zijn dat de firewall het downloaden blokkeert de eerste keer, ik schakel hem dan even uit
3. Het runnen van het script zal een 15-tal minuten in beslag nemen
4. Als het script klaar is zal je de LOG "INSTALL COMPLETED" zien staan
    * indien er een fout is zal je een error krijgen en stopt het script 
5. Na het uitvoeren van het script dien je de interne netwerkadapter te wijzigen naar deze van de servers
6. test of je de server kan bereiken door `ping 192.168.168.131`vanop een ander toestel in het netwerk

### Testen van de webserver

Momenteel enkel met het www voorvoegsel

1. Surf vanop een PC in het domein naar `http://www.thematrix.local`. Nu zou je de startpagina van Wordpress moeten zien.
2. Surf vanop een PC in het domein naar `https://www.thematrix.local`. Nu zou je een beveiligingsscherm moeten zien en aanvaarden dat je het risico aanvaard om door te gaan. Dit komt doordat de certificaten niet officieel gekend zijn. Nu zou je terug op de startpagina van Wordpress moeten uitkomen maar dan met https.
![self-signed waarschuwing](./images/Testen_Jonas/self_signed_waarschuwing.png)
3. Open nu via `F12` de developer tools in firefox en ga naar de tab `Netwerk`
4. Herlaad eventueel de pagina en klik op het eerste GET statement
5. Nu zie je nu `Versie: HTTP/2` en `X-Firefox-Spdy h2staan`, http/2 is actief
![HTTP2](./images/Testen_Jonas/test_http2.png)
6. Voer het commando `nmap -sV -p 80 192.168.168.131` uit, versienummer van nginx mag niet zichtbaar zijn.
7. Vul nu gegevens in op de wordpress pagina, onthoud deze om in te loggen. (maakt niet uit wat). Log in op de website. 
8. Op de webserver, log nu in op de MariaDB database
    - `mysql --user=www_user --password=PleaseChangeMe`
    - ga naar de database: `use selgroept02;`
    - test of je de aangemaakte gebruiker kan zien: `select * from wp_users;`
9. Surf naar `http://rallly.thematrix.local`, rallly moet nu zichtbaar zijn  (3 x l!) (DNS moet in orde zijn hiervoor)


### Testen van ssh, ssh authenticatie zonder wachtwoord en niet inloggen met root

1. Doe eerst voorgaande testen
2. volg het stappenplan in `ssh_disableRoot_disablePwLogin.md` vanop een windows host, bvb de DC.
3. Test nu of je geen wachtwoord meer moet ingeven bij maken van connectie via ssh
4. maak een extra gebruiker aan met wachtwoord zonder ssh keys in te stellen. Je mag nu niet kunnen inloggen via ssh.
5. ingelogd als Vagrant gebruiker, stel een wachtwoor din voor root met commando `sudo passwd root`
6. Probeer in te loggen als root, ook nu mag je geen connectie kunnen maken.