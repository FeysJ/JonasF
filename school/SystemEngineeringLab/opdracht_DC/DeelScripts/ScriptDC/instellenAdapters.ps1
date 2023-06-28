<#
Dit is een tijdelijk script om de netwerkadpaters van de DC in te stellen
Dient geïntegreerd te worden in het globale en in het ScriptDC
Uitgegaan wordt van
igv simulatieOpstelling
- netwerkadapter1 : NAT 
- netwerkadapter2 : servers internal netw
- netwerkadpater3 : cast internal netw
- netwerkadapter4 : crew internal netw
#>


# OPMERKINGEN:
# versie met allemaal fixed ipadressen en niet via Dhcp
# script is niet idempotent en er verschijnen nu nog errors indien een 2de maal uitgevoerd
# adapters aanmaken via Vboxmanage?

$lijst=Get-NetAdapter

foreach ($adapter in $lijst) {
    Write-Host $adapter.name "`t" $adapter.ifindex
    $index=$adapter.ifIndex
    $Adapteradres="0.0.0.0"
    $Adapterprefix=0
    Switch ($adapter.name) {
        "Ethernet" { 
            write-host "Nat-adapter wordt niet aangepast, de index van de adapter is: "$adapter.ifindex
            }
        "Ethernet 2" { 
            write-host "De index van servers-adapter is:`t "$adapter.ifIndex

            $Adapteradres="192.168.168.129"
            $Adapterprefix=28        }
        "Ethernet 3" { 
            write-host "De index van crew-adapter is:`t "$adapter.ifIndex
            $Adapteradres="192.168.168.1"
            $Adapterprefix=26
        }
        "Ethernet 4" { 
            write-host "De index van cast-adapter is:`t "$adapter.ifIndex
            $Adapteradres="192.168.168.65"
            $Adapterprefix=26
        }
    }
    if ($adapter.name -ne "Ethernet") {
    New-NetIPAddress `
        -InterfaceIndex $Index `
        -IPAddress $Adapteradres `
        -PrefixLength $Adapterprefix `ip
    }
}
ipconfig
