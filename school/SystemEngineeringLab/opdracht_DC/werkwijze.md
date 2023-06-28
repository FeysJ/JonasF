# System Engineering Project - Opdracht DC 

De opdracht TheMatrix.local bevat de aanmaak van een domeincontroller. <br/>
De installatie en configuratie gebeurt door een 3tal scripts. Deze scripts maken gebruik van diverse csv-files. <br/>
Alle scripts en csv-files zijn te vinden in de folder [_globaalScript](_GlobaalScript)

## **Werkwijze** 

Maak op je host een folder aan die als shared folder zal fungeren (virtuele machine van de DC krijgt automatisch toegang via de scripts) en bevat o.a. de files die de dc nodig voor de configuratie.<br/>
De folder structuur binnen de shared folder moet zijn:<br/>
* .\project\scripts <br/>
Hier worden de scripts geplaatst
    * 1install_DCVM_2023_04_23.ps1
    * 2scriptDC2023_04_23.ps1
    * 3install_DCEnConfiguratie.ps1
    * disable_local_users.ps1
    * winServer_postinstall.cmd
* .\project\csv <br/>
Hier worden de csv-files geplaatst <br/>
    * OUs.csv
    * users_en_computers.csv
    * groups.csv
    * dns.csv
    * Paths.csv
    * GPO.csv
* .\project\GPO
Bevat de backup van de GPO's <br/>
    * Lokale accounts uitschakelen
    * login permissions
    * Toegang verbieden tot control panel, behalve voor directors
    * Toegang verbieden tot netwerk adapter configuratie voor cast leden
    * Niemand mag werkbalken toevoegen aan de taakbalk
    * Automatische koppeling van netwerkschijven

Een voorbeeld van deze structuur vind je hieronder:<br/>
![[Afbeelding directoryStructuur]](pictures/directoryOrganisatie.jpg)<br/>

### **Algemene variabelen**
Een beperkt aantal variabelen zijn hard coded opgenomen in de scripts:

```md
- $DC_adres="192.168.168.130"
- $prefix_Lengte=28
- $Def_Gat="192.168.168.129"
- $DefaultSiteName = "SiteTi02"
- $DefCompName = "AgentSmith"
- $NetworkIdv6 = 2001:db8:a::/64 
```

### **csv-files** 
De diverse csv-files zijn:
* OUs.csv<br/>
Bevat de nodige data van alle OUs om de domeinstructuur te maken. Niet wijzigen 
* users_en_computers.csv<br/>
Bevat de nodige data om de users en PCs aan te maken in het domein. Niet wijzigen
* groups.csv<br/>
Bevat de nodige data om de groepen (crew, cast en directors) aan te maken. Niet wijzigen
* dns.csv<br/>
Bevat de nodige data om de DC als dns server te configureren. Niet Wijzigen.
* Paths.csv
Via deze csv, kan/moet een gebruiker van de scripts bepaalde data ingeven. Dit vergemakkelijkt het installatie proces en vermijdt type-errors die het script zouden kunnen onderbreken.<br/>
De tabel bevat onderstaande kolommen. Pas deze aan volgens je host-PC.
    * iso:  wijzig naar het absolute path op je host van de windowsserver-iso <br/>
    vb: D:\TILE2\system engineering project\downloads\nl_windows_server_2019_x64_dvd_82f9a152.iso
    * vdi:  wijzig naar het absolute path van de directory waar je de vdi van de DC wilt plaatsen <br/>
    vb: D:\VitualBoxVMs\System Engineering project
    * share: wijzig naar het absolute path van de directory van de vereiste folder die je als share (tussen VM en host) zult gebruiken. <br/>
    vb: C:\Joost files\Bachelor ICT\system engineering project\SharedFolder
    * postinstallscript: wijzig naar het absolute path van het postinstall script. <br/>
    vb: C:\Joost files\Bachelor ICT\system engineering project\SharedFolder\project\scripts\winServer_postinstall.cmd <br/>
* GPO.csv <br/>
Bevat de nodige data om de GPO's te importeren en te koppelen aan een groep. Niet Wijzigen.

### **uitvoering**
Run achteréénvolgens de scripts
* 1install_DCVM_2023_04_08.ps1 <br/> 
Run dit script vanop de host PC. Doe dit via powershell vanuit de locatie/prompt `<path sharedFolder`>\project\scripts <br/> 
Dit script maakt de VM aan voor de DC. <br/> 
Het script voorziet deze VM vervolgens van een bridged adapter, toegang tot de shared folder (host <> VM), installeert windowsServer2019 en installeert via een postinstallscript de guesteditions.<br/> 
Een herstart (na de installatie guest editions) van de VM is noodzakelijk om voor de VM toegang tot de shared folder te bekomen (=activatie guestEditions door restart).<br/>
Duurtijd: 4min 40sec (op high end SIM-laptop 4min 0sec)
* 2scriptDC2023_04_08bis.ps1<br/>
Run dit script vanop de VM (Doe dit bij voorkeur vanuit de locatie Z:\project\scripts. Toegankelijk van de shared folder).<br/>
Dit script installeert ADDS en promoveert de machine tot domain controller. Het forest theMatrix.local wordt aangemaakt.<br/>
Een Herstart is noodzakelijk om dit te activeren. Volgende boodschap zal op de VM lang zichtbaar zijn na deze herstart:<br/>
![[Afbeelding opstart DC]](pictures/boodschapBijRestartNaScript2.jpg)<br/>
Duurtijd: 8min20sec (op high end SIM-laptop 7min 50sec)
* 3install_DCEnConfiguratie.ps1<br/> 
Run ook dit script vanop de VM. <br/> 
Dit script hernoemt de sitenaam, maakt de domeinstructuur, users, PCs en de groepen aan, installeert de rollen DNS en DHCP.<br/> 
Een herstart is nodig om de dhcp-rol goed te laten werken. <br/>
Op het einde van dit script worden ook de GPO's geïmporteerd. <br/>
Duurtijd: 03min10sec<br/> 
