# Lastenboek Opdracht 3.3 : Domain Controller

## Deliverables

* hostnaam: AgentSmith
* Domain-structuur (p24 brochure) implementeren via powershellscript 
* acteurs, crewleden en minstens 2 pc's per OU importeren via powershellscript en bijhorende CSV-file
* De servers via RSAT configureerbaar maken vanop DirectorPC 
* Pc's en servers hebben geen eigen gebruikers, authenticatie via DC
* castleden kunnen enkel inloggen op cast PC en crewleden enkel op crew pc. Director kan op iedere PCinloggen.
* automatisch een eigen shared folder voorzien voor elke users 
* Automatisch groepen aanmaken voor crew- en castleden.  
* Shared folder voor cast- en crewgroep.
* Beleidsregels uitwerken volgens p24 brochure
* DNS rol implementeren
* DHCP implementeren

## Deeltaken

(Som hier de deeltaken voor deze opdracht op en duid voor elk een verantwoordelijke en tester aan. Vermeld ook afhankelijkheden tussen deeltaken als die er zijn. Elke deeltaak wordt een kaartje op het kanban-bord!)

1. Basis vm voorzien: WS2019 core met juiste hostname + snapshot nemen
    - Verantwoordelijke: Iedereen
    - Tester: Iedereen
1. powershell script maken voor aanmaak DC
    - Verantwoordelijke: Joost
    - Tester:   Liam
2. DirectorPC opzetten (manueel)
    - Verantwoordelijke:Iedereen
    - Tester: Iedereen
3. Domainstructuur via powershellscript (OU)
    - Verantwoordelijke: Joost De Craemer
    - Tester: Lara Van Wynsberghe
4. Importeren acteurs, crewleden, 2 PC's in elke OU via CSV-file
    - Verantwoordelijke: Lara Van Wynsberghe
    - Tester: Liam Robyns
5. Via RSAT servers configureren vanop DirectorPC
    - Verantwoordelijke: Lara Van Wynsberghe
    - Tester: Joost De Craemer
6. Disable local users
    - Verantwoordelijke: Lara Van Wynsberghe
    - Tester: Jonas Feys
7. Toewijzen van rechten: cast / crew / directors
    - Verantwoordelijke: Lara Van Wynsberghe
    - Tester: Jonas Feys
8. Opstellen shared-folder; persoonlijk toewijzen, groepen creeëren
    - verantwoordelijke: Joost De Craemer
    - Tester: Liam Robyns
9. Basisregels op gebruikersniveau
    - Verantwoordelijke: Lara Van Wynsberghe
    - Tester: Jonas Feys
10. DNS: Queries
    - Verantwoordelijke: Liam Robyns
    - Tester: Jonas Feys
11. DNS: Queries geforward naar geschikte DNS-server
    - Verantwoordelijke: Liam Robyns
    - Tester: Jonas Feys
12. DNS: A, AAAA, PTR records voorzien
    - Verantwoordelijke: Liam Robyns
    - Tester: Jonas Feys
13. DNS: CNAME-records voor functie server
    - Verantwoordelijke: Liam Robyns
    - Tester: Jonas Feys
14. OPTIONAL! DNS: Andere records 
    - Verantwoordelijk: Liam Robyns
    - Tester: Jonas Feys
15. DHCP server + scopes via powershellscript
    - Verantwoordelijk: Lara Van Wynsberghe
    - Tester: Jonas Feys
16. Routerfunctie installeren (enkel voor simulatie via virtualbox internal netwerken)
    - Verantwoordelijk: Lara Van Wynsberghe
    - Tester: Joost

## Tijdbesteding

Gerelateerde tickets:
* SEP2223T02-9,SEP2223T02-18,SEP2223T02-7,SEP2223T02-20,SEP2223T02-25,SEP2223T02-26,SEP2223T02-27,SEP2223T02-19,SEP2223T02-30,SEP2223T02-21,SEP2223T02-39,SEP2223T02-45,SEP2223T02-56,SEP2223T02-69,SEP2223T02-71,SEP2223T02-72,SEP2223T02-76,SEP2223T02-81,SEP2223T02-139,SEP2223T02-135,SEP2223T02-59,SEP2223T02-156,SEP2223T02-158,SEP2223T02-175

* Fysieke labo's waarbij aan de domaincontroller werd gewerkt: <br/>
SEP2223T02-149,SEP2223T02-77,SEP2223T02-148

### Enkel de epic

| Student    | Geschat | Gerealiseerd |
| :---       | ---:    | ---:         |
| Liam       |    5,5  |       7      |
| Jonas      |    26,5 |       6,5    |
| Joost      |    35,5 |      64,5    |  
| Lara       |    42,5 |      30,25   |
| **totaal** |   110   |      108,25  |

![Tijdbesteding Epic](<pictures/tijdbesteding-epic-DC.jpg>)

### Inclusief fysieke labo's waarin aan Opdracht_DC werd gewerkt

| Student    | Geschat | Gerealiseerd |
| :---       | ---:    | ---:         |
| Liam       |     16  |       14,25  |
| Jonas      |     37  |       14,50  |
| Joost      |     46  |       79,00  |
| Lara       |     53  |       38,50  |
| **totaal** |   152   |      146,25  |

![Tijdbesteding Epic](<pictures/tijdbesteding-epicEnLabo-DC.jpg>)






