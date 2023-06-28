# Stappen om de GPO's te testen

Auteur(s) testplan: Lara Van Wynsberghe

## Startsituatie

* De DC werd aangemaakt
* De users zijn aangemaakt en zitten in de juiste groepen (Het script 'alle_users_OU_naar_groep.ps1' werd uitgevoerd)
* Er werd een cast PC aangemaakt
* Er werd een crew PC aangemaakt
* De GPO's werd toegepast op de juiste OU's, zoals omschreven in GPOs.md

## Disable local users

1. Voer het volgende commando uit op de computer waarop de GPO moet worden toegepast: `gpresult /r`. Onder "Applied Group Policy Objects" moet "CPT-Disable_Local_Accounts" te zien zijn.
2. Open "lusrmgr.msc". Alle gebruikers moeten uitgeschakeld zijn, inclusief de ingebouwde gebruiker *Administrator*.
3. Controleer of deze setting geen impact heeft op de domain controller

## Lokale login toestaan

### PC's van de cast

1. Open PCCast1.
2. Joel Silver (Producer) mag niet kunnen inloggen op deze PC.
3. Keanu Reeves (cast) moet wel kunnen inloggen.
4. Lilly Wachowski mag inloggen op deze PC.

Een voorbeeld wanneer het inloggen niet is toegestaan:
![Voorbeeld logon niet toegestaan](../Images/CPT_logon-niet-toegestaan.jpg?raw=true "Voorbeeld logon niet toegestaan")

### PC's van de crew

1. Open PCCrew1.
2. Keanu Reeves (cast) mag niet kunnen inloggen op deze PC.
3. Joel Silver (Producer) mag inloggen op deze PC.
4. Lilly Wachowski mag inloggen op deze PC.

### PC's en servers van de directors

1. Directors mogen op alle systemen inloggen. Controleer of Lilly Wachowski kan inloggen op de servers.
2. Controleer of een lid van de cast niet kan inloggen op de servers (inclusief de domain controller).
3. Controleer of Joel Silver niet kan inloggen op de server.

## Toegang tot het control panel

1. Controleer op een PC van de cast of Keanu Reeves geen toegang heeft tot het configuratiescherm.
2. Controleer of Lilly Wachowski wel toegang heeft tot het configuratiescherm.

## Niemand mag werkbalken kunnen toevoegen aan de taakbalk

1. Log in als de gebruiker Lilly Wachowski op een cast PC.
2. Klik met de rechter muisknop op de taakbalk en probeer een werkbalk toe te voegen. Dit zou niet mogen lukken.
3. Log in als de gebruiker Keanu Reeves op dezelfde cast PC.
4. Ook nu zou het toevoegen van een werkbalk niet mogen lukken.
5. Log in als de gebruiker Lilly Wachowski op de DC.
6. Ook hier zou het toevoegen van een werkbalk niet mogen lukken.
(7. Het is nog niet duidelijk of de domain administrator dit ook niet mag)

## Games link in het startmenu

**Deze GPO valt weg!**

De Games link in het startmenu ziet er als volgt uit:

![Games link](../Images/Gameslink.jpg?raw=true "Games link")

1. Controleer op een PC van de cast met gebruiker Keanu Reeves dat de Games link hier niet aanwezig is. Gebruik bovenstaande afbeelding om dit te kunnen vergelijken.
2. Controleer op een PC van de crew met gebruiker Lilly Wachowski dat de Games link hier niet aanwezig is. Gebruik bovenstaande afbeelding om dit te kunnen vergelijken.
3. Controleer op een PC van de crew met gebruiker Joel Silver dat de Games link hier niet aanwezig is. Gebruik bovenstaande afbeelding om dit te kunnen vergelijken.

## Toegang tot de eigenschappen van de netwerkadapters

1. Controleer op een PC van de cast met gebruiker Keanu Reeves dat het niet mogelijk is om de eigenschappen van de netwerkadapters te wijzigen
2. Controleer op dezelfde PC of dit met de gebruiker Lilly Wachowski wel mogelijk is.
3. Controleer op dezelfde PC of dit met de gebruiker Joel Silver ook mogelijk is.
