#Aanmaken van OUs TheMatrix.local
<#Hieronder staat nog de versie met hard coded OU names en path
New-ADOrganizationalUnit -name "DomainWorkstations"
    New-ADOrganizationalUnit -name "PCs" -path "OU=DomainWorkstations,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Cast" -path "OU=PCs,OU=DomainWorkstations,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Crew" -path "OU=PCs,OU=DomainWorkstations,DC=TheMatrix,DC=local"
            New-ADOrganizationalUnit -name "Directors" -path "OU=Crew,OU=PCs,OU=DomainWorkstations,DC=TheMatrix,DC=local"
    New-ADOrganizationalUnit -name "Servers" -path "OU=DomainWorkstations,DC=TheMatrix,DC=local"

New-ADOrganizationalUnit -name "DomainUsers"
    New-ADOrganizationalUnit -name "Cast" -path "OU=DomainUsers,DC=TheMatrix,DC=local"
    New-ADOrganizationalUnit -name "Crew" -path "OU=DomainUsers,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Directors" -path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local"
        New-ADOrganizationalUnit -name "Producers" -path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local"
#>


# De functie ControleerCSV is een kopie uit import_users_computers.ps1
# Bij het samenstelling van de uiteindelijke script, dient ze niet herhaald te worden want anders dubbel

function ControleerCSV($bestand) {
    if (!(Test-Path $bestand -PathType leaf)) {
        Read-Host "$bestand niet gevonden. Script wordt afgebroken. Toets enter"
        exit
    } 
}

Function MaakOUAan($OU){
    $naam=$OU.name
    $Path=$OU.path
    if(![adsi]::Exists("LDAP://OU=$naam,$Path")) {
        Write-host "$naam `tbestaat nog niet als OU en wordt aangemaakt"
        New-ADOrganizationalUnit -name $naam -path $path
    }
    else {
        write-host "$naam `tbestaat reeds als OU en werd niet aangemaakt"
    }
}

# start van main script 
# eventueel nog een functie van maken 

$csv = "C:\Users\Administrator\Desktop\OUs.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. Wenst u deze te wijzigen (Y/N)"
if ($antwoord -ieq "y") { # expliciete case insensitive equal
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}
ControleerCSV($csv)

$OUfile = Import-Csv $csv -Delimiter ";"
foreach ($OrgUnit in $OUfile)
{
    MaakOUAan($OrgUnit)
}

# VerFraaiing to do:
# Het default path nog vastleggen in overleg binnen onze groep
# eventueel nog overhevelen cmds naar functie verbeteren 
# indien alles in 1 script komt, de exit in functie ControleerCSV wijzigen. Willen we dat script volledig stopt omdat file ontbreekt?  
# Uitzoeken: Slaag er niet in om de OUs terug te delete-en in cli. Geen rechten en OUs zijn beschermd tegen accidental deletion
# oplossen in Gui-versie door via geadvanceerde kenmerken af te vinken in OU properties pop-up (gebruikers en computers
