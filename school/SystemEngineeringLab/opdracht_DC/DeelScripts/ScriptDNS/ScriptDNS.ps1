function ControleerCSV($bestand) {
    if (!(Test-Path $bestand -PathType leaf)) {
        Read-Host "$bestand niet gevonden. Script wordt afgebroken. Toets enter"
        exit
    } 
}
function InstellingenDNS($NetworkId,$NetworkIdv6, $csv, $dnsFWName,$dnsFWAddr){

    #Reverse lookup zone
   try{
    Add-DnsServerPrimaryZone -ComputerName agentsmith -NetworkID $NetworkId -ReplicationScope Forest
    Add-DnsServerPrimaryZone -ComputerName agentsmith -NetworkID $NetworkIdv6 -ReplicationScope Forest
   }catch {
    Write-Warning "De DNS zones werden al aangemaakt! `n"
   }
    #Forwarder
    try{
        Add-DnsServerForwarder -IPAddress IPAddress.Parse($dnsFWAddr) -PassThru
    }catch{
        Write-Warning "De standaard forwarder werd al aangemaakt!"
    }
    Write-host "Wenst u een extra forwarder toe te voegen druk (Y):"
    [string]$antwoord = read-host
    while ($antwoord -eq "y") {
        try {

            Write-host "IP addresses: "
            [string]$serverAddress = read-host
            Add-DnsServerForwarder -IPAddress IPAddress.Parse($serverAddress) -PassThru
        }catch {
            Write-Warning "Er is iets foutgelopen, verifiëer uw input en kijk of de forwarder al bestaat! `n"
            Get-DnsServerZone
        }
        Write-host "Wenst u een extra forwarder toe te voegen druk (Y):"
        [string]$antwoord = read-host
    }
    else {
        write-host "Forwarders: `n`n" 
        Get-DnsServerZone
    }
    
    #Check if file exists
    Write-Host "Importing DNS records `n"
    Write-Warning "Existing records will cause errors as we cannot create duplicates! `n"
    foreach($line in $csv){
        if($line.Name -eq "(same as parent folder)"){$line.Name = $line.ZoneName}
        Switch($line.Type)
        {   try{
                "Host (A)"{
                    Add-DnsServerResourceRecordA -Name $line.Name -ZoneName $line.ZoneName -IPV4Address $line.Data
                }
                "IPv6 Host (AAA)"{
                    Add-DnsServerResourceRecordAAA -Name $line.Name -ZoneName $line.ZoneName -IPV6Address $line.Data
                }
                "Pointer (PTR)"{
                    Add-DnsServerResourceRecordPTR -Name $line.Name -PtrDomainName $line.Data -ZoneName $line.ZoneName -ComputerName $line.Computer
                 }
                "Alias (CNAME)"{
                    Add-DnsServerResourceRecordCName -ZoneName $line.ZoneName -HostNameAlias $line.Data -Name $line.Name
                }
                "Name Server (NS)"{
                    #Not needed currently
                }
                "Mail Exchanger (MX)"{
                    Add-DnsServerResourceRecordMX -Preference 10 -ZoneName $line.ZoneName -Name $line.Name -MailExchange $line.data
                }
        }catch {
                Write-Warning "This record has already been created! `n"
        }
        }
            Write-Host "Finished importing! `n"
    }
}


## Ik denk volgend om DHCP op DNS te koppelen
<#
$Credential = Get-Credential
Set-DhcpServerDnsCredential -Credential $Credential -ComputerName "TheMatrix.local"
Set-DhcpServerv4DnsSetting -ComputerName "AgentSmith.TheMatrix.local" -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True
#>


#variable
#When added to DC replace variable below, we already have an IP and prefix variable set there
$NetworkId = "192.168.168.128/28"
$NetworkIdv6 ="2001:db8:a::/64"
#Import Script DNS records, name would have to be changed upon merging the DC scripts
$csvPATH = "C:\\Users\administrator\Desktop/dns.csv"
#Default DNS forwarder
$dnsFWName = "Belgacom"
$dnsFWAddr = "109.132.235.131"
ControleerCSV $csvPATH
$csv = Import-CSV $csvPATH -Delimiter ";"
InstellingenDNS $NetworkId $NetworkIdv6 $csv $dnsFWName $dnsFWAddr