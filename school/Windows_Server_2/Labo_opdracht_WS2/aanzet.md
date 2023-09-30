# Overzicht configuratie

## Gegevens en vereisten van de opdracht

- Beheer van (interne) gebruikers via Active Directory,
- DHCP en DNS voor alle clients in het netwerk,
- Een CA (certificate authority) voor het beheren van certificaten binnen het domein,
- Een SharePoint Server voor het intranet en private cloud storage via OneDrive,
- Een Microsoft SQL Server voor de opslag van SharePoint data,
- Eén of meerdere Windows 10 of 11 clients voor uittesten van de verschillende diensten.

### Vereisten

- VirtualBox NAT network
- IP-adres in de range 192.168.23.0/24
- Servers: vast IP-adres in de range 192.168.23.1 - 192.168.23.50
- Windows 10 clients: dynamisch IP-adres via DHCP in de range 192.168.23.51-192.168.23.100
- Alle toestellen behoren tot 1 domein
  - naam domein: WS2-2324-jonas.hogent
  - Forest functional level: Windows Server 2016
  - Domain functional level: Windows Server 2016
- Redundante DNS-server

## Keuzes

### Server 1: Alpha

#### Functionaliteiten

- Besturingssysteem: Windows server 2019 GUI
- IP-adres: 192.168.23.1/24
- Rollen
  - Active Directory DomeinController
  - DNS
  - DHCP

#### Motivatie




#### Recources

- 2GB RAM
- 1 CPU kern
- 32 GB vDisk

### Server 2: Beta

#### Functionaliteiten

- Besturingssysteem: Windows server 2019 CLI
- IP-adres: 192.168.23.2/24
- Rollen
  - DNS redundante server
  - CA

#### Motivatie

#### Recources

- 2GB RAM
- 1 CPU kern

### Server 3: Charlie

#### Functionaliteiten

- Besturingssysteem: Windows server 2019 CLI
- IP-adres: 192.168.23.3/24
- Rollen
  - Sharepoint server
  - SQL Server 40 GB

#### Motivatie

#### Recources

- 3GB RAM
- 2 CPU kernen

### Client: Zulu


### Server 4: Delta

#### Functionaliteiten

- Besturingssysteem: Windows server 2019 CLI
- IP-adres: 192.168.23.4/24
- Rollen
  - SQL Server 40 GB

#### Motivatie

#### Recources

- 3GB RAM
- 2 CPU kernen


#### Functionaliteiten

- Besturingssysteem: Windows 10
- IP-adres: via DHCP
- Rollen
  - SQL Server Management Studio (SSMS)

#### Motivatie

#### Recources


### Adresseringstabel IPV4

Default gateway van subnet: 1e vrije adres van subnet <br/>
NIC addressen voor Bridge Network adapters: laatste adressen van subnet <br/>
opm: omwille van de nodige adressen voor bridged adapters wordt dhcp-scope beperkt:
* dhcp scope crew:      192.168.168.1 - 192.168.168.52
* dhcp scope cast:      192.168.168.65 - 192.168.168.116
<br/>

| Toestel   | Interface| IP address      |Subnet Mask    |Default Gateway |DNS server     |
| :---      | :---     | :---            | :---          |:---            | :---          |
|R1         | G0/0     | via ISP         | via ISP       |-----           |------         |
|R1         | G0/1.20  | 192.168.168.129 |255.255.255.240|-----           |------         |
|R1         | G0/1.30  | 192.168.168.1   |255.255.255.192|-----           |------         |
|R1         | G0/1.40  | 192.168.168.65  |255.255.255.192|-----           |------         |
|DC         | NIC      | 192.168.168.130 |255.255.255.240|192.168.168.129 |------         |
|Webserver  | NIC      | 192.168.168.131 |255.255.255.240|192.168.168.129 |------         |
|e-mail     | NIC      | 192.168.168.132 |255.255.255.240|192.168.168.129 |------         |
|matrix.org | NIC      | 192.168.168.133 |255.255.255.240|192.168.168.129 |------         |
|Eigen keuze (Redmine)| NIC      | 192.168.168.134 |255.255.255.240|192.168.168.129 |------         |
|PC crew 1  | NIC      | dhcp            |dhcp           |dhcp            |192.168.168.130|
|PC crew 2  | NIC      | dhcp            |dhcp           |dhcp            |192.168.168.130|
|PC cast 1  | NIC      | dhcp            |dhcp           |dhcp            |192.168.168.130|
|PC cast 2  | NIC      | dhcp            |dhcp           |dhcp            |192.168.168.130|

## Info/bronnen

### sharepoint

<https://learn.microsoft.com/en-us/sharepoint/install/install-sharepoint-server-2016-on-one-server>
<https://www.youtube.com/watch?v=Sjl3ixS_724>
<https://learn.microsoft.com/en-us/sharepoint/sites/set-up-onedrive-for-business>

### certificate Authority (CA)

<https://learn.microsoft.com/en-us/windows-server/networking/core-network-guide/cncg/server-certs/install-the-certification-authority>
<https://learn.microsoft.com/en-us/powershell/module/adcsdeployment/install-adcscertificationauthority?view=windowsserver2022-ps>

### SQL

<https://www.youtube.com/watch?v=GpXpn79kWDs&t=80s>
<https://www.youtube.com/watch?v=GpXpn79kWDs>
