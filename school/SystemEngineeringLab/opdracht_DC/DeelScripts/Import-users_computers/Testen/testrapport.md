# Testrapport Opdracht DC: Het importeren van users en computers

## Test Importeren Users & Computers

Uitvoerder(s) test: Liam Robyns
Uitgevoerd op: 28-03-2023
Github commit:  e2c43caa39ad1b74d213770cffa93d0f43fdfb88


## Startsituatie

Een standaard Windows server werd geïnstalleerd.
Een gedeelde map werd aangemaakt, met hierin de nodige scripts en csv-bestand
Het script om van de server een domain controller te maken, werd uitgevoerd.
Het script om de OU's aan te maken, werd uitgevoerd.
Neem een snapshot om verschillende scenario's te testen.

## Uit te voeren acties

1. Maak een snapshot, voorafgaand aan het uitvoeren van de testen.

OK.

2. Controleer in ADUC in welke OU de domain controller (AGENTSMITH) zich bevindt.

Domain Controllers

3. Zet het CSV-bestand op de default locatie (op de desktop van de administrator) en voer het script import_users_computers.ps1 uit.

NOK.
Toevoeging Delimiter wegens gebruik van non-standaard ";" delimiter -> OK.

4. De domain controller zou na het uitvoeren van het script verplaatst moeten zijn van OU. Er wordt een waarschuwing gegeven in de console.

OK, waarschuwing verschijnt.

5. Controleer in ADUC of na het uitvoeren van het script, de users en computers in de juiste OU's werden gestoken, inclusief de DC. Gebruik het CSV-bestand en/of de brochure voor een overzicht. Joel Silver werd extra 
toegevoegd in de OU Producer, dit stond niet in de brochure.

OK, enkel nog niet geimplementeerde servers ontbreken

6. Zet het CSV-bestand op een andere locatie en voer het script opnieuw uit. Geef de nieuwe locatie manueel in, wanneer hierom gevraagd wordt. Deze locatie moet evenzeer werken.

OK met volledig pad.

7. De users en computers die de vorige keer werden aangemaakt, worden nu niet opnieuw aangemaakt omdat ze al aanwezig zijn. Dit wordt via de console gemeld.

OK, geen duplicaten en foutmeldingen verschijnen.

8. Controleer in ADUC of de users en computers nog steeds in de juiste OU's zitten.

OK.

9. Log uit in de DC en probeer hierop in te loggen met het account van Lilly Wachowski (gebruiker: lilly.wachowski, wachtwoord: VeranderMij%123). Dit zou moeten lukken.

NOK, GPOs niet in startsituatie.
OK, mits toevoeging GPOs.

10. Log op PCCast1 in met het account van Keanu Reeves (gebruiker: keanu.reeves, wachtwoord: VeranderMij%123). Dit moet evenzeer lukken.

OK.