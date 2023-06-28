# Testplan Opdracht 3.6: TheOracle (Matrix Server Basisinstallatie)

Auteur(s) testplan: Liam Robyns
## Voorbereiding

* DC met DNS geïnstalleerd (laatste records, opgelet hostnames zijn gewijzigd conform opdracht)
* Twee PC's in het domein en met internettoegang (Voor de browser client) 
* Webserver installtie (voor de Reverse proxy)

## Stappen
    De milestones mag je als aparte tests beschouwen, maar ze moeten sequentieel uitgevoerd worden.
## Milestone 1 Installatie 

1. Open een terminal naar keuze en geef daar 'vagrant version' in, om na te gaan dat vagrant wel degelijk geinstalleerd is.

2. Navigeer nu via de terminal naar de hoofdmap 'SEP-2223-sep-2223-t02/AlmaVM'

3. Voer het commando 'vagrant up theoracle' uit, dit zal enkele minuten installeren (Mits download fouten, verifieer configuratie host computer (netwerk/firewall))

4. Als het script klaar is zal je de LOG "BASIS INSTALL COMLETE" zien, bij een error zal de ssh sessie van vagrant een non-zero exit status geven
    De installtie en config directories zijn te vinden onder de variabelen, vagrant installeert via root

5. Ping nu eens de server vanop een andere host 'ping 192.168.168.133' en test de DNS met nslookup theoracle.thematrix.local, dit moet 192.168.168.131 geven (trinity, mits reverse proxy)

## Milestone 2 Connectiviteit

1. Test nu dat de Synapse draait en of de reverse-proxy werkt door via de webbrowser te navigeren naar theoracle.thematrix.local
    Voor dat de pagina laad moet je het certificaat installeren of gewoon op 'Ga verder || Continue' klikken (het is normaal dat de browser gaat zeggen dat dit domein onveilieg is, self-signed certificaten)
    Dit moet een generieke pagina geven met het matrix logo, login en chat moet via een client gaan

2. Probeer nu eens te navigeren naar http://theoracle.thematrix.local, dit zou automatisch naar de HTTPS versie moeten doorverwijzen
   
## Milestone 3 Chat

1. Kies een browser client (bv. Element https://app.element.io/) 

2. Log in via de gegeven credentials in het provisioning script en klik op 'edit' of 'change' om het juiste domein in te geven, doe dit op beide PC's

3. De gebruikers moeten allebeide nog de publieke kamer #General betreden.

4. Test nu of de chat werkt, stuur eens 'Hello world'.

Gebruikers: keanu & laurence 
Paswoord: ChangeMe

## Milestone 4 Webserver shutdown script

1. Log in via de admin account en ga naar de #Webserver room
        Paswoord: ChangeMe
        admin zou automatisch lid moeten zijn van beide kamers

1. Zet de Webserver uit en test of "Webserver shutting down" in de Webserver room verschijnt
    Enkel admin kan dit zien en hij zal dit bericht ook sturen, de kamer zou private moeten zijn
    keanu en laurence mogen dit niet kunnen joinen


