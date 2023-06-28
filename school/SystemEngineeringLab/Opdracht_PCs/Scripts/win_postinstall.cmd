powershell -command "Set-WinUserLanguageList nl-BE -force"
e:vboxadditions\vboxwindowsadditions.exe
powershell -command "add-computer -domainname TheMatrix.local"
powershell -command "read-host "Einde postinstall-script. De machine zal herstarten. Druk enter""
powershell -command "restart-computer"
