# Functies
# Dit script start met een VM waarop windows Server 2019 reeds is geïnstalleerd


function BasisInstelling ($DCadres,$prefixLengte,$DefGat) {
   
    Clear-Host
    #uitzetten windows updates
    write-host "windows updates worden uitgezet"
    sc.exe config wuauserv start=disabled
        # Ik had het gehoopt om zoals hieronder te doen maar lukte niet
        #Set-Service -Name wuauserv -StartupType Manual 
        #Set-Service -Name wuauserv -Status stopped -StartupType Disabled
        #Start-Service -Name "wuauserv"
    write-host "`n`n" 


    # Code Liam
    #Network config (Note, check if index w/ first command)

    Write-host "Wenst u de Netwerk-adapters te wijzigen druk (Y):"
    [string]$antwoord = read-host
    if ($antwoord -eq "y") {
        Get-NetAdapter
        New-NetIPAddress `
            -InterfaceIndex 4 `
            -IPAddress $DCadres `
            -PrefixLength $prefixLengte `
            -DefaultGateway $DefGat
        Set-DnsClientServerAddress `
            -InterfaceIndex 4 `
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
    Write-host "wenst u deze te wijzigen druk (Y):"
    [string]$antwoord = read-host
    if ($antwoord -eq "y") {
        write-host "Welke naam wil je de machine geven?:" 
        [string]$naam = Read-host
        Rename-computer -NewName $naam	
        write-host "De computernaam is nu $env:COMPUTERNAME en wordt na herstart $naam"
        Write-Host "`n`nWenst u De computer te herstarten? (Y): "
        [string]$antwoord = read-host
        if ($antwoord -eq "y") {
            write-host "De computer wordt herstart`nEven (5sec) geduld"
            Start-Sleep 5
            Restart-computer
        }
        else {write-host "Eventuele naamwijziging dient aktief te zijn vooraleer AD DS te installeren!! "}
    }
    else {"De computernaam werd niet gewijzigd en blijft $env:COMPUTERNAME" }
}

#installatie AD DS 

function installADDS ($bos){
#
# Windows PowerShell-functie voor AD DS-implementatie
#
    Write-Host "`n`nWenst u AD DS te installeren? (Y): "
    [string]$antwoord = read-host
    if ($antwoord -eq "y") {
        write-host "AD Domain services wordt geïnstalleerd`nEven geduld" 
        Install-WindowsFeature -Name AD-Domain-services -IncludeManagementTools
    }
    else {write-host "AD DS werd niet geïnstalleerd"}
    
    Write-Host "`n`nWenst u het domein $bos aan te maken (Y): "
    [string]$antwoord = read-host
    if ($antwoord -eq "y") {
        write-host "Het domein $bos wordt aangemaakt`nEven geduld" 
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
}

# Gezien er een restart gebeurd, best onderstaand in 1 script voorzien
$DC_adres="192.168.168.130"
$prefix_Lengte=29
$Def_Gat="192.168.168.129"
# Hier zeer veel tijd verloren. Indien meerdere parameters meegegeven worden niet tussen () zetten.
# Alles tussen () wordt als 1 parameter meegenomen 
BasisInstelling $DC_adres $prefix_Lengte $Def_Gat

# Gezien er een restart gebeurd, best onderstaand in 1 script voorzien
$HetForest = "TheMatrix.local"
installADDS ($HetForest)

#ToDo
# nog wijzigen van sitenaam toevoegen
# het zit nog niet goed met die InterfaceIndex. Afhankelijk van het type en moet dus een variable worden.
# ook bespreken hoe we het doen met de VM zijn netwerkadapters
# opzoeken hoe in core de progress bar kunt weergeven tijdens installatie van AD DS en andere rollen

