# System Engineering Project - Opdracht Dozer

## **Overzicht functionaliteiten**

Op deze VM draait een webserver met de applicatie Redmine. Redmine is een open source project management applicatie. De server wordt opgezet d.m.v. een Vagrant script in de map AlmaVM.
De volgende zaken werden geïnstalleerd en/of geconfigureerd:

* Ruby
* mysql
* httpd
* SVN (dit is niet meer nodig in de huidige installatie en valt weg)
* Passenger
* Redmine
* Andere benodigdheden: sqlite3, nodejs, yarn, ...
* firewall en SELinux instellingen
* self signed SSL certificaat
* login via ssh, zonder wachtwoord
* de root en redmine gebruikers mogen niet inloggen
* http-verkeer wordt omgeleid naar https
* <www.dozer.thematrix.local> wordt omgeleid naar <dozer.thematrix.local>

## **Links**

1. [Werkwijze installatie](Werkwijze.md)
2. [Script](../AlmaVM/provisioning/dozer.sh)
3. [Lastenboek](lastenboek.md)
4. [Testen](Testen)
