# GPO om shared folders te mappen aan een network drive

## Stappenplan voor de manuele configuratie

**Doel:** De shares automatisch mappen op een netwerkschijf, afhankelijk van de gebruiker.

1. Maak een nieuwe GPO aan met de naam "USR_Fileshares" </br>
![Nieuwe GPO](./Images/nieuwe-GPO.png?raw=true "Nieuwe GPO")
2. Bewerk de GPO en ga naar Gebruikersconfiguratie > Voorkeuren > Stationstoewijzingen
3. Voeg een nieuwe stationstoewijzing toe en kies de volgende algemene instellingen:
   1. Gebruik de locatie \\AGENTSMITH\ShareGRP_Crew
   2. Gebruik de aanduiding CrewShare
   3. Kies stationsletter X </br>
![CrewShare](./Images/USR_Fileshares/CrewShare.jpg?raw=true "Crew Share")
4. Selecteer de volgende Gedeelde instellingen:
   1. Vink de optie "Uitvoeren in beveiligingscontext van aangemelde gebruiker" aan
   2. Vink de optie "Itemniveau als doel instellen" aan </br>
   ![CrewShare gedeelde instellingen](./Images/USR_Fileshares/CrewShare-common.jpg?raw=true "Crew Common")
   3. Kies bij "Als doel instellen de 'Afdeling' OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local </br>
   ![CrewShare toewijzing](./Images/USR_Fileshares/CrewShare-toewijzing.jpg?raw=true "Crew Share toewijzing")
5. Voeg een nieuwe stationstoewijzing toe en kies de volgende algemene instellingen:
   1. Gebruik de locatie \\AGENTSMITH\ShareGRP_Cast
   2. Gebruik de aanduiding CastShare
   3. Kies stationsletter X </br>
   ![CastShare](./Images/USR_Fileshares/CastShare.jpg?raw=true "Cast Share")
6. Selecteer de volgende Gedeelde instellingen:
   1. Vink de optie "Uitvoeren in beveiligingscontext van aangemelde gebruiker" aan
   2. Vink de optie "Itemniveau als doel instellen" aan </br>
   3. Kies bij "Als doel instellen de 'Afdeling' OU=Cast,OU=DomainUsers,DC=TheMatrix,DC=local </br>
   ![CastShare toewijzing](./Images/USR_Fileshares/CastShare-toewijzing.jpg?raw=true "Cast Share toewijzing")
7. Voeg een nieuwe stationstoewijzing toe en kies de volgende algemene instellingen:
   1. Gebruik de locatie \\AGENTSMITH\Share_%Username%
   2. Gebruik de aanduiding PersoonlijkeShare
   3. Kies stationsletter Y </br>
   ![UserShare](./Images/USR_Fileshares/UserShare.jpg?raw=true "UserShare")
8. Selecteer de volgende Gedeelde instellingen:
   1. Vink de optie "Uitvoeren in beveiligingscontext van aangemelde gebruiker" aan
9. Koppel de policy aan de OU DomainUsers</br>
![Koppeling](./Images/USR_Fileshares/GPO-aanmaken.jpg?raw=true "Koppeling")

## Bronnen

<https://activedirectorypro.com/map-network-drives-with-group-policy>
