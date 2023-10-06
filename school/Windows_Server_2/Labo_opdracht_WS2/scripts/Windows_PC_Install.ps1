### map aanmaken waar vm komt


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



# Script:
if (! $Env:Path.contains("VirtualBox")) { $Env:PATH += ";C:\Program Files\Oracle\VirtualBox" }

Clear-Host
Write-Host "+++++++++++++++++++++++++++++++"
Write-Host "+ Aanmaak VM DomainController +" 
Write-Host "+++++++++++++++++++++++++++++++`n `n"

# vastleggen paths en filenamen voor aanmaak VM (default via csv file)
$iso="D:\Jonas\iso_files_WS2\en_windows_server_2019_x64.iso"
$vdipath= "C:\Users\Jonas\VirtualBox VMs\WS2"
$gedeeldeMap= "D:\Jonas\JonasF\school\Windows_Server_2\Labo_opdracht_WS2"
$postInstallScript= "D:\Jonas\JonasF\school\Windows_Server_2\Labo_opdracht_WS2\scripts\winServer_postinstall.cmd"
$vmname=""
$vmmemory=""
$vmcpu=""
$vmdisk=""


# controleren van bestanden en mappen

ControleerBestand($iso)
ControleerPad($vdipath)
ControleerPad($gedeeldeMap)
ControleerBestand($postInstallScript)


# ingeven naam VM & Hostname:

$vmname = Read-Host "Geef een naam voor de PC"
    if (($vmname -eq "") -or ($null -ne (vboxmanage list vms | Select-String -pattern "\b$vmname\b"))) {
        Write-Host "De ingegeven naam is te kort, leeg (door ingave enter) of de aan te maken VM bestaat al, gelieve deze eerst te verwijderen of hernoem de nieuwe machine."
        Read-host "Script wordt afgebroken. Toets enter"
        break
        }

[int]$vmmemory = Read-Host "Geef het aantal RAM geheugen voor de machine in tussen 1024 en 6144 MB: "
    while ($vmmemory -lt 1024 -or [int]$vmmemory -gt 6144) {
        Write-Host "De ingegeven waarde is niet correct, geef een andere waarde in."
        $vmmemory = Read-Host "Geef het aantal RAM geheugen voor de machine in tussen 1024 en 6144 MB: "
        }

[int]$vmcpu = Read-Host "Geef het aantal cpu's voor de machine in tussen 1 en 2: "
    while ($vmcpu -lt 1 -or $vmcpu -gt 2) {
        Write-Host "De ingegeven waarde is niet correct, geef een andere waarde in."
        $vmcpu = Read-Host "Geef het aantal RAM geheugen voor de machine in tussen 1 en 2: "
        }

[int]$vmdisk = Read-Host "Geef de gewenste disk space in tussen 25000 en 40000: "
    while ($vmdisk -lt 25000 -or $vmdisk -gt 40000) {
        Write-Host "De ingegeven waarde is niet correct, geef een andere waarde in."
        $vmdisk = Read-Host "Geef het aantal RAM geheugen voor de machine in tussen 25000 en 40000: "
        }

      
# Onderstaand uitcommentarieren voor testen van variabelen en de tijdrovende aanmaak VM te voorkomen
# Read-Host "We gaan hier voorlopig stoppen. Script wordt afgebroken. Toets enter"
# Exit

VBoxManage createvm `
    --name $vmname `
    --ostype "Windows10_64" `
    --register

VBoxManage modifyvm $vmname `
    --memory $vmmemory `
    --vram 128 `
    --cpus $vmcpu `
    --graphicscontroller "VboxSVGA" `
    --ioapic on `
    --boot1 disk `
    --boot2 dvd `
    --boot3 none `
    --boot4 none
Write-Host "CPU, RAM, aantal cores en graphics werden ingesteld."

Vboxmanage modifyvm $vmname `
    --clipboard bidirectional `
    --draganddrop bidirectional 
Write-host "clipboard en drag'n drop zijn bidirectional na installatie guest editions"


VBoxManage natnetwork add --netname WS2 --network "192.168.23.0/24" --enable --dhcp off

VBoxManage modifyvm $vmname `
    --nic1 natnetwork
Write-Host "De netwerkkaart werd als NAT network ingesteld."
        
VBoxManage modifyvm $vmname `
--nat-network1=WS2

$vdi=$global:vdipath + "\" + $vmname + ".vdi"
Write-host "de hd wordt : $vdi"
VBoxManage createmedium disk `
    --filename $vdi `
    --size $vmdisk

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
    --medium $iso `

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
    --password="ChangeMe" `
    --image-index=5 `
    --country="BE" `
    --key="VK7JG-NPHTM-C97JM-9MPGT-3V66T" `
    --time-zone=CET `
    --install-additions `
    --additions-iso="C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso" `
    --locale=nl_BE `
    --post-install-template=$postInstallScript
 

VBoxManage startvm $vmname
