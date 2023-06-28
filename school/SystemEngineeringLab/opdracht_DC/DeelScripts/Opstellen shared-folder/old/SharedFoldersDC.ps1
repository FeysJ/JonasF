# Voorzie ook een sharedfolder voor zowel de cast als de crew 
# creëer groepen om de toegang tot die shared folders te regelen.

# aanmaak van de locaties op DC kan zo 
# mkdir "c:\Shares"
# mkdir "c:\Shares\Cast"
# mkdir "c:\Shares\Crew"

# misschien beter:
function MaakPathVoorShare($Pad) {
    if ((Test-Path $Pad)) {
        Read-Host "Het $Pad is reeds aanwezig en wordt dus niet aangemaakt voor de share. Toets enter"
    }
    else {
        New-Item "$pad" -ItemType Directory
    } 
}


MaakPathVoorShare "c:\Shares\Cast"
MaakPathVoorShare "c:\Shares\Crew" 
# nog checken of hij niet al bestaat
# Test-Path -Path "c:\Shares\Crew"


# OUs werden aangemaakt in:
# C:\Joost files\Bachelor ICT\system engineering project\SEP-2223-sep-2223-t02\opdracht_DC\ScriptOU

# users aangemaakt in: 
# C:\Joost files\Bachelor ICT\system engineering project\SEP-2223-sep-2223-t02\opdracht_DC\Import-csv

# aanmaak groepen zijn aangemaakt in:
# C:\Joost files\Bachelor ICT\system engineering project\SEP-2223-sep-2223-t02\opdracht_DC\GPO 

# member toevoegen aan groep bespreken met team TI02
# New-ADUser –SamAccountName “Lana Wachowski” –Name “Wachowski” –Surname “Lana” –Path “ou=Domainusers,ou=crew,ou=directors,dc=testcorp,dc=local”
# ADD-ADGroupmember –identity ‘crew’  -member 'Lana Wachowski'

# info cmdlet:
<# 
-FolderEnumerationMode AccessBased. 
SMB doesn't display the files and folders for a share to a user unless that user has rights to access the files and folders. 
By default, access-based enumeration is disabled for new SMB shares.
#>

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

<# 
Todo: 
- checken van de aanwezigheid en info sharedFolder:
    (gebruiken om na te zien) Get-SmbShare -Name "ShareCast"
- Misschien beter om ook via excel de groepen aanmaken en dan die excel gebruiken om de shares aan te maken ipv hard coded?
zoeken op groepen met path "OU=*,OU=DomainUsers,DC=TheMatrix,DC=local" wildcard gebruiken dus. 
Wel enkel indien script groepen op dezelfde manier gedaan wordt.
#>


