# Cheat sheet en checklists

Naam student: NAAM

Vul dit document zelf aan met commando's die je nuttig vindt, of waarvan je merkt dat je het verschillende keren moeten opzoeken hebt. Idem voor checklists voor troubleshooting, m.a.w. procedures die je kan volgen om bepaalde problemen te identificeren en op te lossen. Voeg waar je wil secties toe om de structuur van het document overzichtelijk te houden. Werk dit bij gedurende heel het semester!

Je vindt hier alvast een voorbeeldje om je op weg te zetten. Zie [https://github.com/bertvv/cheat-sheets](https://github.com/bertvv/cheat-sheets) voor een verder uitgewerkt voorbeeld.

## Commando's

| Taak                       | Commando       |
| :---                       | :---           |
| Wie is ingelogd in systeem | `who`          |
| Toon user id               | `id`           |
| switch user in eigen shell | `su USER`      |
| switch user in shell target| `su - USER`    |
| switch root shell          | `su -`         |
| kom root met eigen ww      | `sudo su -`    |


## User Management

File: /etc/passwd
Shell list: /etc/shells
wachtwoorden: /etc/shadow
/etc/default/useradd

| Taak                       | Commando                         |
| :---                       | :---                             |
| maak user aan              | `adduser USER`                   |
| * maak homedirectory       | `useradd -m USER `               |
| * zet naam homedirectory   | `useradd -m -d USER `            |
| * omschrijving zetten      | `useradd -c 'omschrijving' USER `|
| verwijder user + homedirect| `userdel -r USER `               |
| wijzig shellomgeving       | `usermod -s /bin/bash USER`      |
| maak user sudo             | `usermod -aG sudo USER`          |
| wijzig wachtwoord          | `passwd USER `                   |
| lock user                  | `usermod -L USER `               |
| * een "!" staat voor ww in /etc/shadow |                      |
| unlock user                | `usermod -U USER `               |
| expiration date user       | `chage -E USER `                 |
| password age user max      | `chage -M USER `                 |


## Group Management

File: /etc/group
informatie group admins: /etc/gshadow

| Taak                       | Commando                         |
| :---                       | :---                             |
| maak group aan             | `groupadd GROUP`                 |
| overzicht groups user      | `groups USER`                         |
| toevoegen aan group        | `usermod -aG GROUP USER`         |
| wijzigen naam group        | `groupmod -n  NIEUW OUD`         |
| verwijderen group          | `groupdel  GROUP`                |
| wijzigen group owner       | `gpasswd -A OWNER GROUP`         |
| wijzigen naar geen owner   | `gpasswd -A "" GROUP`            |
| verwijderen user uit group | `gpasswd -d USER GROUP`          |



## Permissions

File: /etc/passwd

| Taak                       | Commando                         |
| :---                       | :---                             |
| eigenaar van file/map      | `chown USER:GROUP FILE`          |
| rechten van file/map       | `chmod u=rwx,g=r FILE `          |
| * user/group/other         |                                  |
| maak groepeigenaar automatisch eigenaar nieuwe file | `chmod g+s DIRECTORY`|
| enkel groepeigenaar kan bestand verwijderen  | `chmod 1770  DIRECTORY`|
