# GPO's

## Disable local users

**Doel:** Pc’s en servers hebben geen eigen gebruikers, authenticatie gebeurt telkens via de Domain Controller.

Voorwaarden:

1. Ga **vanop de DirectorPC** naar de map "\\Agentsmith\NETLOGON".
2. Maak in deze map het bestand "disable_local_users.ps1" aan.
3. De inhoud van dit bestand moet de volgende code bevatten: `Get-Localuser | Disable-LocalUser -Confirm:$false`

Maak de GPO als volgt:

1. Maak een nieuwe GPO aan. Gezien het over een computer policy gaat, krijgt de GPO de prefix "CPT" in de naam "CPT_disable_local_accounts". </br>
![Nieuwe GPO](./Images/nieuwe-GPO.png?raw=true "Nieuwe GPO")

2. Ga bij het bewerken van de policy naar Computerconfiguratie > Beleidsregels > Windows-instellingen > Scripts > Opstarten </br>
![Bewerk de GPO](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-edit.png?raw=true "Bewerk de GPO")

3. Kies "PowerShell-scripts" en voeg hier de locatie van het script aan toe (`\\Agentsmith\NETLOGON\disable_local_users.ps1`) </br>
![Script toevoegen](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-script-toevoegen.png?raw=true "Script toevoegen")

4. Ga in het hoofdmenu bij "Delegering" naar Geavanceerd en voeg de Computer AGENTSMITH toe. Vink "Weigeren" aan onder de machtigingen, bij "Groepsbeleid toepassen". </br>
![Delegeren: uitzondering voor Agentsmith](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-delegering.png?raw=true "Delegeren: uitzondering voor Agentsmith")

5. Pas de GPO toe op alle Geverifieerde gebruikers. </br>
![Delegeren: Toepassen op andere domain workstations](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-delegering2.png?raw=true "Delegeren: Toepassen op andere domain workstations")

6. Koppel de GPO aan de DomainWorkstations. </br>
![GPO koppelen](./Images/CPT-disable_local_accounts/CPT-disable_local_accounts-koppelen.png?raw=true "GPO koppelen")

Overzicht (instellingen):

![Disable local users](./Images/CPT-disable_local_accounts/CPT_disable_local_accounts.jpg?raw=true "Disable local users")

## Lokale login toestaan

**Doel:** Zorg ervoor dat de cast enkel kan inloggen in de cast-Pc’s, de crew enkel
op de crew-Pc’s. Directors kunnen overal inloggen.

Voorwaarden:

Om de rechten op de juiste groep toe te passen, moeten er groepen aangemaakt worden. Gebruik het script "alle_users_OU_naar_groep.ps1" om de nodige groepen aan te maken, indien dit nog niet is gebeurd.

### CPT_Allow_logon_directors_cast

1. Maak een nieuwe GPO aan met de naam "CPT_Allow_logon_directors_cast" </br>
![Nieuwe GPO](./Images/nieuwe-GPO.png?raw=true "Nieuwe GPO")

2. Bewerk de GPO en ga naar Computerconfiguratie > Beleidsregels > Windows-instellingen > Beveiligingsinstellingen > Lokaal beleid > Toewijzing van gebruikersrechten > Lokaal aanmelden toestaan </br>
![Bewerk de GPO](./Images/CPT_Allow_logon_directors_cast/CPT-Allow_logon_directors-edit.png?raw=true "Bewerk de GPO")

3. Voeg de volgende groepen toe: Administrators, GRP_Cast en GRP_Directors (zie screenshot hierboven)

4. Koppel de policy aan de OU Cast (DomainWorkstations > PC's) </br>
![Koppel de GPO](./Images/CPT_Allow_logon_directors_cast/CPT-Allow_logon_directors-koppelen.png?raw=true "Koppel de GPO")

5. Pas de GPO toe op de "Geverifieerde gebruikers" (dit is default het geval). </br>
![Filtering](./Images/CPT_Allow_logon_directors_cast/CPT_Allow_logon_directors_cast-filtering.png?raw=true "Filtering")

Overzicht (instellingen): </br>
![CPT_Allow_logon_directors_cast](./Images/CPT_Allow_logon_directors_cast/CPT_Allow_logon_directors_cast.jpg?raw=true "CPT_Allow_logon_directors_cast")

### CPT_Allow_logon_crew

1. Maak een nieuwe GPO aan met de naam "CPT_Allow_logon_crew"
2. Bewerk de GPO en ga naar Computerconfiguratie > Beleidsregels > Windows-instellingen > Beveiligingsinstellingen > Lokaal beleid > Toewijzing van gebruikersrechten > Lokaal aanmelden toestaan </br>
![GPO bewerken](./Images/CPT_Allow_logon_crew/CPT_Allow_logon_crew-bewerken.png?raw=true "GPO bewerken")

3.Voeg de volgende groepen toe: Administrators, GRP_Crew (zie screenshot hierboven)

4.Koppel de policy aan de OU Crew (DomainWorkstations > PC's) </br>
![GPO koppelen](./Images/CPT_Allow_logon_crew/CPT_Allow_logon_crew-koppeling.png?raw=true "GPO koppelen")

5.Pas de GPO toe op de "Geverifieerde gebruikers" (dit is default het geval).

Overzicht instellingen: </br>
![CPT_Allow_logon_crew](./Images/CPT_Allow_logon_crew/CPT_Allow_logon_crew.jpg?raw=true "CPT_Allow_logon_crew")

### CPT_Allow_logon_directors

1. Maak een nieuwe GPO aan met de naam "CPT_Allow_logon_directors"
2. Bewerk de GPO en ga naar Computerconfiguratie > Beleidsregels > Windows-instellingen > Beveiligingsinstellingen > Lokaal beleid > Toewijzing van gebruikersrechten > Lokaal aanmelden toestaan </br>
![GPO bewerken](./Images/CPT_Allow_logon_directors/CPT_Allow_logon_directors-bewerken.png?raw=true "GPO bewerken")

3.Voeg de volgende groepen toe: Administrators, GRP_Directors (zie screenshot hierboven)
4.Koppel de policy aan de OU DomainWorkstations </br>
![Koppeling GPO](./Images/CPT_Allow_logon_directors/CPT_Allow_logon_directors-koppeling.png?raw=true "Koppeling GPO")

5.Pas de GPO toe op de "Geverifieerde gebruikers" (dit is default het geval).

Overzicht instellinge: </br>
![CPT_Allow_logon_directors](./Images/CPT_Allow_logon_directors/CPT_Allow_logon_directors.jpg?raw=true "CPT_Allow_logon_directors")

## Gebruikersbeleid

### USR_prevent-access-control-panel

**Doel:** verbied iedereen behalve de directors de toegang tot het control panel

1. Maak een nieuwe GPO aan met de naam "USR_prevent-access-control-panel"
2. Schakel de volgende policy in, bij het bewerken van de GPO: 'Gebruikersconfiguratie' > 'Beleidsregels' > 'Beheersjablonen: beleidsdefinities (ADMX-bestanden)' > 'Configuratiescherm' > 'Toegang tot het Configuratiescherm en de PC-instellingen verbieden' </br>
![GPO bewerken](./Images/USR_prevent-access-control-panel/USR_prevent-access-control-panel-bewerken.png?raw=true "GPO bewerken")

3. Pas de volgende delegering toe:
    * Groepsbeleid toepassen op "Geverifieerde gebruikers"
    * Groepsbeleid toepassen WEIGEREN op de groep GRP_Directors
![Delegering 1](./Images/USR_prevent-access-control-panel/USR_prevent-access-control-panel-delegering1.png?raw=true "Delegering 1") </br>
![Delegering 2](./Images/USR_prevent-access-control-panel/USR_prevent-access-control-panel-delegering2.png?raw=true "Delegering 2")

4. Koppel de policy aan de OU DomainUsers (opgelet! Dit is uitgezonderd de directors, via de delegering) </br>
![Koppeling GPO](./Images/USR_prevent-access-control-panel/USR_prevent-access-control-panel-koppeling.png?raw=true "Koppeling GPO")

Overzicht instellingen: </br>
![USR_prevent-access-control-panel](./Images/USR_prevent-access-control-panel/USR_prevent-access-control-panel.jpg?raw=true "USR_prevent-access-control-panel")

### USR_prevent-access-network-adapter

**Doel:** verbied iedereen van de cast de toegang tot de eigenschappen van de netwerkadapters.

1. Maak een nieuwe GPO aan met de naam "USR_prevent-access-network-adapter"
2. Schakel de volgende policy in, bij het bewerken van de GPO: 'Gebruikersconfiguratie' > 'Beleidsregels' > 'Beheersjablonen: beleidsdefinities (ADMX-bestanden)' > Netwerk > Netwerkverbindingen > Toegang tot de eigenschappen van een LAN-verbinding verbieden </br>
![GPO bewerken](./Images/USR_prevent-access-network-adapter/USR_prevent-access-network-adapter-bewerken.png?raw=true "GPO bewerken")

3. Koppel de policy aan de OU Cast </br>
![GPO koppelen](./Images/USR_prevent-access-network-adapter/USR_prevent-access-network-adapter-koppeling.png?raw=true "GPO koppelen")

4. Pas de GPO toe op de "Geverifieerde gebruikers" (dit is default het geval).

Overzicht instellingen: </br>
![USR_prevent-access-network-adapter](./Images/USR_prevent-access-network-adapter/USR_prevent-access-network-adapter.jpg?raw=true "USR_prevent-access-network-adapter")

### USR_Prevent_adding_toolbars

**Doel:** Zorg ervoor dat niemand werkbalken (toolbars)kan toevoegen aan de taakbalk **Deze nieuwe GPO wordt gevraagd in de maart-update**

1. Maak een nieuwe GPO aan met de naam "USR_prevent_adding_toolbars"
2. Schakel de volgende policy in, bij het bewerken van de GPO: 'Gebruikersconfiguratie' > 'Beleidsregels' > 'Beheersjablonen: beleidsdefinities (ADMX-bestanden)' > Startmenu en Taakbalk > Voorkomen dat gebruikers werkbalken toevoegen of verwijderen </br>
![GPO bewerken](./Images/USR_Prevent_adding_toolbars/USR_Prevent_adding_toolbars-bewerken.png?raw=true "GPO bewerken")
3. Koppel de policy aan de OU DomainUsers </br>
![GPO koppelen](./Images/USR_Prevent_adding_toolbars/USR_Prevent_adding_toolbars-koppeling.png?raw=true "GPO koppelen")

4. Pas de GPO toe op de "Geverifieerde gebruikers" (dit is default het geval).

Overzicht instellingen: </br>
![USR_Prevent_adding_toolbars](./Images/USR_Prevent_adding_toolbars/USR_Prevent_adding_toolbars.jpg?raw=true "USR_Prevent_adding_toolbars")

### USR_disable-games-link

**Deze GPO valt weg!**

Bij het bewerken van de GPO, de volgende policy inschakelen: 'Gebruikersconfiguratie' > 'Beleidsregels' > 'Beheersjablonen: beleidsdefinities (ADMX-bestanden)' > 'Startmenu en Taakbalk' > 'De koppeling Ontspanning verwijderen uit het Startmenu'

Deze policy wordt gekoppeld aan de OU DomainUsers

Delegering:

* Groepsbeleid toepassen op "Geverifieerde gebruikers"
* Groepsbeleid toepassen WEIGEREN op de groep GRP_Directors

Overzicht instellingen: </br>
![USR_disable-games-link](./Images/USR_disable-games-link.jpg?raw=true "USR_disable-games-link")

## Overzicht van alle koppelingen

![Overzicht koppelingen](./Images/GPO_koppelingen.jpg?raw=true "Overzicht koppelingen")

## USR_Fileshares

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

## ACL's om excludes te doen voor GPO's, na het importeren van een back-up

Voor de volledige uitwerking, zie [Automatisatie_exclude_delegering.md](_oud_\Automatisatie_exclude_delegering.md)

### CPT_disable_local_accounts

```powershell
$dc = Get-ADComputer -Identity "Agentsmith"

$rechtenGuid = [Guid]"edacfd8f-ffb3-11d1-b41d-00a0c968f939"
$sid = $dc.SID
$ctrlType = [System.Security.AccessControl.AccessControlType]::Deny
$rechten = [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight

$rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($sid, $rechten, $ctrlType, $rechtenGuid)

$cptgpo = get-gpo -Name "CPT_disable_local_accounts"
$aclPath = "ad:$($cptgpo.path)"
$acl = get-acl "ad:$($cptgpo.path)"
$acl.AddAccessRule($rule)
Set-Acl -aclObject $acl -path $aclPath

Set-GPPermission -Name "CPT_disable_local_accounts" -TargetName "AGENTSMITH" -TargetType Computer -PermissionLevel GpoRead
New-GPLink -Guid $cptgpo.Id -Target "ou=DomainWorkstations,dc=thematrix,dc=local" -LinkEnabled Yes
```

### USR_prevent-access-control-panel

```powershell
$GRP_Directors = Get-ADGroup -Identity "CN=GRP_Directors,OU=Directors,OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local"

$rechtenGuid = [Guid]"edacfd8f-ffb3-11d1-b41d-00a0c968f939"
$sid = $GRP_Directors.SID
$ctrlType = [System.Security.AccessControl.AccessControlType]::Deny
$rechten = [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight

$rule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule($sid, $rechten, $ctrlType, $rechtenGuid)

$usrgpo=get-gpo -Name "USR_prevent-access-control-panel"
$aclPath = "ad:$($usrgpo.path)"
$acl = get-acl "ad:$($usrgpo.path)"
$acl.AddAccessRule($rule)
Set-Acl -aclObject $acl -path $aclPath

`Set-GPPermission -Name "USR_prevent-access-control-panel" -TargetName "GRP_Directors" -TargetType Group -PermissionLevel GpoRead`
```

## Bronnen

Disable local users:

* <https://learn.microsoft.com/en-us/powershell/module/grouppolicy/new-gpo?view=windowsserver2022-ps>
* <https://poweradm.com/disable-local-windows-accounts-gpo>
* <https://stackoverflow.com/questions/58225231/how-can-i-link-with-new-gplink-a-gpo-to-organizational-unit-thats-encapsulate>
* <https://woshub.com/manage-group-policy-objects-powershell>
* <https://social.technet.microsoft.com/Forums/windows/en-US/345eb2a1-233d-48f8-ace5-7b4436e33dce/disable-admin-account-through-registry?forum=w7itprosecurity>
* <https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-default-user-accounts>

Allow log on locally:

* <https://4sysops.com/archives/deny-and-allow-workstation-logons-with-group-policy>

Control panel:

* <https://www.lepide.com/blog/top-10-most-important-group-policy-settings-for-preventing-security-breaches>

Games link:

* <https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.StartMenu::NoGamesFolderOnStartMenu>

Toegang tot de eigenschappen van de netwerkadapter:

* <https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.NetworkConnections::NC_LanProperties>

Shared folders:

* <https://activedirectorypro.com/map-network-drives-with-group-policy>

ACL's:

* <https://serverfault.com/questions/854672/get-and-set-granular-gpo-permissions>
* <https://gist.github.com/rjmholt/4d00bc7bb07a8c2be49184ac84fb993b>
* <https://activedirectoryfaq.com/2021/03/manager-can-update-membership-list>
* <https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/1522b774-6464-41a3-87a5-1e5633c3fbbb>
* <https://learn.microsoft.com/en-us/windows/win32/adschema/extended-rights>
