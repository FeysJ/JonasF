
# autisme hier de -name toegevoegd voor de leesbaarheid :)
# met Get-DhcpServerInDC testen of dhcp geïnstalleerd is? En dan bepalen of een install nog nodig is? Enkel voor global script.

$test=Get-DhcpServerInDC
# Deze idempotente test zou nog beter moeten want indien dhcp geïnstalleerd op ander toestel komt dat toestel waarschijnlijk als een object in $test
# Maar eigenlijk kunnen we er vanuit gaan dat er voor ons geen 2de DHCP runt maar misschien straks wel in backup domain controller 
if ($test -eq $null) {
    Write-host "Installatie DHCP wordt gestart.`n"
    Install-WindowsFeature -name DHCP -IncludeManagementTools
    # Hier zou ik vragen om te herstarten. Soms gebeurt dit automatisch en soms niet na de installatie DHCP. Is goed praktisch voor installatie Dhcp. Problemen op demo willen we niet.
    # vb:
    [string]$antwoord = read-host "`nWenst u De computer te herstarten (dit wordt geadviseerd na installatie DHCP? (Y)"
    if ($antwoord -eq "y") {
                write-host "De computer wordt herstart`nEven (5sec) geduld"
                Start-Sleep 5
                Restart-computer
            else {
                write-host "Informatief: DHCP kan kuren hebben indien je geen herstart deed. "
                }
}

# When you run the following netsh command on the DHCP server, the DHCP Administrators and DHCP Users security groups are created in Local Users and Groups on the DHCP server.
# Dit commando zou ik wijzigen naar powershell cmd-let
# wordt dan onderstaan ipv netsh dhcp add securitygroups :
# effect van verbose bekijken indien de boodschappen toegevoegde waarde hebben.
Add-DhcpServerSecurityGroup -Verbose
# Restart-Service dhcpserver
# Heb deze restart verzet verder in het script. Is dat niet beter?

# Authorize the DHCP server in Active Directory
# Had al staan om voor Ipadres van DC een variabele te creeeren.
# zelfde met domain als variabele maar dat zijn de zaken waarover ik meldde, bang te zien om te verzanden in details. Hardcoded is soms ook duidelijker 
Add-DhcpServerInDC -DnsName agentsmith.thematrix.local -IPAddress 192.168.168.130

# Notify Server Manager that post-install DHCP configuration is complete
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# Server level opties:
# moeten we hier niet de -router en -scopeid optie ook toevoegen? Of doe je hiermee eerst globaal computername, dnsserver en dnsdomain en later de bij de scope horende scopeid en router?
# moeten we dan ook niet dnsname toevoegen? -dnsname "agentsmith.thematrix.local" ?
Set-DhcpServerv4OptionValue -ComputerName "agentsmith.thematrix.local" -DnsServer 192.168.168.130 -DnsDomain "thematrix.local"

# DHCP scopes aanmaken:
# workstations crew: 192.168.168.0/26 	=> 192.168.168.1 - 192.168.168.62 // DG: 192.168.168.1
# workstations cast: 192.168.168.64/26  => 192.168.168.65 - 192.168.168.126 // DG: 192.168.168.65

# Ook hier hardcoded maar denk dat variabelen niet duidelijker zijn en deze scope wordt nergens anders gebruikt.
# Moet ook hier niet -computername "agentsmith.thematrix.local"?:
# internet: "-computername: Specifies the DNS name, or IPv4 or IPv6 address, of the target computer that runs the DHCP server service."
Add-DhcpServerv4Scope -name "Crew" -StartRange 192.168.168.2 -EndRange 192.168.168.62 -SubnetMask 255.255.255.192 -State Active

Set-DhcpServerv4OptionValue -ScopeId 192.168.168.0 -Router 192.168.168.1

# Moet ook hier niet -computername "agentsmith.thematrix.local"
# internet: "-computername: Specifies the DNS name, or IPv4 or IPv6 address, of the target computer that runs the DHCP server service."
Add-DhcpServerv4Scope -name "Cast" -StartRange 192.168.168.66 -EndRange 192.168.168.126 -SubnetMask 255.255.255.192 -State Active

Set-DhcpServerv4OptionValue -ScopeId 192.168.168.64 -Router 192.168.168.65

# deze restart zou ik dus op laatst doen maar merkte op internet dat dit mogelijks niet zo is en al kan na aanpassen register. 
Restart-Service dhcpserver

# Bronnen:
# https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps