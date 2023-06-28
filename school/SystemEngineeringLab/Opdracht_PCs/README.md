# System Engineering Project - Opdracht PCs (cast-PC, crew-PC en director-PC )

## **Overzicht functionaliteiten**

Tot het domein kunnen PCs toegevoegd worden. Bij de configuratie van de Domain controller, worden alvast 5 PCs meegenomen (PCCast1, PCCast2, PCCrew1, PCCrew2, DirectorPC).<br/> 
Deze DC wordt via een aantal powershell-scripts met bijhorende configuratiebestanden geïnstalleerd en geconfigureerd.<br/>
De scripts maken een basis VM met het besturingssysteem Windows10 (GUI) in VirtualBox.<br/>
O.a. volgende zaken worden geïnstalleerd/geconfigureerd:

* Via keuzemogelijkheid, de PC als Crew-PC of als cast-PC aanmaken.
* Installatie van de Guest additions
* Toevoegen aan het domain met een postinstall script
* Toevoeging RSAT voor DirectorPC, omdat Servers via RSAT vanop de DirectorPC (Windows 10) dienen te kunnen worden geconfigureerd.

## **Links**

1. [Werkwijze installatie](werkwijze.md)
2. [Scripts](Scripts)
3. [RSAT directorPC](RSAT)
4. [Lastenboek](lastenboek.md)
5. [Testen](Testen)
6. [Afbeeldingen](pictures)
