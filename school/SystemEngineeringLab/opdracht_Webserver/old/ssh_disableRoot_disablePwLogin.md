## SSH connectie zonder wachtwoord in te geven

Vanop de windows DC **in powershell**:

1. commando `ssh-keygen`uitvoeren
2. bevestig de standaard directory met `enter`
3. geen passphrase ingeven, bevestigen met `enter`
4. kopieer de public key naar de webserver: `cat ~/.ssh/id_rsa.pub | ssh vagrant@192.168.168.131 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"`
5. bevestig door PW van vagrant in te geven
6. log nu in op de webserver via ssh: `ssh vagrant@192.168.168.131`
7. PW ingeven van vagrant
8. Voer nu commando `chmod -R 700 ~/.ssh`uit
9. commando `exit` om terug uit te loggen
10. test of je nu kan inloggen zonder wachtwoord op de webserver: `ssh vagrant@192.168.168.131`

## disable login with PW and root login

1. login op de webserver met gebruiker vagrant: `ssh vagrant@192.168.168.131`
2. open config file van ssh: `sudo nano /etc/ssh/sshd_config`
3. uncomment eventueel de lijn en pas aan of voeg toe
    > lijn 65:  PasswordAuthentication no
    > voeg toe lijn 40: PermitRootLogin no
    > voeg toe: ChallengeResponseAuthentication no
4. herstart ssh service: `sudo systemctl restart sshd`
5. Je kan nu niet meer via ssh inloggen met een wachtwoord en root account

Je kan dit testen door een extra account aan te maken met wachtwoord op de webserver en proberen in te loggen via ssh
