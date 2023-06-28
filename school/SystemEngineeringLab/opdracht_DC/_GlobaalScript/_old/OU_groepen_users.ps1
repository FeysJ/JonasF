# Combiscript 

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
            Write-Host "$SamAccountName bevindt zich op de verkeerde locatie. Deze wordt verplaatst naar de juiste OU."
            $te_verhuizen_computer = Get-ADComputer -Filter { Name -eq $SamAccountName }
            Move-ADObject -Identity $te_verhuizen_computer.DistinguishedName -TargetPath "$OU"
        }
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
    # De > $null werd toegevoegd omdat de message van de cmdlet New-SmbShare ongecontroleerd tevoorschijn komen en zo de script-berichten verstoren. 
    }
    else {
        Write-host "`t$Sharenaam `tbestaat reeds als Shared folder en werd niet aangemaakt"
        #Write-Host "`n`n"
    }
    Write-Host "`n"
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

##############################################################
# start van main script 
# eventueel nog functies destilleren 
##############################################################

# aanmaak OUs via csv file
Clear-Host
Write-Host "+++++++++++++++"
Write-Host "+ Aanmaak OUs +" 
Write-Host "+++++++++++++++`n `n"

$csv = "Z:\project\csv\OUs.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file OU's: $csv. `nWenst u deze te wijzigen (Nee: druk enter)"
if ($antwoord -ne "") { 
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}
ControleerCSV($csv)
$OUfile = Import-Csv $csv -Delimiter ";"

foreach ($OrgUnit in $OUfile)
{
    MaakOUAan($OrgUnit)
}
read-host "`n`ndruk enter om verder te gaan"

#aanmaak users en computers binnen OUs via csv file
Clear-Host
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
Write-Host "+ Aanmaak users (en hun persoonlijke share) en computers +" 
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++`n `n"

$csv = "Z:\project\csv\users_en_computers.csv" 
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. `nWenst u deze te wijzigen (Nee: druk enter)"
if ($antwoord -ne "") { 
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
read-host "`n`ndruk enter om verder te gaan"

#Aanmaak groepen en de bijhorende users toevoegen
Clear-Host
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++"
Write-Host "+ Aanmaak groepen en toekennen users aan groepen +" 
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++`n `n"

$csv = "Z:\project\csv\Groups.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. `nWenst u deze te wijzigen (Nee: druk enter)"
if ($antwoord -ne "") { 
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}
ControleerCSV($csv)
$Groupfile = Import-Csv $csv -Delimiter ";"
foreach ($groep in $Groupfile)
{
    MaakGroepAan ($groep)
    VoegUsersToeAanGroep ($groep)
}
read-host "`n`ndruk enter om verder te gaan"

Clear-Host
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
Write-Host "+ Aanmaak Shared folders voor groepen cast, crew,...                 +"                     
Write-host "+ (Groepen corresponderend met een sub-OU van de OU `"Domeinusers`")   +" 
Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++`n `n"
$csv = "Z:\project\csv\Groups.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. `nWenst u deze te wijzigen (Nee: druk enter)"
if ($antwoord -ne "") { 
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}
ControleerCSV($csv)
$Groupfile = Import-Csv $csv -Delimiter ";"
Write-Host "`n"
foreach ($groep in $Groupfile) {   
                            #hier staat nog hardcoded ou=domainUsers als waar je subOUs van zoekt 
    if ($groep.Path.toUpper() -cnotlike 'OU=*,OU=*,OU=DomainUsers,DC=TheMatrix,DC=local'.ToUpper() `
        -and $groep.Path.ToUpper() -clike 'OU=*,OU=DomainUsers,DC=TheMatrix,DC=local'.ToUpper() ) {
            MaakSharedFolder ($groep)   
            #read-host "Enter a.u.b"
        }
#Write-Host "einde foreEach"
}
read-host "`n`nHet script sluit nu af (enter)"

# New-ADGroup -Name "GRP_Crew_not_directors" -SamAccountName GRP_Crew_not_directors -GroupCategory Security -GroupScope Global -DisplayName "GRP_Crew_not_directors" -Path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local" -Description "Alle leden van de crew, behalve de directors"
# Get-ADUser -SearchBase ‘OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local’ -Filter * | Where-Object { ($_.DistinguishedName -notlike "*OU=Directors*") } | ForEach-Object {Add-ADGroupMember -Identity ‘GRP_Crew_not_directors’ -Members $_ }


# VerFraaiing:
# Uitzoeken: Slaag er niet in om de OUs terug te delete-en in cli. Geen rechten en OUs zijn beschermd tegen accidental deletion
# oplossen in Gui-versie door via geadvanceerde kenmerken af te vinken in OU properties pop-up (gebruikers en computers
# eventueel keuze default path / ingave path via een functie
# default path nog vastleggen met team en in globale parameter van het script script