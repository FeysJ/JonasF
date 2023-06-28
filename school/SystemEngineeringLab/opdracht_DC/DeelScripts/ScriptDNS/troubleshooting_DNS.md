# Troubleshooting DNS voor webserver

## Surfen naar www.rallly.thematrix.local

Om naar www.rallly.thematrix.local te surfen werd een CNAME record aangemaakt op de DNS-server. Dit record verwijst naar de webserver. Standaard komt dit dan op de Wordpress website terecht. Om met deze url alsnog op rallly uit te komen, werd een permanente redirect toegevoegd aan de nginx configuratie:

```bash
  server {
    # Permanent redirect
    server_name www.rallly.thematrix.local;

    listen 80;
    listen [::]:80;
    listen 443 ssl http2; #https en http/2
    listen [::]:443 ssl http2; #https en http/2
    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt; # locatie certs
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key; # locatie certs

    return 301 https://rallly.thematrix.local;
  }
```

## Surfen naar thematrix.local, zonder "www"

### Beschrijving

Surfen naar www.thematrix.local is geen probleem, maar surfen naar thematrix.local, zou ook op de webserver terecht moeten komen.

### Optie 1: A-records aanpassen

De A-records naar de domain controller mogen niet verwijderd worden, want dan zou DFS niet meer goed werken en heeft dit een impact op de group policies (zie bronnen). Het toevoegen van een blanco A-record, zou voldoende moeten zijn om het probleem op te lossen. Deze werkwijze wordt echter niet aanbevolen. Het surfen naar de webserver lukt hierdoor niet altijd, omdat men bij het opvragen van het ip-adres soms op de webserver en op andere momenten weer op de DC uitkomt. De werking van de DC wordt hierdoor ook negatief beïnvloed.

### Optie 2:  Reverse proxy / http(s) redirect via IIS

#### http redirect op de DC, indien IIS geïnstalleerd is op de DC (dit lijkt enkel bij de GUI-versie het geval)

1. Installeer de server role "Web Server (IIS)" > "Veelvoorkomende HTTP-functies" > "HTTP-omleiding"
2. Open Internet Information Services (IIS) Manager
3. Ga naar Verbindingen > Sites > Default Web Site > HTTP-omleiding
4. Vink "Aanvragen omleiden naar deze bestemming aan, en vul "http://www.thematrix.local" in
5. Vink ook "Alle aanvragen omleiden naar de exacte bestemming" aan
6. Gebruik HTTP status code 301 (permanent)

#### https redirect vanop de DC

Hiervoor moet een certificaat geïnstalleerd worden.

#### Conclusie

Dit is de meest correcte oplossing, maar tijdrovend om op te zetten via Powershell, daarnaast lijkt het op vlak van security niet aangewezen om webverkeer via de domain controller om te leiden. Om deze redenen werd deze optie niet verder uitgewerkt.

### Optie 3: De domain controller migreren naar een subdomain

Deze optie zou ervoor zorgen dat de opzet niet meer overeenkomt met de opdracht.

### Optie 5: Port forwarding

Deze optie is niet de meest veilige, maar wel snel opgezet en maakt het onnodig om grote aanpassingen te doen. In een productie-omgeving zou het verkeer op een betere manier omgeleid kunnen worden (eventueel via de firewall, rechtstreeks naar een loadbalancer die het verkeer op de juiste manier verder doorstuurt).

De commando's die op de domain controller uitgevoerd moeten worden om dit mogelijk te maken zijn:

`netsh interface portproxy add v4tov4 listenaddress=192.168.168.130 listenport=80 connectaddress=192.168.168.131 connectport=80`

`netsh interface portproxy add v4tov4 listenaddress=192.168.168.130 listenport=443 connectaddress=192.168.168.131 connectport=443`

## Bronnen

* <https://learn.microsoft.com/en-us/iis/configuration/system.webserver/httpredirect/>
* <https://serverfault.com/questions/360165/is-it-possible-for-an-ad-domains-dns-name-to-point-to-a-web-server-instead-of-t>
* <https://serverfault.com/questions/31686/active-directory-is-it-required-that-the-a-record-for-a-domain-point-to-a-dom>
* <https://community.spiceworks.com/topic/244392-dns-question-access-website-without-www>
* <https://social.technet.microsoft.com/Forums/en-US/ad16959c-2ffb-4b3e-8310-def0a2717614/web-services-a-record-at-root-of-active-directory-dns-zone?forum=winserverDS>
* <https://support.cpanel.net/hc/en-us/articles/360055293933-What-does-the-symbol-represent-when-used-inside-of-a-DNS-zone->
* <https://serverfault.com/questions/426326/what-is-the-name-for-a-dns-record-starting-with>
* <https://www.reddit.com/r/sysadmin/comments/chw93a/options_for_apex_domainroot_domain/>
* <https://www.liquidweb.com/kb/redirecting-urls-using-nginx/>
* <https://learn.microsoft.com/en-us/azure/dns/dns-zones-records>
* <https://driesdeboosere.dev/blog/how-to-redirect-www-to-non-www-with-nginx>
* <https://woshub.com/port-forwarding-in-windows>
