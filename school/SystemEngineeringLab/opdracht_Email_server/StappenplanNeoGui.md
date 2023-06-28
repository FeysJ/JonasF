# Stappenplan Neo

Stappenplan installatie 

ip adres, dns en gateway correct instellen
naam PC correct zetten: neo
Toevoegen aan doamin TheMatrix.local
 
## installeren componenten
`Install-WindowsFeature Server-Media-Foundation, RSAT-ADDS`

`Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility,IIS-Metabase -All`

Site correct zetten: SiteTi02
``` 
$Site = Get-ADReplicationSite
$Sitenaam= $Site.name
`Get-ADReplicationSite $Sitenaam | Rename-ADObject -NewName SiteTi02`
```

## manueel installeren verschillende tools
> .Net 4.8
> Visual C++ (vcredist_x64)

>Mount de iso van exchange via VirtualBox


D:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareSchema 
D:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareAD /OrganizationName:"TheMatrix"
D:\Setup.exe /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /PrepareAllDomains
D:\Setup.exe /m:install /roles:m /IAcceptExchangeServerLicenseTerms_DiagnosticDataOFF /InstallWindowsComponents

installatie duurt vrij lang

## instellen mailserver

Na installatie, surf naar https://localhost/ecp, nu kom je op Exchange admin center terecht
inloggen met `administrator@thematrix.local`


Op exchange server, open cmd als administrator en geef commando `LaunchEMS`in, hiermee kom je op de Exchange Management shell

> `Get-MailboxDatabase` => toon database
> `Get-Mailbox` => toon de huidige accounts
> `Get-User -OrganizationalUnit "OU=DomainUsers,DC=TheMatrix,DC=local"` => toon de users in ons domain
> `Get-User -OrganizationalUnit "OU=DomainUsers,DC=TheMatrix,DC=local" | Enable-Mailbox -Database "Mailbox Database 0738242744"` => mailbox aanmaken voor iedere gebruiker