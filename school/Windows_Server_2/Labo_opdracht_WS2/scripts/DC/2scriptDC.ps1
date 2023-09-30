# Functies
# Dit script start met een VM waarop windows Server 2019 reeds is geïnstalleerd

function BasisInstelling ($DCadres,$prefixLengte) {
   
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
                #-DefaultGateway $DefGat
            write-host "Het IPadres werd ingesteld op $DCadres / $prefixLengte"
            Set-DnsClientServerAddress `
                -InterfaceIndex $Index `
                -ServerAddresses $DCadres
            write-host "DNS server-adres werd op $DCadres ingesteld"
        }
    }
}

#installatie AD DS 

function installADDS ($domain) {
#
# Windows PowerShell-functie voor AD DS-implementatie
# Windows Server 2016: 7 or WinThreshold


    [string]$antwoord = read-host "`n`nWenst u AD DS te installeren [`"ja`": druk enter]? "
    if ($antwoord -eq "") {
        write-host "AD Domain services wordt geinstalleerd`nEven geduld" 
        Install-WindowsFeature -Name AD-Domain-services -IncludeManagementTools
        [string]$antwoord = read-host "`nHet domein $domain wordt aangemaakt [druk enter] "
        write-host "Het domein $domain wordt aangemaakt`nEven geduld" 
        Import-Module ADDSDeployment
        Install-ADDSForest `
            -CreateDnsDelegation:$false `
            -DomainName $domain `
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
$DC_adres="192.168.23.1"
$prefix_Lengte=24
#$Def_Gat="192.168.168.0"
$Domain = "WS2-2324-jonas.hogent"
#$IfIndex = [int]((Get-NetAdapter).InterfaceIndex | Select-Object -first 1)

# Hier zeer veel tijd verloren. Indien meerdere parameters meegegeven worden niet tussen () zetten.
# Alles tussen () wordt als 1 parameter meegenomen 
BasisInstelling $DC_adres $prefix_Lengte
installADDS ($Domain)
read-host "`n`nHet script sluit nu af (enter)"

# ToDo
# Ook bespreken hoe we het doen met de VM zijn netwerkadapters
# keuzemogelijkheid toevoegen: fysieke opstelling of simulatie volledig virtualbox
# eventueel csv met parameters voorzien. Nu zijn het hard coded variabelen
# dns instelling in functie "basisinstelling" eventueel later doen (in script 3scriptxxxx)

# https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=windowsserver2019-ps
