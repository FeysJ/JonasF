# Testrapport Opdracht DC: Script domain controller

## Test werking script om van de server een domain controller te maken

Uitvoerder(s) test: NAAM
Uitgevoerd op: 16/03/2023
Github commit:

* 1ea3c3828000d82efb68bd820c0298c28dd696e4 (scriptDC2023_03_05.ps1)
* 07b7416706f40bd78943071676a63efc7f87fbe5 (testplan_OpdrachtScriptDC.md)

### Ondernomen stappen

Een nieuwe server met Windows Server 2019 Core werd aangemaakt, volgens de specificaties die in de startsituatie omschreven werden.

De Guest additions werden geïnstalleerd, een gedeelde map werd aangemaakt en het bidirectionele klembord werd ingeschakeld.

Om naar deze situatie te kunnen terugkeren, werd een snapshot genomen.

De netwerkadapters werden niet gewijzigd. De NAT-adapter is wel aangesloten en er is toegang tot het internet.

De computernaam werd gewijzigd en de machine werd nadien herstart.

Na het herstarten, is de nieuwe computernaam in orde (AGENTSMITH).

Het installeren van AD DS is gelukt (ExitCode Succes).

Het domein werd aangemaakt. Er verschenen enkele warnings in de terminal over de ontbrekende delegering voor de DNS-server, het dynamische IP-adres (op de NAT-adapter) en over cryptografiealgoritmen, maar geen errors. De DNS Server-service wordt geïnstalleerd tijdens het maken van het forest. Hierna herstart de VM vanzelf.

Na het herstarten werd het script nogmaals uitgevoerd om de sitenaam te wijzigen.

De finale tests slagen. De computernaam is AGENTSMITH en het forest is TheMatrix.local.

### Extra test

1. In de vorige test was de NAT-adapter aangesloten en was er toegang tot het internet. Er werd een tweede test gedaan waarbij de NAT-adapter niet aagesloten was. Deze test faalt echter en geeft de volgende foutmelding:
![Error](../Images/Error-zonder-internet.jpg?raw=true)
2. Als de NAT-adapter wel is aangesloten, maar de host niet verbonden is met het internet, lukt de installatie wel.
3. Om minder lang te moeten wachten bij het scherm "Computerinstellingen toepassen", werd de CPU verhoogd, maar dit verhielp het probleem niet.
4. Het verhogen van het geheugen naar 4GB RAM (met opnieuw 1 CPU), leek ook geen merkbaar verschil te geven.

### Voorstellen

* In plaats van Y/y te moeten ingeven, zou ik Y als default antwoord nemen, zodat iemand die enkel op enter drukt, meteen in het volgende menu terecht komt, in plaats van het script af te breken.
