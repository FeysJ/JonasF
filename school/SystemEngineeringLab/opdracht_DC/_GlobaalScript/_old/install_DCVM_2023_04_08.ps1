# Functies:

function ControleerBestand($bestand) {
    if (!(Test-Path $bestand -PathType leaf)) {
        Read-Host "$bestand is een ongeldig bestand. Script wordt afgebroken. Toets enter"
        Exit
    } 
}
function ControleerPad($pad) {
    if (!(Test-Path $pad)) {
        Read-Host "$pad is een ongeldig pad. Script wordt afgebroken. Toets enter"
        Exit
    } 
}
function ControleerCSV($bestand) {
    if (!(Test-Path $bestand -PathType leaf)) {
        Read-Host "$bestand niet gevonden. Script wordt afgebroken. Toets enter"
        exit
    } 
}

function BepaalAbsolutePaden {
    $keuze = Read-Host "Wenst u de paden manueel in te geven (Nee: druk enter)"
    if ($keuze -eq ""){
        $csv = ".\paths.csv"
        $antwoord = Read-Host "Default locatie voor de csv-bestand met de paden: $csv. `nWenst u deze te wijzigen (Nee: druk enter)"
        if ($antwoord -ne "") { 
            $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
        }
        ControleerCSV($csv)
        $Padfile = Import-Csv $csv -Delimiter ";"
        foreach ($PadReeks in $Padfile) {
            $global:iso=$PadReeks.iso
            Write-host ("`nHet absolute pad van het iso-bestand `(nl_windows_server_2019_x64_dvd_82f9a152.iso`) wordt: $global:iso")
            ControleerBestand($global:iso)
            $global:vdipath=$PadReeks.vdi
            Write-host ("Het absolute pad voor het vdi-bestand wordt: $global:vdipath")
            ControleerPad($global:vdipath)
            $global:gedeeldeMap=$PadReeks.share
            Write-host ("Het absolute pad van de gedeelde map wordt: $global:gedeeldeMap")
            ControleerPad($global:gedeeldeMap)
            $global:postInstallScript=$PadReeks.postinstallscript
            Write-host ("Het absolute pad van de gedeelde map wordt: $global:postInstallScript`n")
            ControleerBestand($global:postInstallScript)
        }
    }
    else {
        $global:iso = Read-Host "Geef het absolute pad van het iso-bestand `(nl_windows_server_2019_x64_dvd_82f9a152.iso`) in, zonder aanhalingstekens"
        ControleerBestand($global:iso)
        $global:vdipath = Read-Host "Geef het absolute pad van de map waar je vdi-bestand wilt plaatsen. Zonder aanhalingstekens"
        ControleerPad($global:vdipath)
        $global:gedeeldeMap = Read-Host "Geef het absolute pad van de map die gedeeld mag worden met de vm. Zonder aanhalingstekens"
        ControleerPad($global:gedeeldeMap)
        $global:postInstallScript = Read-Host "Geef het absolute pad van het post-install script in, zonder aanhalingstekens"
        ControleerBestand($global:postInstallScript)
    }
}

# Script:
if (! $Env:Path.contains("VirtualBox")) { $Env:PATH += ";C:\Program Files\Oracle\VirtualBox" }

Clear-Host
Write-Host "+++++++++++++++++++++++++++++++"
Write-Host "+ Aanmaak VM DomainController +" 
Write-Host "+++++++++++++++++++++++++++++++`n `n"

# vastleggen paths en filenamen voor aanmaak VM (default via csv file)
$iso="onbepaald"
$vdipath="onbepaald"
$gedeeldeMap="onbepaald"
$postInstallScript="onbepaald"
BepaalAbsolutePaden
$vmname="AgentSmith"

#write-host "$global:iso $global:vdipath $global:gedeeldeMap $global:postInstallScript"

# Controleer of de VM al bestaat:

# dit stond er eerst if ($null -ne (vboxmanage list vms | Select-String $vmname)) { 
# maar dan ook een script-stop indien AgentSmith een onderdeel is van de naam van een bestaande vm)

[string]$antwoord = Read-Host "Default namen voor de VM en zijn hostname zijn: $vmname. `nWenst u deze te wijzigen (Nee: druk enter)"
        if ($antwoord -ne "") { 
            $vmname = Read-Host "Geef naam voor de DC-machine (Kies bij voorkeur AgentSmith)"
            if (($vmname -eq "") -or ($null -ne (vboxmanage list vms | Select-String -pattern "\b$vmname\b"))) {
                Write-Host "De ingegeven naam is te kort, leeg (door ingave enter) of de aan te maken vm bestaat al, gelieve deze eerst te verwijderen of hernoem de nieuwe machine."
                Read-host "Script wordt afgebroken. Toets enter"
                break
            }
        }
# $vmname = Read-Host "Geef naam voor de DC-machine (Kies bij voorkeur AgentSmith)"

# Read-Host "We gaan hier voorlopig stoppen. Script wordt afgebroken. Toets enter"
# Exit

VBoxManage createvm `?
    --name $vmname `
    --ostype "Windows2019_64" `
    --register

VBoxManage modifyvm $vmname `
    --memory 2048 `
    --vram 128 `
    --graphicscontroller "VboxSVGA" `
    --ioapic on `
    --boot1 disk `
    --boot2 dvd `
    --boot3 none `
    --boot4 none
Write-Host "CPU, RAM en graphics werden ingesteld."

Vboxmanage modifyvm $vmname `
    --clipboard bidirectional `
    --draganddrop bidirectional 
Write-host "clipboard en drag'n drop zijn bidirectional na installatie guest editions"

VBoxManage modifyvm $vmname `
    --nic1 intnet `
    --intnet1 "servers"
Write-Host "De netwerkkaarten werden ingesteld."

$vdi=$global:vdipath + "\" + $vmname + ".vdi"
Write-host "de hd wordt : $vdi"
VBoxManage createmedium disk `
    --filename $vdi `
    --size 50000

VBoxManage storagectl $vmname `
    --name "SATA Controller" `
    --add "sata" `
    --portcount 2 `
    --bootable on
Write-Host "De storagecontroller werd aangemaakt"

vboxmanage storageattach $vmname `
    --storagectl "SATA Controller" `
    --port 0 `
    --device 0 `
    --type "hdd" `
    --medium $vdi
Write-Host "De vdi werd toegevoegd aan de storagecontroller."

vboxmanage storageattach $vmname `
    --storagectl "SATA Controller" `
    --port 1 `
    --device 0 `
    --type "dvddrive" `
    --medium $global:iso `

VBoxManage sharedfolder add $vmname `
    --name "Gedeelde-map" `
    --hostpath $global:gedeeldeMap `
    --automount
write-host "sharedfolder `($gedeeldeMap`) is aanwezig na installatie guest edidtions"

# in andere scripts stond er --hostname=$vmname.thematrix.local

VBoxManage unattended install $vmname `
    --iso=$global:iso `
    --hostname=$vmname.thematrix.local `
    --full-user-name="administrator" `
    --user="administrator" `
    --password="VeranderMij%123" `
    --image-index=1 `
    --country="BE" `
    --time-zone=CET `
    --install-additions `
    --additions-iso="C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso" `
    --locale=nl_BE `
    --post-install-template=$global:postInstallScript
    #--key="VK7JG-NPHTM-C97JM-9MPGT-3V66T" `

VBoxManage startvm $vmname


# Weggelaten:
#     --locale=nl_BE ` # gebeurt via post install
#     --post-install-command='VBoxControl guestproperty set installation_finished y' `