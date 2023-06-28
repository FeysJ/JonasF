# Testplan Opdracht Opdracht DC: Niet functionele requirements

Auteur(s) testplan: Joost De Craemer

## Niet-functionele requirements

### **NFR 1: Overdraagbaarheid**

| NFR            | Overdraagbaarheid                                      |
| :---           | :---                                                   |
| NFR            | Overdraagbaarheid                                      |
| Indicator      | Aanpasbaarheid                                         | 
|Meetvoorschrift | 4 gebruikers (vb de teamleden met hun persoonlijke laptops) hebben verschillende hardware. <br/> VirtualBox is geïnstalleerd en werkend op hun machines.|
| Norm           | Allen slagen ze erin om de VM-client (domein controller), onafhankelijk van hun hardware, foutloos te runnen a.d.h.v. van de beschreven werkwijze en scripts. Dit zonder de scripts aan te passen |

**Resultaat**: Voldaan

### **NFR 2: Onderhoudbaarheid**

| NFR            | Onderhoudbaarheid                                       |
| :---           | :---                                                   |
| NFR            | Onderhoudbaarheid                                     |
| Indicator      | Modulariteit                                       | 
|Meetvoorschrift | Een PC is uitgerust met een ander hypervisor programma (vb VMware) dan VirtualBox. Er wordt een VM met OS windowsserver2019 core manueel hierop aangemaakt (ter vervanging van script 1).  De configuratie van de domeincontroller wordt uitgevoerd maar nu enkel nog de deelscripts 2 en 3. |
| Norm           | De uitrol en configuratie van de domeincontrollerverloopt succesvol. De modulariteit door opsplitsing in meerdere scripts, laat dit toe.  |

**Resultaat:** Voldaan

### **NFR 3: Bruikbaarheid**

| NFR            |       Bruikbaarheid                                 |
| :---           | :---                                                   |
| NFR            |        Bruikbaarheid                                |
| Indicator      |         Voorkomen gebruikersfouten                                | 
|Meetvoorschrift | De VM (DC) is succesvol geïnstalleerd en geconfigureerd d.m.v. minimaal het 1ste script.   |
| Norm           |  De gebruiker probeert de installatie te verstoren door verkeerde invoer te maken.  Telkens de gebruiker een verkeerde input ingeeft, dient het script te stoppen met een verklarende boodschap. De gebruiker slaagt er niet in om het script te doorlopen zonder incorrecte invoer. |

**Resultaat:** Voldaan. <br/>
Een voorbeeld van één van de bekomen boodschappen vind je hieronder: <br/>
![IngaveBescherming](../pictures/BewijsBeschermingFouteInvoer.jpg?raw=true) 

### **NFR 4: Betrouwbaarheid**

| NFR            |     Betrouwbaarheid                                   |
| :---           | :---                                                   |
| NFR            |     Betrouwbaarheid                                 |
| Indicator      |    Foutbestendigheid                                     | 
|Meetvoorschrift | De VM met Domain Controller is (eventueel slechts deels) succesvol geïnstalleerd, en staat klaar om een deelscript 3 uit te voeren.   |
| Norm           |   Wanneer de gebruiker het script een 2de maal runt, moet het script foutloos verlopen en geen installaties uitvoeren die reeds gebeurd zijn tijdens het eerder runnen van het script. Telkens als het script een functionaliteit als reeds geïnstalleerd detecteert, informeert hij de gebruiker (omwille van het idempotent ontwerp) met een passende boodschap.|

**Resultaat:** Voldaan. <br/>
Hieronder vind je een voorbeeld waarbij de OU's reeds eerder aangemaakt zijn en het script deze opdracht niet opnieuw uitvoert.
![Idempotentie](../pictures/Idempotentie.jpg?raw=true) 


### **NFR 5: Functionele geschiktheid **

| NFR            |  Functionele geschiktheid                                       |
| :---           | :---                                                   |
| NFR            |  Functionele geschiktheid                                     |
| Indicator      |      Functionele compleetheid                                  | 
|Meetvoorschrift | Een guest-machine is geconfigureerd om met zekerheid de scripts succesvol uit te voeren. <br/> VirtualBox is geïnstalleerd en werkend op deze machine. |
| Norm           |   De gebruiker slaagt er in om zelfstandig de scripts te runnen en notuleerde  a.d.h.v. de functionele specificaties dat voor elke eis een succesvolle boodschap verschijnt die de installatie van die functionele eis bevestigt. Alle functionele eisen zijn aan bod gekomen te zijn. |

**Resultaat:** Voldaan. <br/>

### **NFR 6:  Bruikbaarheid  **

| NFR            |   Bruikbaarheid                                        |
| :---           | :---                                                   |
| NFR            |   Bruikbaarheid                                      |
| Indicator      |      Herkenbare geschiktheid                                  | 
|Meetvoorschrift | Bovenop de noodzakelijke hardware, is een correct werkend installatiescript voorhanden. De gebruiker/tester heeft het script nog niet eerder toegepast maar is wel vertrouwd met powershell commando’s en heeft technische basiskennis van systeembeheer en domeinen. |
| Norm           |   De gebruiker heeft na het doorlopen van het script het gevoel dat hij door de heldere opbouw van de cli-ingave en -boodschappen, de installatie heeft kunnen pauzeren, sturen en meevolgen. |

**Resultaat:** Voldaan. <br/>
Hieronder vind je een voorbeeld van verklarende uitvoer tijdens doorlopen van het 3de deelscript. Dit voor de wijziging SiteName en de aanmaak domeinstructuur. <br/>

![HerkenbareGeschiktheid](../pictures/VerklarendeUitvoer.jpg?raw=true) 