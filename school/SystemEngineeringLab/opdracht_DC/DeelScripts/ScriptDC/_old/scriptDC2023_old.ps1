#Basisconfiguratie DomainController
Clear-Host
#uitzetten windows updates
write-host "windows updates worden uitgezet"
sc.exe config wuauserv start=disabled
#Set-Service -Name wuauserv -StartupType Manual 
#Set-Service -Name wuauserv -Status stopped -StartupType Disabled
#Start-Service -Name "wuauserv"
write-host "`n`n" 
#Network config (Note, check if index w/ first command)
Get-NetAdapter
New-NetIPAddress -InterfaceIndex 6 -IPAddress 192.168.168.130 -PrefixLength 29 -DefaultGateway 192.168.168.129
Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses 192.168.168.130
#To confirm
ipconfig /all
#Wijzigen Computernaam
write-host "Computernaam is: $env:COMPUTERNAME"
Write-host "wenst u deze te wijzigen druk (Y):"
[string]$antwoord = read-host
if ($antwoord -eq "y")
{write-host "Welke naam wil je de machine geven?:" 
[string]$naam = Read-host
Rename-computer -NewName "$naam”	
write-host "De computernaam is nu $env:COMPUTERNAME en wordt na herstart $naam"
Write-Host "`n`nWenst u De computer te herstarten? (Y): "
[string]$antwoord = read-host
if ($antwoord -eq "y")
{write-host "De computer wordt herstart`nEven (5sec) geduld"
 Start-Sleep 5
Restart-computer
}
else {write-host "Eventuele naamwijziging dient aktief te zijn vooraleer AD DS te installeren!! "}

}
else {"De computernaam werd niet gewijzigd en blijft $env:COMPUTERNAME" }

#installatie AD DS 
Write-Host "`n`nWenst u AD DS te installeren? (Y): "
[string]$antwoord = read-host
if ($antwoord -eq "y")
{write-host "AD Domain services wordt geïnstalleerd`nEven geduld" 
Install-WindowsFeature -Name AD-Domain-services -IncludeManagementTools
}
else {write-host "AD DS werd niet geïnstalleerd"}


$bos = "TheMatrix.local"
Write-Host "`n`nWenst u het domein $bos aan te maken (Y): "
[string]$antwoord = read-host
if ($antwoord -eq "y")
{write-host "Het domein $bos wordt aangemaakt`nEven geduld" 
#
# Windows PowerShell-script voor AD DS-implementatie
#

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "TheMatrix.local" `
-DomainNetbiosName "THEMATRIX" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
read-host "de computer zal herstart worden (enter)"
Restart-computer
}
else {write-host "Het domein $bos werd niet aangemaakt"}



