# System Engineering Project - Opdracht Matrix (theoracle)

## **Overzicht functionaliteiten**

Op deze VM draait een webserver met de applicatie Syanpse Matrix.
Matrix Synapse of Matrix.org is een populaire vervanging van het oude IRC. De server wordt opgezet d.m.v. een Vagrant script in de map AlmaVM.
De volgende zaken werden geïnstalleerd en/of geconfigureerd:

* Synapse server
* Nginx reverse proxy (Webserver)
* Standaard gebruikers & kamers
* Matrix-Commander CLI tool (Webserver)
* Shutdown script 
* Shutdown taak (Webserver)
* Andere benodigdheden: python3-virtualenv, libolm-devel ...
* Firewall en SELinux instellingen
* Self signed SSL certificaat (via Webserver)
* Login via ssh, zonder wachtwoord (Alle Alma server)
* Root mag niet inloggen (Alle Alma servers)

## **Links**

1. [Werkwijze installatie](Werkwijze.md)
2. [Script](..\AlmaVM\provisioning\theoracle.sh)
3. [Script Webserver](..\AlmaVM\provisioning\trinity.sh)
4. [Lastenboek](lastenboek.md)
5. [Testen](Testen)
