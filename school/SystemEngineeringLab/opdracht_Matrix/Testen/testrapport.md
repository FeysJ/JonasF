# Testrapport Opdracht Matrix server

## Test

Uitvoerder(s) test: Jonas Feys
Uitgevoerd op: 22/05/2023
Github commit:  COMMIT HASH

## Milestone 1 Installatie 

1. Open een terminal naar keuze en geef daar 'vagrant version' in, om na te gaan dat vagrant wel degelijk geinstalleerd is.

2. Navigeer nu via de terminal naar de hoofdmap 'SEP-2223-sep-2223-t02/AlmaVM'

4. Zorg ervoor dat de Webserver en de DC draait en verifieer nog eens dat je de juiste records hebt (bv: CNAME 'theoracle' die naar trinity.thematrix.local wijst)
    trinity kan je standalone installeren, theoracle heeft beide nodig.

5. Voer het commando 'vagrant up theoracle' uit, dit zal enkele minuten installeren (Mits download fouten, verifieer configuratie host computer (netwerk/firewall))
    Mits DNS problemen zal het script errors geven en de vagrant shell zal stoppen met lopen (non-zero exit status), alle andere warnings mag je negeren.

6. Als het script klaar is zal je de LOG "BASIS INSTALL COMLETE" zien, bij een error zal de ssh sessie van vagrant een non-zero exit status geven
    De installtie en config directories zijn te vinden onder de variabelen, vagrant installeert via root

7. Ping nu eens de server vanop een andere host 'ping 192.168.168.133' en test de DNS met nslookup theoracle.thematrix.local, dit moet 192.168.168.131 geven (trinity, mits reverse proxy)
    > Ping ok, connectie is tot stand

![TestPing](<../images/test_ping.png?raw=true>) 

## Milestone 2 Connectiviteit

1. Test nu dat de Synapse draait en of de reverse-proxy werkt door via de webbrowser te navigeren naar theoracle.thematrix.local
    Voor dat de pagina laad moet je het certificaat installeren of gewoon op 'Ga verder || Continue' klikken (het is normaal dat de browser gaat zeggen dat dit domein onveilieg is, self-signed certificaten)
    Dit moet een generieke pagina geven met het matrix logo, login en chat moet via een client gaan
    > ok, certificaat verschijnt om te accepteren

![TestCertificaat](<../images/test_https_certificaat.png?raw=true>)

2. Probeer nu eens te navigeren naar http://theoracle.thematrix.local, dit zou automatisch naar de HTTPS versie moeten doorverwijzen
   > ok, wordt doorverwezen van http naar https

![TestSynapse](<../images/test_synapse_website.png?raw=true>)

## Milestone 3 Chat

1. Kies een browser client (bv. Element https://app.element.io/) 

2. Log in via de gegeven credentials in het provisioning script en klik op 'edit' of 'change' om het juiste domein in te geven, doe dit op beide PC's
    > 
3. De gebruikers moeten allebeide nog de publieke kamer #General betreden.
    > De General chat verschijnt niet en kan hem ook niet vinden bij "keanu". Bij het aanmaken van een nieuwe chat kan ik deze wel vinden.

4. Test nu of de chat werkt, stuur eens 'Hello world'.
    > Chat werkt

![TestChat](<../images/test_chatten.png?raw=true>)

Gebruikers: keanu & laurence 
Paswoord: ChangeMe

## Milestone 4 Webserver shutdown script

1. Log in via de admin account en ga naar de #Webserver room
        Paswoord: ChangeMe
        admin zou automatisch lid moeten zijn van beide kamers

1. Zet de Webserver uit en test of "Webserver shutting down" in de Webserver room verschijnt
    Enkel admin kan dit zien en hij zal dit bericht ook sturen, de kamer zou private moeten zijn
    keanu en laurence mogen dit niet kunnen joinen
    > ik krijg geen melding van een shutdown. De webserver zet ik uit via commando `shutdown 1`