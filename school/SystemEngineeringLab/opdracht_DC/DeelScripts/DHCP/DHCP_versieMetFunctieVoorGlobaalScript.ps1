
#commando wordt niet herkend in ISE
# 02/04 @Lara: je hebt gelijk. Kan het zijn doordat je niet in een domain zit? Zal nog eens testen in een domaincomp

function InstallatieDHCP ( $dhcpserveradres, $ServerName, $ServerForest ) {
# dnsnaam wordt agentsmith.thematrix.local
    $dnsNaam=$ServerName+"."+$ServerForest
# compname wordt agentsmith.thematrix.local
    $compNaam=$ServerName+"."+$ServerForest

    $test=Get-DhcpServerInDC
    if ($null -eq $test) {
        Write-host "Installatie DHCP wordt gestart.`n"
        Install-WindowsFeature -name DHCP -IncludeManagementTools
        # Hier zou ik vragen om te herstarten. Soms gebeurt dit automatisch en soms niet na de installatie DHCP. Is goed praktisch voor installatie Dhcp. Problemen op demo willen we niet.
        [string]$antwoord = read-host "`nWenst u De computer te herstarten (dit wordt geadviseerd na installatie DHCP? (ja: Y of enter)"
        if ($antwoord -ieq "y" -or $antwoord -eq "") {
            write-host "De computer wordt herstart`nEven (3 sec) geduld"
            Start-Sleep 3
            Restart-computer
        }
    else {
        write-host "Informatief: DHCP kan kuren hebben indien je geen herstart deed. "
        }
    }
    else {
        write-host "De DHCP rol is reeds geinstalleerd en wordt dus nu niet geinstalleerd "
    }

# When you run the following netsh command on the DHCP server, the DHCP Administrators and DHCP Users security groups are created in Local Users and Groups on the DHCP server.
# effect van verbose bekijken indien de boodschappen toegevoegde waarde hebben.
    Add-DhcpServerSecurityGroup -Verbose
# Authorize the DHCP server in Active Directory
    Add-DhcpServerInDC -DnsName $dnsNaam -IPAddress $DC_adres
# Notify Server Manager that post-install DHCP configuration is complete
#   Alternatief commando:
#   Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name "ConfigurationState" –Value 2
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ServerManager\roles\12" -Name "ConfigurationState" -Value 2
    Restart-Service dhcpserver
# Server level opties:
    Set-DhcpServerv4OptionValue -ComputerName $compNaam -DnsServer $DC_adres -DnsDomain $ServerForest
# DHCP scopes aanmaken:
# workstations crew: 192.168.168.0/26 	=> 192.168.168.1 - 192.168.168.62 // DG: 192.168.168.1
# workstations cast: 192.168.168.64/26  => 192.168.168.65 - 192.168.168.126 // DG: 192.168.168.65

    if ( !(Get-DhcpServerv4Scope -ComputerName $compNaam -ScopeId 192.168.168.0 -ea 0) ) {
        write-host "`nDe dhcp scope crew `(192.168.168.2 tot .62`) wordt aangemaakt`n"
        Add-DhcpServerv4Scope -ComputerName $compNaam -name "Crew" -StartRange 192.168.168.2 -EndRange 192.168.168.62 -SubnetMask 255.255.255.192 -State Active
        Set-DhcpServerv4OptionValue -ScopeId 192.168.168.0 -Router 192.168.168.1
    }
    else {
        write-host "De dhcp scope crew `(192.168.168.2 tot .62`) bestaat reeds en wordt niet aangemaakt"
    }

    if ( !(Get-DhcpServerv4Scope -ComputerName $compNaam -ScopeId 192.168.168.64 -ea 0) ) {
        write-host "De dhcp scope cast `(192.168.168.66 tot .126`) wordt aangemaakt"
        Add-DhcpServerv4Scope -ComputerName $compNaam -name "Cast" -StartRange 192.168.168.66 -EndRange 192.168.168.126 -SubnetMask 255.255.255.192 -State Active
        Set-DhcpServerv4OptionValue -ScopeId 192.168.168.64 -Router 192.168.168.65
    }
    else {
        write-host "De dhcp scope cast `(192.168.168.66 tot .126`) bestaat reeds en wordt niet aangemaakt"
    }
}

Clear-Host
Write-Host "++++++++++++++++++++"
Write-Host "+ Installatie DHCP +" 
Write-Host "++++++++++++++++++++`n `n"

$DC_adres="192.168.168.130"
$DefCompName="AgentSmith"
$HetForest="TheMatrix.local"

InstallatieDHCP $DC_adres $DefCompName $HetForest

# Bronnen:
# https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps