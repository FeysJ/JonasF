# Testrapport Opdracht 3.3: DC gedeelte GPO's

## Test GPO

Uitvoerder(s) test: Jonas Feys
Uitgevoerd op: 16/03/2023
Github commit:  COMMIT HASH

## GPO's aanmaken

De GPO's aangemaakt volgens het stappenplan in `GPOs.md`.
Dit is duidelijk en goed opgesteld om uit te voeren.

## Disable local accounts

![Disable local](../Images/testen/disable_local_lusrmgr.png?raw=true "Disable local")

## Lokale login toestaan

### PC's van de cast

1. Open PCCast1.
2. Joel Silver (Producer) mag niet kunnen inloggen op deze PC.
3. Keanu Reeves (cast) moet wel kunnen inloggen.
4. Lilly Wachowski mag inloggen op deze PC.

> Werking OK

### PC's van de crew

1. Open PCCrew1.
2. Keanu Reeves (cast) mag niet kunnen inloggen op deze PC.
3. Joel Silver (Producer) mag inloggen op deze PC.
4. Lilly Wachowski mag inloggen op deze PC.

> Werking OK
![Login cast op crew](../Images/testen/Login_cast_op_crew_niet_toegestaan.png?raw=true "Login cast op crew")

### PC's en servers van de directors

1. Directors mogen op alle systemen inloggen. Controleer of Lilly Wachowski kan inloggen op de servers.
2. Controleer of een lid van de cast niet kan inloggen op de servers (inclusief de domain controller).
3. Controleer of Joel Silver niet kan inloggen op de server.

> Werking OK
![Login server](../Images/testen/director_logon_server.png?raw=true "Login server")


## Toegang tot het control panel

1. Controleer op een PC van de cast of Keanu Reeves geen toegang heeft tot het configuratiescherm.
2. Controleer of Lilly Wachowski wel toegang heeft tot het configuratiescherm.

> Werking OK
> Moeilijk om foto toe te voegen indien toegang geweigerd wordt aangezien scherm niet opstart

## Niemand mag werkbalken kunnen toevoegen aan de taakbalk

1. Log in als de gebruiker Lilly Wachowski op een cast PC.
2. Klik met de rechter muisknop op de taakbalk en probeer een werkbalk toe te voegen. Dit zou niet mogen lukken.
3. Log in als de gebruiker Keanu Reeves op dezelfde cast PC.
4. Ook nu zou het toevoegen van een werkbalk niet mogen lukken.
5. Log in als de gebruiker Lilly Wachowski op de DC.
6. Ook hier zou het toevoegen van een werkbalk niet mogen lukken.

> Werking Ok
![Werkbalk](../Images/testen/werkbalk_niet_mogelijk.png?raw=true "Geen toegang tot werkbalk")


## Toegang tot de eigenschappen van de netwerkadapters

1. Controleer op een PC van de cast met gebruiker Keanu Reeves dat het niet mogelijk is om de eigenschappen van de netwerkadapters te wijzigen
2. Controleer op dezelfde PC of dit met de gebruiker Lilly Wachowski wel mogelijk is.
3. Controleer op dezelfde PC of dit met de gebruiker Joel Silver ook mogelijk is.

> Werking Ok
![LAN adapter](../Images/testen/toegang_lan_adapter.png?raw=true "Lan adapter geen toegang")