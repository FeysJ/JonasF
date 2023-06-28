# Functies
# Dit script start met een VM waarop windows Server 2019 reeds is geïnstalleerd
# instelling van de netwerkadapters en een aantal tools worden reeds geïnstalleerd

function BasisInstelling ($DCadres,$prefixLengte,$DefGat,$DefaultCompName, $IfIndex, $DNS) {
   
    Clear-Host
   
    New-NetIPAddress `
        -InterfaceIndex $IfIndex `
        -IPAddress $DCadres `
        -PrefixLength $prefixLengte `
        -DefaultGateway $DefGat
    Set-DnsClientServerAddress `
        -InterfaceIndex $ifIndex `
        -ServerAddresses $DNS


    write-host "`n`nHuidige computernaam is: $env:COMPUTERNAME"
    [string]$antwoord = read-host "wenst u deze te wijzigen druk (`"ja`": druk enter)?"
    if ($antwoord -eq "") {	
        $naam=$DefaultCompName  
        $antw = read-host "Wens je de default Machinenaam ($DefaultCompName) toe te passen [`"ja`": druk enter]"
        if (!($antw -eq "")) {
            $naam=Read-host "Welke naam wil je de Machine geven?" 
        }
        If ($naam -eq $env:COMPUTERNAME) {
            write-host "`nDe computernaam is reeds $env:COMPUTERNAME en kan bijgevolg niet gewijzigd worden in $naam"
        }
        else {
            Rename-computer -NewName $naam
            write-host "`nDe computernaam is nu $env:COMPUTERNAME en wordt na herstart $naam"
            [string]$antwoord = read-host "`nWenst u De computer te herstarten [`"ja`": druk enter]?"
            if ($antwoord -eq "") {
                write-host "De computer wordt herstart`nEven (5sec) geduld"
                Start-Sleep 5
                Restart-computer
            else {
                write-host "Eventuele naamwijziging dient aktief te zijn vooraleer AD DS te installeren!! "
                }
            }
        }
    }
    else {
        write-host "De computernaam werd niet gewijzigd en blijft $env:COMPUTERNAME" 
        }


}

function InstallTools{
    z:\NeoFiles\ndp48-x86-x64-allos-enu.exe /q
    z:\NeoFiles\vcredist_x64.exe
    $Shell = New-Object -ComObject "WScript.Shell"
    $Button = $Shell.Popup("Click OK to continue after installing Visual C++ 2013.", 0, "Hello", 0)
    Install-WindowsFeature Server-Media-Foundation, RSAT-ADDS
    cscript C:\Windows\System32\Scregedit.wsf /ar 0
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Enable-WindowsOptionalFeature -Online -FeatureName IIS-IIS6ManagementCompatibility,IIS-Metabase -All  
}



# Main Script
# ------------

# variabelen
$DC_adres="192.168.168.132"
$prefix_Lengte=28
$Def_Gat="192.168.168.129"
$DNSserver="192.168.168.130"
$DefCompName = "neo"
$IfIndex = [int]((Get-NetAdapter).InterfaceIndex | Select-Object -first 1)


BasisInstelling $DC_adres $prefix_Lengte $Def_Gat $DefCompName $IfIndex $DNSserver
InstallTools



