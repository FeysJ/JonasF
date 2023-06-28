# Opdracht: Pc’s en servers hebben geen eigen gebruikers, authenticatie gebeurt telkens via de Domain Controller

De users op de DC zijn echter users in het domain, dus op deze server moet een uitzondering gemaakt worden.

## Optie 1

Op elke computer uitvoeren na het opstarten:
`Get-Localuser | Disable-LocalUser`

## Optie 2

Op elke computer uitvoeren na het opstarten:
`net user administrator /active:no`
(idem guest user, ...)

## Optie 3

```powershell
Import-Module GroupPolicy

$nieuwe_GPO = New-GPO -Name "CPT-Disable_Local_Accounts" -Comment "Deze GPO disabled lokale user accounts op computers"
New-GPLink -Guid $nieuwe_GPO.Id -Target "OU=DomainWorkstations,DC=TheMatrix,DC=local"

Set-GPRegistryValue -Guid $nieuwe_GPO.Id -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -ValueName "Administrator" -Type DWORD -Value 0
Set-GPRegistryValue -Guid $nieuwe_GPO.Id -Key "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -ValueName "Guest" -Type DWORD -Value 0
# Onderstaande komt ook voor in de best practices voor het uitschakelen van accounts:
Set-GPRegistryValue -Guid $nieuwe_GPO.Id -Key "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" -ValueName "LimitBlankPasswordUse" -Type DWORD -Value 1

# Opmerking: De GPO werkt, maar Get-LocalUser geeft nog steeds lokale accounts terug op de DirectorPC die enabled zijn**
```

## Optie 4

**Dit is de gekozen optie. Deze optie kan bovendien ook gebruikt worden voor de andere vereisten.**

De settings manueel instellen en exporteren. Bij het opzetten van een nieuwe DC, deze settings (XML) importeren.

Stappenplan: zie document "GPOs.md"

## Bronnen

* <https://learn.microsoft.com/en-us/powershell/module/grouppolicy/new-gpo?view=windowsserver2022-ps>
* <https://poweradm.com/disable-local-windows-accounts-gpo>
* <https://stackoverflow.com/questions/58225231/how-can-i-link-with-new-gplink-a-gpo-to-organizational-unit-thats-encapsulate>
* <https://woshub.com/manage-group-policy-objects-powershell>
* <https://social.technet.microsoft.com/Forums/windows/en-US/345eb2a1-233d-48f8-ace5-7b4436e33dce/disable-admin-account-through-registry?forum=w7itprosecurity>
* <https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-default-user-accounts>
