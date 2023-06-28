#commando wordt niet herkend in ISE
# 02/04 @Lara: je hebt gelijk. Kan het zijn doordat je niet in een domain zit?
$test=Get-DhcpServerInDC
# @Lara: Deze idempotente test zou nog beter moeten want indien dhcp geïnstalleerd op ander toestel komt dat toestel waarschijnlijk als een object in $test
# Maar eigenlijk kunnen we er vanuit gaan dat er voor ons geen 2de DHCP runt maar misschien straks wel in backup domain controller
# @Joost: ik zou hier even geen tijd in steken. We kunnen ervan uitgaan dat dit script enkel uitgevoerd wordt bij de initiële installatie van de DC. Anders moeten we ook testen of de scopes al bestaan e.d.
# 02/04 @Lara: Ok, akkoord
if ($test -eq $null) {
    Write-host "Installatie DHCP wordt gestart.`n"
    Install-WindowsFeature -name DHCP -IncludeManagementTools
    # Hier zou ik vragen om te herstarten. Soms gebeurt dit automatisch en soms niet na de installatie DHCP. Is goed praktisch voor installatie Dhcp. Problemen op demo willen we niet.
    # @ Joost: tijdens meeting 21/04 knoop doorhakken.
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

# 02/04 @Lara: In beide opstellingen is dc adres toch 192.168.168.130. En DC is toch steeds DHCP server? Ik zal het voorlopig uit global script laten
# @Joost: ok
[string]$labo = read-host "Gaat het over een live labo-opstelling (ip-adres 192.168.168.130)? (default: Y)"
if ($labo -ieq "y" -or $labo -eq "") {
    $ipadres = "192.168.168.130"
}
else {
    $ipadres = "192.168.168.129"
}

# When you run the following netsh command on the DHCP server, the DHCP Administrators and DHCP Users security groups are created in Local Users and Groups on the DHCP server.
# effect van verbose bekijken indien de boodschappen toegevoegde waarde hebben.
Add-DhcpServerSecurityGroup -Verbose

# Authorize the DHCP server in Active Directory
Add-DhcpServerInDC -DnsName "agentsmith.thematrix.local" -IPAddress $ipadres

# Notify Server Manager that post-install DHCP configuration is complete
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# Server level opties:
Set-DhcpServerv4OptionValue -ComputerName "agentsmith.thematrix.local" -DnsServer $ipadres -DnsDomain "thematrix.local"

# DHCP scopes aanmaken:
# workstations crew: 192.168.168.0/26 	=> 192.168.168.1 - 192.168.168.62 // DG: 192.168.168.1
# workstations cast: 192.168.168.64/26  => 192.168.168.65 - 192.168.168.126 // DG: 192.168.168.65

Add-DhcpServerv4Scope -ComputerName "agentsmith.thematrix.local" -name "Crew" -StartRange 192.168.168.2 -EndRange 192.168.168.62 -SubnetMask 255.255.255.192 -State Active
Set-DhcpServerv4OptionValue -ScopeId 192.168.168.0 -Router 192.168.168.1

Add-DhcpServerv4Scope -ComputerName "agentsmith.thematrix.local" -name "Cast" -StartRange 192.168.168.66 -EndRange 192.168.168.126 -SubnetMask 255.255.255.192 -State Active
Set-DhcpServerv4OptionValue -ScopeId 192.168.168.64 -Router 192.168.168.65

Restart-Service dhcpserver

# Bronnen:
# https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps