# Werkwijze voor Windows machines om SSH te kunnen doen naar de Linux servers

1. Bepaal welke Windows gebruiker SSH moet kunnen doen naar de Linux machines.
2. Maak voor deze gebruiker op de locatie `C:\Users\<GEBRUIKERSNAAM>` een map aan met de naam ".ssh", indien deze nog niet bestaat.
3. Kopieer de private en de public key uit `Z:\project\keys` naar de nieuw aangemaakte map `C:\Users\<GEBRUIKERSNAAM>\.ssh`

Op de Linux machines werd de public key reeds toegevoegd aan de "authorized hosts" voor de gebruiker **Vagrant**. Indien SSH nodig zou zijn voor een andere Linux gebruiker, moet de public key voor deze gebruiker toegevoegd worden aan het bestand `/home/<LINUX-GEBRUIKERSNAAM>/.ssh/authorized_keys`. Voor een snelle demo is deze stap niet meer nodig en zou het volstaan om nu via de CLI het commando `ssh vagrant@<ip-adres Linux-machine>` uit te voeren.
