### Functies:

function ControleerCSV($bestand) {
    if (!(Test-Path $bestand -PathType leaf)) {
        Read-Host "$bestand niet gevonden. Script wordt afgebroken. Toets enter"
        exit
    } 
}
function MaakPathVoorShare($Pad) {
    if ((Test-Path $Pad)) {
        Read-Host "`t$Pad is reeds aanwezig en directory wordt dus niet aangemaakt voor de share. `n`tToets enter"
    }
    else {
        write-host "`t$pad wordt aangemaakt als directory voor de shared folder"
        New-Item "$pad" -ItemType Directory > $null
    } 
}

function MaakSharedFolderUser ($gebruiker){

    $shareNaam=("Share{0}{1}" -f $gebruiker.voornaam, $gebruiker.familienaam )
    Write-host "$Sharenaam"
    if ( !(Get-SmbShare -name $shareNaam -ea 0) ){
        $pad=("C:\Shares\Gebruikers\{0}{1}" -f $gebruiker.voornaam, $gebruiker.familienaam)
        $shareNaam=("Share{0}{1}" -f $gebruiker.voornaam, $gebruiker.familienaam)
        $FA=("Thematrix\{0}" -f $gebruiker.SamAccountName)
        $desc="Share voor gebruiker"+$gebruiker.voornaam+$gebruiker.familienaam
        MaakPathVoorShare $Pad
        Write-host ("`t$Sharenaam `twordt als Shared folder aangemaakt voor {0} {1}"-f $gebruiker.voornaam, $gebruiker.familienaam)
        New-SmbShare -Name $shareNaam `
        -Path $pad `
        -FullAccess $FA `
        -FolderEnumerationMode AccessBased `
        -Description $desc > $null
    }
    else {
        Write-host "`t$Sharenaam `tbestaat reeds als Shared folder en werd niet aangemaakt"
        #Write-Host "`n`n"
    }
    Write-Host "`n"
}
Function MaakGebruikerAan($Gebruiker) {
    $SamAccountName = $Gebruiker.SamAccountName
    $OU = $Gebruiker.OU
    $wachtwoord = $Gebruiker.wachtwoord
    $voornaam = $Gebruiker.voornaam
    $familienaam = $Gebruiker.familienaam

    # Controleer of de gebruiker al bestaat
    if (Get-ADUser -F {SamAccountName -eq $SamAccountName})
    {
        Write-Warning "De gebruiker $voornaam $familienaam bestaat al"
        MaakSharedFolderUser $gebruiker
    }
    else
    {
        New-ADUser `
            -SamAccountName $Gebruiker.SamAccountName `
            -Path $OU `
            -UserPrincipalName "$SamAccountName@TheMatrix.local" `
            -Enabled $True `
            -DisplayName "$familienaam, $voornaam" `
            -Name "$voornaam $familienaam" `
            -GivenName $voornaam `
            -Surname $familienaam `
            -AccountPassword (convertto-securestring $wachtwoord -AsPlainText -Force)
            Write-Host "De gebruiker $voornaam $familienaam werd aangemaakt"
        MaakSharedFolderUser $gebruiker
       }
}

Function MaakComputerAan($Computer) {
    
    $SamAccountName = $Computer.SamAccountName
    $OU = $Computer.OU
    $Identity = "CN=$SamAccountName,$OU"

    # Als het juiste computerobject al bestaat, sla deze dan over
    if (Get-ADComputer -F {DistinguishedName -eq $Identity})
    {
        Write-Warning "De computer $SamAccountName bestaat al"
    }
    else
    {
        try {    
            New-ADComputer `
            -Name $SamAccountName `
            -Path $OU `
            -Enabled $True
            Write-Host "De computer $SamAccountName werd aangemaakt"
        } catch {
            Write-Warning "$SamAccountName bevindt zich op de verkeerde locatie. Deze wordt verplaatst naar de juiste OU."
            $te_verhuizen_computer = Get-ADComputer -Filter { Name -eq $SamAccountName }
            Move-ADObject -Identity $te_verhuizen_computer.DistinguishedName -TargetPath "$OU"
        }
    }
}

### Script:

#$csv = "C:\Users\Administrator\Desktop\users_en_computers.csv"
$csv = "Z:\project\csv\users_en_computers.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. Wenst u deze te wijzigen (Nee: druk enter)"
if ($antwoord -ne "") { # expliciete case insensitive equal
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}
ControleerCSV($csv)

$Objecten = Import-csv $csv -Delimiter ";"

foreach ($Object in $Objecten)
{
    if ($Object.type -eq "user")
    {
        MaakGebruikerAan($Object)
    }
    elseif ($Object.type -eq "computer")
    {
        MaakComputerAan($Object)
    }
    else {
        Write-Error "Onbekend type in csv"
    }
}

# Geraadpleegde bronnen:
# https://blog.netwrix.com/2018/06/07/how-to-create-new-active-directory-users-with-powershell/
# https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-adcomputer?view=windowsserver2022-ps
# https://adamtheautomator.com/add-computer-to-domain/
# https://blog.netwrix.com/2018/07/10/how-to-create-delete-rename-disable-and-join-computers-in-ad-using-powershell/