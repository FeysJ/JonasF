powershell -command "Set-WinUserLanguageList nl-BE -force"
e:vboxadditions\vboxwindowsadditions.exe
powershell -command "add-computer -domainname TheMatrix.local -restart"
