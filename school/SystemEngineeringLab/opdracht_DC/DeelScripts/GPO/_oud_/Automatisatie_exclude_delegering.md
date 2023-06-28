# Dit is de kladversie van de experimenten om bepaalde groepen of computers te excluden voor GPO's

## CPT_disable_local_accounts

### Oude versie

```powershell
Set-GPPermission -Name "CPT_disable_local_accounts" -TargetName "AGENTSMITH" -TargetType Computer -PermissionLevel GpoRead
Set-GPPermission -Name "CPT_disable_local_accounts" -TargetName "Geverifieerde gebruikers" -TargetType Group -PermissionLevel GpoApply

$GPO = Get-GPO -Name "CPT_disable_local_accounts"
New-GPLink -Guid $GPO.Id -Target "ou=DomainWorkstations,dc=thematrix,dc=local" -LinkEnabled Yes
```

> Het probleem is dat de GPO niet expliciet geweigerd wordt voor AGENTSMITH.

### Nieuwe versie met ACL's van het type activedirectoryaccessrule

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

## USR_prevent-access-control-panel

### OUDE VERSIE

`Set-GPPermission -Name USR_prevent-access-control-panel -TargetName "GRP_Directors" -TargetType Group -PermissionLevel GpoRead`

> Het probleem met deze versie is dat de GPO niet expliciet geweigerd wordt.

### Versie met ACL's van het type activedirectoryaccessrule

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

Ter info:
Alle rechten bekijken: `(get-acl "ad:$($usrgpo.path)").Access`

### Bronnen

<https://serverfault.com/questions/854672/get-and-set-granular-gpo-permissions>
<https://gist.github.com/rjmholt/4d00bc7bb07a8c2be49184ac84fb993b>
<https://activedirectoryfaq.com/2021/03/manager-can-update-membership-list>
<https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/1522b774-6464-41a3-87a5-1e5633c3fbbb>
<https://learn.microsoft.com/en-us/windows/win32/adschema/extended-rights>
