# Cheat sheet powershell commands

## vboxmanage
'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe' controlvm VMName nic1 bridged "Intel(R) Wi-Fi 6 AX201 160MHz"

## Algemeen
* opvragen aanwezige drives van de machine<br/>
PS> get-PSdrive
* keyboard taal op azerty plaatsen <br/>
PS> set-winUSerlanguageList nl-BE -force

## Adapter settings
* Opvragen interfaceindices van alle netw adapters <br/>
PS> get-netadapter
* Instellen adapter op DHCP <br/>
PS> Set-NetIPInterface -interfaceindex `<interfaceindexnr`> -dhcp enabled
* Instellen fixed IP-adres <br/>
PS> New-NetIPAddress -InterfaceIndex 8 -IPAddress 192.168.168.130 -PrefixLength 28 -DefaultGateway 192.1688.168.129
* instellen dns <br/>
PS> Set-DnsClientServerAddress -InterfaceIndex `<interfaceindexnr`>  -ServerAddresses `<dnsIPaddress`> 
* instellen dns op auto <br/>
* soortgelijke info aan ipconfig <br/>
PS> Get-NetIPConfiguration 
* wissen van een ipadress
PS> Get-NetIPAddress -IPaddress `<IPaddress vb: 192.168.168.130`> | Remove-NetIPAddress 
* oproepen default gateway <br/>
PS> get-netroute -DestinationPrefix "0.0.0.0/0"
* verwijderen default gateway (op basis van info get-netroute -DestinationPrefix "0.0.0.0/0")
PS> Remove-Netroute -ifindex `<indexnr`> -destinationPrefix "0.0.0.0/0" -nexthop `<defaultGateway address`>
* toevoegen van een default gateway
PS> new-Netroute -ifindex `<indexnr`> -destinationPrefix "0.0.0.0/0" -nexthop `<defaultGateway address`>

## vergelijking 
* expliciete case insensitive equal <br/>
if ($antwoord -ieq "y") { <# acties #> }
* niet gelijk aan <br/>
if ($antwoord -ne "") { <# acties #> }
* or van 2 condities<br/>
if (($antwoord -ne "joost") -or ($antwoord -ne "")) { <# acties #> }
* and van 2 condities<br/>
if (($antwoord -ne "joost") -and ($antwoord -ne "")) { <# acties #> }

## Regex
* Een exact patroon vinden: vb "\b`<hier staat het patroon`>\b><br/>
vboxmanage.exe list vms | Select-String -pattern "\bWindowsServerAgentSmit\b"

## Shares
* Naar een share navigeren <br/>
PS> cd \\AgentSmith\ShareGRP_cast
* Share mappen via powershell **opzoeken** <br/>
Zelfde als via explorer: "Deze PC" +  RM "nieuwe netwerkverbinding maken" + map invullen (vb \\AgentSmith\ShareGRP_cast)

## dhcp
* leasetime instellen (nog testen!!!) <br/>
Set-DhcpServerv4Scope -ComputerName "TheDHCPSERVER" -LeaseDuration 8.00:00:00

## Oproepen ADDS info
* opvragen info van een domain forest
PS> Get-ADForest -Identity TheMatrix.local
* opvragen naam van een bepaald domain forest
PS> Get-ADForest -Identity TheMatrix.local | ForEach-Object name
* Opvragen zichtbare DC<br/>
PS> Get-ADDomainController
* Opvragen aanwezige groepen <br/>
PS> Get-ADUser -Filter * | ForEach-Object name
* Opvragen aanwezige user-namen<br/>
PS> Get-ADUser -Filter * | ForEach-Object name
* opvragen alle users uit een OU
PS> Get-ADUser -Filter * -SearchBase “ou=testou,dc=iammred,dc=net”
* opvragen computer
* opvragen computers uit een OU
Get-ADComputer -Filter * -SearchBase "OU=servers, OU= DomainWorkstations,DC=theMatrix,DC=local"
* opvragen OUs<br/>
PS> Get-ADOrganizationUnit -filter * | ForEach-Object name
* opvragen SMB sharedFolders <br/>
PS> Get-smbShare
* opvragen van de aanwezige dhcp scopes
Get-DhcpServerv4Scope -ComputerName "agentsmith.thematrix.local" 
* opvragen van een bepaalde dhcp scope <br/>
Get-DhcpServerv4Scope -ComputerName "agentsmith.thematrix.local" -ScopeId 192.168.168.0

## RSAT
* oproepen online beschikbare RSAT tools <br/>
Get-WindowsCapability -Name RSAT* -online
* installeren van een RSAT tool <br/>
Add-WindowsCapability -online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
* controleren via computer systeembeheer <br/>
Start > Windows Systeembeheer

# Cheats van uitgevoerde acties
* DC kon niet de directorPC pingen. Andersom ging wel <br/>
firewall uitgezet op directorPC 
    * configuratiescherm
    * systeem en beveiliging
    * windows defender firewall 
    * rechts "windows defender firewall in-of uitschakelen"
* problemen github <br/>
https://github.blog/2023-03-23-we-updated-our-rsa-ssh-host-key/

* adaptersettings openen in windows11
ncpa.cpl

# Powershell openen met mogelijkheid om onveilige scripts uit te voeren

PowerShell -ExecutionPolicy Bypass

# Instellen rechten voor runnen van scripts op machine
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned