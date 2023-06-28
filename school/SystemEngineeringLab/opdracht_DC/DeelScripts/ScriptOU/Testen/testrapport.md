# Testrapport Opdracht DC: Het aanmaken van de OU's via Powershell

Uitvoerder(s) test: Lara Van Wynsberghe
Uitgevoerd op: (eerdere datum in een ander bestand; herwerkt op 2023 03 13)

## Uitgangspunt

Een standaard Windows server werd geïnstalleerd.
Een gedeelde map werd aangemaakt.
Het script om van de server een domain controller te maken, werd uitgevoerd.

## Teststappen

1. Zet het CSV-bestand op de default locatie (op de desktop van de administrator) en voer het script scriptOUs20230305.ps1 uit.
    * In orde.
2. Controleer in ADUC of na het uitvoeren van het script, de nodige OU's werden aangemaakt.
    * De OU's werden aangemaakt.
3. Zet het CSV-bestand op een andere locatie en voer het script opnieuw uit. Deze locatie moet evenzeer werken.
    * Het originele script werd uitgebreid met de optie om een manuele locatie in te geven en deze te controleren. Zie commit 48f2501c852a76002e9aecdf50d2a2bab4553333.
4. De OU's die de vorige keer werden aangemaakt, worden nu niet opnieuw aangemaakt. Dit wordt via de console gemeld.
    * De OU's worden niet opnieuw aangemaakt. We zien wel een melding.
