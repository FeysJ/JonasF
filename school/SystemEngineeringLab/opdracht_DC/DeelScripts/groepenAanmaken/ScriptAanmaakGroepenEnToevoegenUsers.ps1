# DIt script maakt de gewenste groepen aan.
# De gewenste groepen worden ingelezen via csv-file groups.csv
# De users worden geselecteerd a.d.h.v. hun 

function ControleerCSV($bestand) {
    if (!(Test-Path $bestand -PathType leaf)) {
        Read-Host "$bestand niet gevonden. Script wordt afgebroken. Toets enter"
        exit
    } 
}

function MaakGroepAan ($NewGroep) {
    $naam=$NewGroep.Name
    $Path=$NewGroep.Path
    $Beschrijving=$NewGroep.Description
    $domein=$NewGroep.scope
   
    $test=Get-ADGroup -LDAPFilter "(SAMAccountName=$naam)"
    if ($test -eq $null) {
        Write-host "$naam `tbestaat nog niet als groep en wordt aangemaakt"
        New-ADGroup -Name "$naam" `
        -SamAccountName "$naam" `
        -GroupCategory Security `
        -GroupScope "$domein" `
        -DisplayName "$naam" `
        -Path "$path" `
        -Description "$beschrijving"
    }
    else {
        write-host "$naam `tbestaat reeds als groep en werd niet aangemaakt"
    }
}

function VoegUsersToeAanGroep ($grp){
<# check of user bestaat
If (Get-ADUser ($Username.Text)) {...}
vb GET-ADUSer joel.silver
else {write-host user $username.text bestaat niet}

maar zal niet gebeuren omwille van constructie cmd door Lara
Eventueel wel de users in de groep tonen en of hij er al in zat, krijg je dan error-message?

Welke users in een groep:   Get-ADGroupMember -identity GRP_cast
Kijken of user bestaat:     
Want error indien de user niet bestaat ADD-ADGroupMember -identity GRP_crew -Members Joel.SilverBestaatNiet
Geen probleem om een 2de keer de user aan een groep toe te kennen: geen error
#>

    $GrpPath=$grp.Path
    $GrpName=$grp.Name
    Get-ADUser -SearchBase "$GrpPath" `
    -Filter * | `
    ForEach-Object {
        # Omwille van de ForEach-object hoeven we geen controle van het bestaan van de user te doen.
        # De user bestaat immers, want anders was hij niet gevonden met Get-ADuser 
        $username=$_.name
        $user = Get-ADGroupMember -Identity $grpName | Where-Object {$_.name -eq $username}  
        if($user){  
            Write-Host "`t`tuser $username is al lid van de groep $GrpName en werd niet nogmaals toegevoegd"
        }  
        else{  
            Write-Host "`t`tuser $username wordt toegevoegd als lid van de groep $GrpName"
            Add-ADGroupMember -Identity "$grpName" -Members $_ 
        }  
    }
} 

########################
# start van main script 
########################

#Aanmaak groepen en de bijhorende users toevoegen
Clear-Host
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++"
Write-Host "+ Aanmaak groepen en toekennen users aan groepen +" 
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++`n `n"

$csv = "Z:\project\csv\Groups.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. `nWenst u deze te wijzigen (Y/N)"
# expliciete case insensitive equal
if ($antwoord -ieq "y") { 
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}
ControleerCSV($csv)
$Groupfile = Import-Csv $csv -Delimiter ";"
foreach ($groep in $Groupfile)
{
    MaakGroepAan ($groep)
    VoegUsersToeAanGroep ($groep)
}

read-host "`n`nHet script sluit nu af (enter)"

# New-ADGroup -Name "GRP_Crew_not_directors" -SamAccountName GRP_Crew_not_directors -GroupCategory Security -GroupScope Global -DisplayName "GRP_Crew_not_directors" -Path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local" -Description "Alle leden van de crew, behalve de directors"
# Get-ADUser -SearchBase ‘OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local’ -Filter * | Where-Object { ($_.DistinguishedName -notlike "*OU=Directors*") } | ForEach-Object {Add-ADGroupMember -Identity ‘GRP_Crew_not_directors’ -Members $_ }


# VerFraaiing:

# eventueel keuze default path / ingave path via een functie
# default path nog vastleggen met team en in globale parameter van het script script