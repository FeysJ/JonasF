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

function ControleerNetwerkType($netwerk) {
    if (!(($netwerk -eq "crew") -or $netwerk -eq "cast")) {
            Write-Host "$netwerk is een ongeldig type. Het script wordt afgebroken. Toets enter"
            Exit
        }
    }

# ----------------- #

# Script:
Clear-Host
Write-Host "+++++++++++++++++++++++++++++++++"
Write-Host "+       Aanmaak Domain PC       +" 
Write-Host "+++++++++++++++++++++++++++++++++`n `n"

if (! $Env:Path.contains("VirtualBox")) { $Env:PATH += ";C:\Program Files\Oracle\VirtualBox" }
write-host "In de domeinstructuur zijn default volgende PCs opgenomen: PCCast1, PCCast2, PCCrew1, PCCrew2 en DirectorPC`n"
$vmname = Read-Host "`nNaam van de machine: "
# Controleer of de VM al bestaat:
if (($vmname -eq "") -or ($null -ne (vboxmanage list vms | Select-String -pattern "\b$vmname\b"))) {
    Write-Host "De ingegeven naam is te kort of de aan te maken vm bestaat al, gelieve deze eerst te verwijderen of hernoem de nieuwe machine."
    Read-host "Script wordt afgebroken. Toets enter"
    Exit
}

$iso = Read-Host "`nGeef het absolute pad van het iso-bestand in, zonder aanhalingstekens`n"
ControleerBestand($iso)

$vdipath = Read-Host "Geef het absolute pad van de map waar je vdi-bestand wilt plaatsen. Zonder aanhalingstekens`n"
ControleerPad($vdipath)

$gedeeldeMap = Read-Host "Geef het absolute pad van de map die gedeeld mag worden met de vm. Zonder aanhalingstekens`n"
ControleerPad($gedeeldeMap)

$postInstallScript = Read-Host "Geef het absolute pad van het post-install script in, zonder aanhalingstekens`n"
ControleerBestand($postInstallScript)
write-host "`n"

VBoxManage createvm `
    --name $vmname `
    --ostype "Windows10_64" `
    --register

$keuze = Read-Host "`nWenst u een bridged adapter te gebruiken (ja: druk enter)"
if ($keuze -eq ""){
        $NicAdapt = Get-NetAdapter -name Ethernet
        VBoxManage modifyvm $vmname `
        --nic1 bridged `
        --bridgeadapter1 $NicAdapt.InterfaceDescription
    Write-Host "De netwerkkaart werd als bridged ingesteld.`n"
    }
else {
    $netwerk = Read-Host "Betreft het een Crew of een Cast pc? [crew/cast]"
    ControleerNetwerkType($netwerk)
    $netwerk = $netwerk.ToLower()
    VBoxManage modifyvm $vmname `
        --nic1 intnet `
        --intnet1 $netwerk
    Write-Host "De netwerkkaarten werden ingesteld als intnet.`n"
}

VBoxManage modifyvm $vmname `
    --memory 2048 `
    --vram 128 `
    --graphicscontroller="vboxsvga" `
    --ioapic on `
    --boot1 disk `
    --boot2 dvd `
    --boot3 none `
    --boot4 none `
    --clipboard bidirectional `
    --draganddrop bidirectional
Write-Host "CPU, RAM en graphics werden ingesteld."

$vdi=$vdipath + "\" + $vmname + ".vdi"
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

VBoxManage sharedfolder add $vmname `
    --name "Gedeelde-map" `
    --hostpath $gedeeldeMap `
    --automount
    write-host "sharedfolder `($gedeeldeMap`) is aanwezig na installatie guest editions"

    VBoxManage unattended install $vmname `
    --iso=$iso `
    --hostname=$vmname.thematrix.local `
    --full-user-name="administrator" `
    --user="administrator" `
    --password="VeranderMij%123" `
    --image-index=5 `
    --locale="nl_BE" `
    --country="BE" `
    --key="VK7JG-NPHTM-C97JM-9MPGT-3V66T" `
    --time-zone=CET `
    --install-additions `
    --additions-iso="C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso" `
    --post-install-template=$postInstallScript

VBoxManage startvm $vmname


# Weggelaten:
#     --post-install-command='VBoxControl guestproperty set installation_finished y' `