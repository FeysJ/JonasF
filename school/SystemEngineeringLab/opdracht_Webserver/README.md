# System Engineering Project - Opdracht webserver 

## **Overzicht functionaliteiten**

De opdracht TheMatrix.local bevat de aanmaak van een webserver via script in Vagrant.<br/>
Via dit script wordt een basis VM aangemaakt met het besturingssysteem almalinux-9.1 in VirtualBox.<br/>
Deze zaken worden geïnstalleerd/geconfigureerd:
   * Nginx webserver met CMS WordPress als hoofdpagina en bijhorende MySQL database
   * HTTPS en HTTP/2
   * verbergen versie Nginx
   * self-signed ssl certificates
   * Rallly meeting planner: [Rallly](https://github.com/lukevella/rallly)
   * reverse proxy voor rallly

## **Links**

1. [Werkwijze installatie](werkwijze.md)
2. [Script](..\AlmaVM\provisioning\trinity.sh)
3. [Lastenboek](lastenboek.md)
4. [Testen](testen)
5. [Afbeeldingen](images)



