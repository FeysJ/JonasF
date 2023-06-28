Install-WindowsFeature DHCP -IncludeManagementTools

# When you run the following netsh command on the DHCP server, the DHCP Administrators and DHCP Users security groups are created in Local Users and Groups on the DHCP server.
netsh dhcp add securitygroups
Restart-Service dhcpserver

# Authorize the DHCP server in Active Directory
Add-DhcpServerInDC -DnsName agentsmith.thematrix.local -IPAddress 192.168.168.130

# Notify Server Manager that post-install DHCP configuration is complete
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# Server level opties:
Set-DhcpServerv4OptionValue -ComputerName "agentsmith.thematrix.local" -DnsServer 192.168.168.130 -DnsDomain "thematrix.local"

# DHCP scopes aanmaken:
# workstations crew: 192.168.168.0/26 	=> 192.168.168.1 - 192.168.168.62 // DG: 192.168.168.1
# workstations cast: 192.168.168.64/26  => 192.168.168.65 - 192.168.168.126 // DG: 192.168.168.65
Add-DhcpServerv4Scope -name "Crew" -StartRange 192.168.168.2 -EndRange 192.168.168.62 -SubnetMask 255.255.255.192 -State Active
Set-DhcpServerv4OptionValue -ScopeId 192.168.168.0 -Router 192.168.168.1

Add-DhcpServerv4Scope -name "Cast" -StartRange 192.168.168.66 -EndRange 192.168.168.126 -SubnetMask 255.255.255.192 -State Active
Set-DhcpServerv4OptionValue -ScopeId 192.168.168.64 -Router 192.168.168.65

# Bronnen:
# https://learn.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-deploy-wps