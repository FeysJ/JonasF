# Voorzie ook een sharedfolder voor zowel de cast als de crew 
# creëer groepen om de toegang tot die shared folders te regelen.

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
function MaakSharedFolder ($grp){

    $shareNaam=("Share{0}" -f $grp.name)
    Write-host "$Sharenaam"
    if ( !(Get-SmbShare -name $shareNaam -ea 0) ){
        $pad=("C:\Shares\{0}" -f $groep.name)
        $shareNaam=("Share{0}" -f $groep.name)
        $FA=("Thematrix\{0}" -f $groep.name)
        $desc="Share voor de leden van groep"+$groep.name
        MaakPathVoorShare $Pad
        Write-host ("`t$Sharenaam `twordt als Shared folder aangemaakt voor {0}"-f $groep.name)
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

# info cmdlet:
<# 
-FolderEnumerationMode AccessBased. 
SMB doesn't display the files and folders for a share to a user unless that user has rights to access the files and folders. 
By default, access-based enumeration is disabled for new SMB shares.
#>

<#
New-SmbShare -Name "ShareCast" `
    -Path "C:\shares\cast" `
    -FullAccess 'thematrix\GRP_Cast' `
    -FolderEnumerationMode AccessBased `
    -Description "Share voor de crew-leden" 

New-SmbShare -Name "ShareCrew" `
    -Path "C:\shares\crew" `
    -FullAccess "thematrix\GRP_Crew" `
    -FolderEnumerationMode AccessBased `
    -Description "Share voor de cast-leden" 
#>
Clear-Host
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
Write-Host "+ Aanmaak Shared folders voor groepen cast, crew,...                 +"                     
Write-host "+ (Groepen corresponderend met een sub-OU van de OU `"Domeinusers`")   +" 
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++`n `n"
$csv = "Z:\project\csv\Groups.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. `nWenst u deze te wijzigen (Y/N)"
if ($antwoord -ieq "y") { # expliciete case insensitive equal
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}
ControleerCSV($csv)
$Groupfile = Import-Csv $csv -Delimiter ";"
Write-Host "`n"
foreach ($groep in $Groupfile) {   #hier staat nog hardcoded ou=domainUsers als waar je subOUs van zoekt 
    if ($groep.Path.toUpper() -cnotlike 'OU=*,OU=*,OU=DomainUsers,DC=TheMatrix,DC=local'.ToUpper() `
        -and $groep.Path.ToUpper() -clike 'OU=*,OU=DomainUsers,DC=TheMatrix,DC=local'.ToUpper() ) {
            MaakSharedFolder ($groep)   
            #read-host "Enter a.u.b"
        }
#Write-Host "einde foreEach"
}
read-host "`n`nHet script sluit nu af (enter)"
<# 
Todo: 
- Er staat nog hard-coded 'OU=*,OU=*,OU=DomainUsers,DC=TheMatrix,DC=local'
Eventueel script variabele voor 
- TheMatrix.local 
- OU domainUsers
#>


