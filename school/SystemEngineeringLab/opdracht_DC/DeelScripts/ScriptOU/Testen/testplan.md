# Testplan Opdracht DC: Het aanmaken van de OU's via Powershell

Auteur(s) testplan: Lara Van Wynsberghe

## Startsituatie

Een standaard Windows server werd geïnstalleerd.
Een gedeelde map werd aangemaakt, met hierin de nodige scripts en csv-bestand
Het script om van de server een domain controller te maken, werd uitgevoerd.
Neem een snapshot om verschillende scenario's te testen

## Uit te voeren acties

1. Zet het CSV-bestand op de default locatie (op de desktop van de administrator) en voer het script scriptOUs20230305.ps1 uit.
2. Controleer in ADUC of na het uitvoeren van het script, de nodige OU's werden aangemaakt.
3. Zet het CSV-bestand op een andere locatie en voer het script opnieuw uit. Deze locatie moet evenzeer werken.
4. De OU's die de vorige keer werden aangemaakt, worden nu niet opnieuw aangemaakt. Dit wordt via de console gemeld.
