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

function InstallatieDHCP ( $dhcpserveradres, $ServerName, $ServerForest ) {
    # dnsnaam wordt agentsmith.thematrix.local
        $dnsNaam=$ServerName+"."+$ServerForest
    # compname wordt agentsmith.thematrix.local
        $compNaam=$ServerName+"."+$ServerForest
        $test=Get-DhcpServerInDC
        if ($null -eq $test) {
            Write-host "Installatie DHCP wordt gestart.`n"
            Install-WindowsFeature -name DHCP -IncludeManagementTools
            # Hier zou ik vragen om te herstarten. Soms gebeurt dit automatisch en soms niet na de installatie DHCP. Is goed praktisch voor installatie Dhcp. Problemen op demo willen we niet.
            [string]$antwoord = read-host "`nWenst u De computer te herstarten (dit wordt geadviseerd na installatie DHCP? (ja: Y of enter)"
            if ($antwoord -ieq "y" -or $antwoord -eq "") {
                write-host "De computer wordt herstart`nEven (3 sec) geduld"
                Start-Sleep 3
                Restart-computer
            }
        else {
            write-host "Informatief: DHCP kan kuren hebben indien je geen herstart deed. "
            }
        }
        else {
            write-host "De DHCP rol is reeds geinstalleerd en wordt dus nu niet geinstalleerd "
        }
    
    <#
    Dit nog wissen indien niet nodig
    
    # 02/04 @Lara: In beide opstellingen is dc adres toch 192.168.168.130. En DC is toch steeds DHCP server? Ik zal het voorlopig uit global script laten
    [string]$labo = read-host "Gaat het over een live labo-opstelling (ip-adres 192.168.168.130)? (default: Y)"
    if ($labo -ieq "y" -or $labo -eq "") {
        $ipadres = "192.168.168.130"
    }
    else {
        $ipadres = "192.168.168.129"
    }
    #>
    
    # When you run the following netsh command on the DHCP server, the DHCP Administrators and DHCP Users security groups are created in Local Users and Groups on the DHCP server.
    # effect van verbose bekijken indien de boodschappen toegevoegde waarde hebben.
        Add-DhcpServerSecurityGroup -Verbose
    # Authorize the DHCP server in Active Directory
        Add-DhcpServerInDC -DnsName $dnsNaam -IPAddress $DC_adres
    # Notify Server Manager that post-install DHCP configuration is complete
    #   Alternatief commando:
    #   Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name "ConfigurationState" –Value 2
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\ServerManager\roles\12" -Name "ConfigurationState" -Value 2
        Restart-Service dhcpserver
    # Server level opties:
        Set-DhcpServerv4OptionValue -ComputerName $compNaam -DnsServer $DC_adres -DnsDomain $ServerForest
    # DHCP scopes aanmaken:
    # workstations crew: 192.168.168.0/26 	=> 192.168.168.1 - 192.168.168.62 // DG: 192.168.168.1
    # workstations cast: 192.168.168.64/26  => 192.168.168.65 - 192.168.168.126 // DG: 192.168.168.65
    
        if ( !(Get-DhcpServerv4Scope -ComputerName $compNaam -ScopeId 192.168.168.0 -ea 0) ) {
            write-host "`nDe dhcp scope crew `(192.168.168.2 tot .62`) wordt aangemaakt`n"
            Add-DhcpServerv4Scope -ComputerName $compNaam -name "Crew" -StartRange 192.168.168.2 -EndRange 192.168.168.62 -SubnetMask 255.255.255.192 -State Active
            Set-DhcpServerv4OptionValue -ScopeId 192.168.168.0 -Router 192.168.168.1
        }
        else {
            write-host "De dhcp scope crew `(192.168.168.2 tot .62`) bestaat reeds en wordt niet aangemaakt"
        }
    
        if ( !(Get-DhcpServerv4Scope -ComputerName $compNaam -ScopeId 192.168.168.64 -ea 0) ) {
            write-host "De dhcp scope cast `(192.168.168.66 tot .126`) wordt aangemaakt"
            Add-DhcpServerv4Scope -ComputerName $compNaam -name "Cast" -StartRange 192.168.168.66 -EndRange 192.168.168.126 -SubnetMask 255.255.255.192 -State Active
            Set-DhcpServerv4OptionValue -ScopeId 192.168.168.64 -Router 192.168.168.65
        }
        else {
            write-host "De dhcp scope cast `(192.168.168.66 tot .126`) bestaat reeds en wordt niet aangemaakt"
        }
    }
    function WijzigSiteName ($defaultNaam){
        $Site = Get-ADReplicationSite
        $Sitenaam= $Site.name
        $antwoord = read-host "`n`nWens je de huidige sitename $sitenaam te wijzigen [`"ja`": druk enter]?"
        if ($antwoord -eq "") {
                $antw = read-host "Wens je de default sitename $defaultNaam toe te passen [`"ja`": druk enter]?"
                    if ($antw -eq "") {
                    Get-ADReplicationSite $Sitenaam | Rename-ADObject -NewName $defaultNaam
                    }
                    else {
                        $newSiteNaam=Read-host "Welke naam wil je de Site geven?" 
                        Get-ADReplicationSite $Sitenaam | Rename-ADObject -NewName $newSiteNaam
                    }
                $Site = Get-ADReplicationSite
                $Sitenaam= $Site.name
                write-host "De Sitenaam is nu: $Sitenaam"
                }
        else {
            write-host "De Sitenaam werd niet gewijzigd en blijft $Sitenaam"
            }
        }

##############################################################
# start van main script 
# eventueel nog functies destilleren 
##############################################################

$DC_adres="192.168.168.130"
$DefCompName="AgentSmith"
$HetForest="TheMatrix.local"


Clear-Host
Write-Host "+++++++++++++++++++"
Write-Host "+ Wijzig SiteName +" 
Write-Host "+++++++++++++++++++`n `n"
WijzigSiteName $DefaultSiteName

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

Clear-Host
Write-Host "++++++++++++++++++++"
Write-Host "+ Installatie DHCP +" 
Write-Host "++++++++++++++++++++`n `n"

InstallatieDHCP $DC_adres $DefCompName $HetForest

read-host "`n`nHet script sluit nu af (enter) en de computer wordt herstart"
Restart-computer

# New-ADGroup -Name "GRP_Crew_not_directors" -SamAccountName GRP_Crew_not_directors -GroupCategory Security -GroupScope Global -DisplayName "GRP_Crew_not_directors" -Path "OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local" -Description "Alle leden van de crew, behalve de directors"
# Get-ADUser -SearchBase ‘OU=Crew,OU=DomainUsers,DC=TheMatrix,DC=local’ -Filter * | Where-Object { ($_.DistinguishedName -notlike "*OU=Directors*") } | ForEach-Object {Add-ADGroupMember -Identity ‘GRP_Crew_not_directors’ -Members $_ }


# VerFraaiing:
# Uitzoeken: Slaag er niet in om de OUs terug te delete-en in cli. Geen rechten en OUs zijn beschermd tegen accidental deletion
# oplossen in Gui-versie door via geadvanceerde kenmerken af te vinken in OU properties pop-up (gebruikers en computers
# eventueel keuze default path / ingave path via een functie
# default path nog vastleggen met team en in globale parameter van het script script