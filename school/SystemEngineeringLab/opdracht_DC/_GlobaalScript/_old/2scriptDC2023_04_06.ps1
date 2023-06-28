# Functies
# Dit script start met een VM waarop windows Server 2019 reeds is geïnstalleerd

# Voorstel: In plaats van Y/y te moeten ingeven, zou ik Y als default antwoord nemen, zodat iemand die enkel op enter drukt, meteen in het volgende menu terecht komt, in plaats van het script af te breken.

function BasisInstelling ($DCadres,$prefixLengte,$DefGat,$DefaultCompName, $IfIndex) {
   
    Clear-Host
    #uitzetten windows updates
    write-host "Windows updates worden uitgezet"
    sc.exe config wuauserv start=disabled
        # Ik had het gehoopt om zoals hieronder te doen maar lukte niet
        #Set-Service -Name wuauserv -StartupType Manual 
        #Set-Service -Name wuauserv -Status stopped -StartupType Disabled
        #Start-Service -Name "wuauserv"
    write-host "`n`n" 

    # Code Liam
    #Network config (Note, check if index w/ first command)
    Get-NetAdapter
    Write-host "Wenst u de Netwerk-adapters te wijzigen druk [`"ja`": druk enter]?"
    [string]$antwoord = read-host
    if ($antwoord -eq "") {
        New-NetIPAddress `
            -InterfaceIndex $IfIndex `
            -IPAddress $DCadres `
            -PrefixLength $prefixLengte `
            -DefaultGateway $DefGat
        Set-DnsClientServerAddress `
            -InterfaceIndex $ifIndex `
            -ServerAddresses $DCadres
        # Onderstaand kan verwijderd worden maar dient voorlopig als debug feature 
        write-host "Hieronder kunt u nazien of de adapter met adres $DCadres correct werd aangemaakt"
        ipconfig /all
        }
    else {
    write-host "Netwerkadapters werden niet aangepast, deze zijn: `n`n" 
    Get-NetAdapter
    }
    #einde code liam


#Wijzigen Computernaam
    write-host "`n`nHuidige computernaam is: $env:COMPUTERNAME"
    [string]$antwoord = read-host "wenst u deze te wijzigen druk (`"ja`": druk enter)?"
    if ($antwoord -eq "") {	
        $naam=$DefaultCompName  
        $antw = read-host "Wens je de default Machinenaam ($DefaultCompName) toe te passen [`"ja`": druk enter]"
        if (!($antw -eq "")) {
            $naam=Read-host "Welke naam wil je de Machine geven?" 
        }
        If ($naam -eq $env:COMPUTERNAME) {
            write-host "`nDe computernaam is reeds $env:COMPUTERNAME en kan bijgevolg niet gewijzigd worden in $naam"
        }
        else {
            Rename-computer -NewName $naam
            write-host "`nDe computernaam is nu $env:COMPUTERNAME en wordt na herstart $naam"
            [string]$antwoord = read-host "`nWenst u De computer te herstarten [`"ja`": druk enter]?"
            if ($antwoord -eq "") {
                write-host "De computer wordt herstart`nEven (5sec) geduld"
                Start-Sleep 5
                Restart-computer
            else {
                write-host "Eventuele naamwijziging dient aktief te zijn vooraleer AD DS te installeren!! "
                }
            }
        }
    }
    else {
        write-host "De computernaam werd niet gewijzigd en blijft $env:COMPUTERNAME" 
        }
}

#installatie AD DS 

function installADDS ($bos) {
#
# Windows PowerShell-functie voor AD DS-implementatie
#
    [string]$antwoord = read-host "`n`nWenst u AD DS te installeren [`"ja`": druk enter]? "
    if ($antwoord -eq "") {
        write-host "AD Domain services wordt geinstalleerd`nEven geduld" 
        Install-WindowsFeature -Name AD-Domain-services -IncludeManagementTools
    }
    else {
        write-host "AD DS werd niet geinstalleerd"
        }
    [string]$antwoord = read-host "`nWenst u het domein $bos aan te maken [`"ja`": druk enter]? "
    if ($antwoord -eq "") {
            write-host "Het domein $bos wordt aangemaakt`nEven geduld" 
            Import-Module ADDSDeployment
            Install-ADDSForest `
                -CreateDnsDelegation:$false `
                -DomainName "TheMatrix.local" `
                -DomainNetbiosName "THEMATRIX" `
                -DomainMode "WinThreshold" `
                -ForestMode "WinThreshold" `
                -InstallDns:$true `
                -LogPath "C:\Windows\NTDS" `
                -DatabasePath "C:\Windows\NTDS" `
                -SysvolPath "C:\Windows\SYSVOL" `
                -NoRebootOnCompletion:$false `
                -Force:$true
            read-host "de computer zal herstart worden (enter)"
            Restart-computer
        }
        else {
            write-host "Het domein $bos werd niet aangemaakt want bestaat reeds`n" 
        }
    else {
        if ( !(Get-ADForest -Identity $bos -ea 0) ){
            write-host "Het domein $bos werd niet aangemaakt en is aanwezig"
        }
        if (Get-ADForest -Identity $bos -ea 0)  {
            write-host "Het domein $bos werd niet aangemaakt en is nog niet aanwezig! Run script nogmaals om dit recht te zetten"
        }
    }
}

function WijzigSiteName ($defaultNaam){
$Site = Get-ADReplicationSite
$Sitenaam= $Site.name
$antwoord = read-host "`n`nWens je de huidige sitename $sitenaam te wijzigen [`"ja`": druk enter]?"
if ($antwoord -eq "") {
        $antw = read-host "Wens je de default sitename $defaultNaam toe te passen [`"ja`": druk enter]?"
            if ($antw -eq "") {
            Get-ADReplicationSite $Sitenaam | Rename-ADObject -NewName $defaultNaam
            }
            else {
                $newSiteNaam=Read-host "Welke naam wil je de Site geven?" 
                Get-ADReplicationSite $Sitenaam | Rename-ADObject -NewName $newSiteNaam
            }
        $Site = Get-ADReplicationSite
        $Sitenaam= $Site.name
        write-host "De Sitenaam is nu: $Sitenaam"
        }
else {
    write-host "De Sitenaam werd niet gewijzigd en blijft $Sitenaam"
    }
}
# ------------
# Main Script
# ------------

# variabelen
$DC_adres="192.168.168.130"
$prefix_Lengte=28
$Def_Gat="192.168.168.129"
$DefaultSiteName = "SiteTi02"
$DefCompName = "AgentSmith"
$IfIndex = [int]((Get-NetAdapter).InterfaceIndex | Select-Object -first 1)

# Hier zeer veel tijd verloren. Indien meerdere parameters meegegeven worden niet tussen () zetten.
# Alles tussen () wordt als 1 parameter meegenomen 
BasisInstelling $DC_adres $prefix_Lengte $Def_Gat $DefCompName $IfIndex

# Gezien er een restart gebeurt, best onderstaand in 1 script voorzien
$HetForest = "TheMatrix.local"
installADDS ($HetForest)
# 
read-host "`n`nHet script sluit nu af (enter)"

# ToDo
# Het zit nog niet goed met die InterfaceIndex. Afhankelijk van het type en moet dus een variable worden.
# Ook bespreken hoe we het doen met de VM zijn netwerkadapters
# keuzemogelijkheid toevoegen: fysieke opstelling of simulatie volledig virtualbox
# eventueel csv met parameters voorzien

