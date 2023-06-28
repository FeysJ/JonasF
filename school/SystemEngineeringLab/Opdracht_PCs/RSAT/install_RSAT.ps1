# Installeer alle RSAT tools: 
# Get-WindowsCapability -Name RSAT* -Online | Where-Object State -EQ NotPresent | Add-WindowsCapability -Online

# Installeer enkel de nodige RSAT tools:
Add-WindowsCapability -online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
Add-WindowsCapability -online -Name Rsat.Dns.Tools~~~~0.0.1.0
Add-WindowsCapability -Online -Name Rsat.ServerManager.Tools~~~~0.0.1.0
Add-WindowsCapability -Online -Name Rsat.DHCP.Tools~~~~0.0.1.0
Add-WindowsCapability -Online -Name Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0
Add-WindowsCapability -Online -Name Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0

# Bronnen
# Lijst met alle RSAT tools: https://activedirectorypro.com/install-rsat-remote-server-administration-tools-windows-10/#windows10
# https://woshub.com/install-rsat-feature-windows-10-powershell/#h2_1
