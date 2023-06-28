powershell -command "Set-WinUserLanguageList nl-BE -force" 
powershell -command "read-host "Bij einde installatie guestEditions, kies je voor reboot now [druk ENTER als start installatie GuestEditions]:" "
e:vboxadditions\vboxwindowsadditions.exe
# onderstaand wordt niet uitgevoerd want eerst moet machine herstarten om access te hebben tot Z: (de shared folder)
powershell -file "Z:\project\scripts\scriptDC2023_03_05.ps1"


read-host "`n`nHet script sluit nu af (enter)"
