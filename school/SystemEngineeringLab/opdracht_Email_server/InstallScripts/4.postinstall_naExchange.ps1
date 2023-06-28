# Dit script is voor de post install van exchange. Hier wordt de spamfilter en malware scanner geactiveerd en de url's worden ingesteld.

function ImportAccounts($data) {
    Get-User -OrganizationalUnit "OU=DomainUsers,DC=TheMatrix,DC=local" | Enable-Mailbox -Database "$data"

    Write-Host "Accounts are synced and mailbox is prepared."
}


function spam($Ip_adres) {
    & $env:ExchangeInstallPath\Scripts\Install-AntiSpamAgents.ps1
    Restart-Service MSExchangeTransport
    Write-Host "Spam filter is enabled"

    Set-TransportConfig -InternalSMTPServers @{Add=$Ip_adres}

    Set-SenderFilterConfig -BlankSenderBlockingEnabled $true    # filter "lege" afzenders
    Set-SenderFilterConfig -BlockedSenders hallo@hogent.be,test@hogent.be -BlockedDomains hln.be

    Set-ContentFilterConfig -InternalMailEnabled $true
    Add-ContentFilterPhrase -Influence BadWord -Phrase "dit is een test"
    Set-ContentFilterConfig -RejectionResponse "Gelieve je collega's niet te spammen"

   
     
}

function malware() {
    #Malware filter staat automatisch aan, de updates via script wil hij niet doen, ook al is NAT enabled
    #& $env:ExchangeInstallPath\Scripts\Enable-AntimalwareScanning.ps1
    #Restart-Service MSExchangeTransport
    Set-MalwareFilteringServer -Identity neo -ForceRescan $true  # ook scannen nadat het al gescanned is door Exchange Online Protection (Exchange 365)
    Set-MalwareFilterPolicy -Identity "Default" -Action DeleteAttachmentAndUseDefaultAlert -EnableInternalSenderNotifications $true
}



function url ($subdomain,$domain,$servername) {
    Get-ClientAccessServer -Identity $servername | Set-ClientAccessServer -AutoDiscoverServiceInternalUri "https://autodiscover.$domain/Autodiscover/Autodiscover.xml"
    Get-EcpVirtualDirectory -Server $servername | Set-EcpVirtualDirectory -ExternalUrl "https://$subdomain.$domain/ecp" -InternalUrl "https://$subdomain.$domain/ecp"
    Get-WebServicesVirtualDirectory -Server $servername | Set-WebServicesVirtualDirectory -ExternalUrl "https://$subdomain.$domain/EWS/Exchange.asmx" -InternalUrl "https://$subdomain.$domain/EWS/Exchange.asmx"
    Get-MapiVirtualDirectory -Server $servername | Set-MapiVirtualDirectory -ExternalUrl "https://$subdomain.$domain/mapi" -InternalUrl "https://$subdomain.$domain/mapi"
    Get-ActiveSyncVirtualDirectory -Server $servername | Set-ActiveSyncVirtualDirectory -ExternalUrl "https://$subdomain.$domain/Microsoft-Server-ActiveSync" -InternalUrl "https://$subdomain.$domain/Microsoft-Server-ActiveSync"
    Get-OabVirtualDirectory -Server $servername | Set-OabVirtualDirectory -ExternalUrl "https://$subdomain.$domain/OAB" -InternalUrl "https://$subdomain.$domain/OAB"
    Get-OwaVirtualDirectory -Server $servername | Set-OwaVirtualDirectory -ExternalUrl "https://$subdomain.$domain/owa" -InternalUrl "https://$subdomain.$domain/owa"
    Get-PowerShellVirtualDirectory -Server $servername | Set-PowerShellVirtualDirectory -ExternalUrl "https://$subdomain.$domain/powershell" -InternalUrl "https://$subdomain.$domain/powershell"
    Get-OutlookAnywhere -Server $servername | Set-OutlookAnywhere -ExternalHostname "$subdomain.$domain" -InternalHostname "$subdomain.$domain" -ExternalClientsRequireSsl $true -InternalClientsRequireSsl $true -DefaultAuthenticationMethod NTLM
    
}

function dnsRecords() {
    Add-Content C:\\Windows\System32\drivers\etc\hosts "192.168.168.132`tneo.thematrix.local"
    Add-Content C:\\Windows\System32\drivers\etc\hosts "192.168.168.130`tagentsmith.thematrix.local"
    # op DC: `Add-ADGroupMember -Identity "CN=Exchange Servers,OU=Microsoft Exchange Security Groups,DC=TheMatrix,DC=local" -Members Administrator`
    C:\\Windows\System32\iisreset.exe
    

}
    


# Main Script
# ------------

# variabelen

$prefix_Lengte=28
$Def_Gat="192.168.168.130"
$DefCompName = "neo"
$IfIndex = [int]((Get-NetAdapter).InterfaceIndex | Select-Object -first 1)

$Ip_adres="192.168.168.132" #enter ip adres server
$subdomain = "mail" #enter subdomain
$domain = $env:USERDNSDOMAIN.ToLower()
$servername = hostname
$database = (Get-MailboxDatabase).Name

ImportAccounts $database
spam $Ip_adres
url $subdomain $domain $servername
dnsRecords
#malware  ## wordt niet uitgevoerd, kan update niet doen? verder te onderzoeken
