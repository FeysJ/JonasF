function ControleerCSV($bestand) {
    if (!(Test-Path $bestand -PathType leaf)) {
        Read-Host "$bestand niet gevonden. Script wordt afgebroken. Toets enter"
        exit
    } 
}

function MaakGPOAan ($NewGPO) {
    $ID=$NewGPO.Id
    $TargetName=$NewGPO.TargetName
    $OU=$NewGPO.OU
 
   
    if ( !(Get-GPO -name $TargetName -ea 0) ){
    
    Write-host "$TargetName `tbestaat nog niet als GPO en wordt aangemaakt"
    import-gpo -BackupId "$ID" `
    -TargetName "$TargetName" `
    -path $PathGPO `
    -CreateIfNeeded | `
    New-GPLink -Target "$OU" `
    -LinkEnabled Yes  
    }
    else {
        write-host "$TargetName `tbestaat reeds als GPO en werd niet aangemaakt"
    }
}



$PathGPO = "Z:\project\GPO"
$csv = "Z:\project\csv\GPO.csv"
[string]$antwoord = Read-Host "Default locatie voor de csv file: $csv. `nWenst u deze te wijzigen [`"Nee`": druk enter]?"
if ($antwoord -ne "") { 
    $csv = Read-Host "Geef het absolute pad van het csv-bestand in, zonder aanhalingstekens"
}

Copy-Item "Z:\project\disable_local_users.ps1" -Destination "\\Agentsmith\NETLOGON"

ControleerCSV($csv)
$GPOfile = Import-Csv $csv -Delimiter ";"
foreach ($GPO in $GPOfile)
{
    MaakGPOAan ($GPO)
}
read-host "`n`ndruk enter om verder te gaan"

