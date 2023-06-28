# Functies
# Dit script start met een VM waarop windows Server 2019 reeds is geïnstalleerd

function BasisInstelling ($DCadres,$prefixLengte,$DefGat,$DefaultCompName) {
   
    Clear-Host
    #uitzetten windows updates
    write-host "Windows updates worden uitgezet"
    sc.exe config wuauserv start=disabled
        # Ik had het gehoopt om zoals hieronder te doen maar lukte niet
        #Set-Service -Name wuauserv -StartupType Manual 
        #Set-Service -Name wuauserv -Status stopped -StartupType Disabled
        #Start-Service -Name "wuauserv"
    write-host "`n`n" 

    $lijst=Get-NetAdapter
    foreach ($adapter in $lijst) {
        Write-Host $adapter.name "`t" $adapter.ifindex
        $index=$adapter.ifIndex
        if ($adapter.name -eq "Ethernet") {
            New-NetIPAddress `
                -InterfaceIndex $Index `
                -IPAddress $DCadres `
                -PrefixLength $prefixLengte `
                -DefaultGateway $DefGat
            write-host "Het IPadres werd ingesteld op $DCadres / $prefixLengte met default gateway $DefGat"
            Set-DnsClientServerAddress `
                -InterfaceIndex $Index `
                -ServerAddresses $DCadres
            write-host "DNS server-adres werd op $DCadres ingesteld"
        }
    }

#Wijzigen Computernaam
    write-host "`n`nHuidige computernaam is: $env:COMPUTERNAME"
    [string]$antwoord = read-host "wenst u deze te wijzigen druk (`"Nee`": druk enter)?"
    if ($antwoord -ne "") {	
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
        [string]$antwoord = read-host "`nHet domein $bos wordt aangemaakt [druk enter] "
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
            write-host "AD DS services en domein $bos werden niet aangemaakt`n" 
        }
    <#    
    else {
        if ( !(Get-ADForest -Identity $bos -ea 0) ){
            write-host "Het domein $bos werd niet aangemaakt en is aanwezig"
        }
        if (Get-ADForest -Identity $bos -ea 0)  {
            write-host "Het domein $bos werd niet aangemaakt en is nog niet aanwezig! Run script nogmaals om dit recht te zetten"
        }
    }
    #>
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
$HetForest = "TheMatrix.local"
#$IfIndex = [int]((Get-NetAdapter).InterfaceIndex | Select-Object -first 1)

# Hier zeer veel tijd verloren. Indien meerdere parameters meegegeven worden niet tussen () zetten.
# Alles tussen () wordt als 1 parameter meegenomen 
BasisInstelling $DC_adres $prefix_Lengte $Def_Gat $DefCompName
installADDS ($HetForest)
read-host "`n`nHet script sluit nu af (enter)"

# ToDo
# Ook bespreken hoe we het doen met de VM zijn netwerkadapters
# keuzemogelijkheid toevoegen: fysieke opstelling of simulatie volledig virtualbox
# eventueel csv met parameters voorzien. Nu zijn het hard coded variabelen
# dns instelling in functie "basisinstelling" eventueel later doen (in script 3scriptxxxx)

