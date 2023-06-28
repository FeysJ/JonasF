# Netwerkconfiguratie

## Gegevens en vereisten

- IPv4 addressering
- Private ip-addressen => we nemen C-klasse
- Zo weinig mogelijk adressen verspillen
- 3 Vlan's = 3 subnetten
- VLAN 20 => minimaal 10 (5 adressen servers + minimaal 4 voor elk teamlid t.b.v. bridged adapters fysieke NIC + Default gateway)
- VLAN 30 => # ip -addressen ongekend
- VLAN 40 => # ip-addressen ongekend

## Uitwerking VLAN's IPV4

Klasse C: 192.168.0.0 - 192.168.255.255
Keuze netwerkadres: 192.168.168.0/24

### Tabel via VLSM IPV4

| Subnet ID | Omschrijving     | # nodig    |Subnet Address    |Subnet Mask|Host address range                |Broadcast address |
| :---      | :---             | :---       | :---             | :---      | :---                             | :---             |
| VLAN 20   | internal_servers | 5 + 1 + 4  |192.168.168.128/28|255.255.255.240|192.168.168.129 - 192.168.168.142 |192.168.168.143   |
| VLAN 30   | crew             | ?          |192.168.168.0/26  |255.255.255.192|192.168.168.1 - 192.168.168.62    |192.168.168.63    |
| VLAN 40   | cast             | ?          |192.168.168.64/26 |255.255.255.192|192.168.168.65 - 192.168.168.126  |192.168.168.127   |

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

### Adresseringstabel NICs bridged Adapters

| Toestel                  | Interface |  IP address      |Subnet Mask       |Default Gateway |DNS server      |
| :---                     | :---      | :---             | :---             |:---            | :---           |
| vlan 20 (servers) Jonas  | NIC       |  192.168.168.142 |255.255.255.240   |192.168.168.129 |192.168.168.130 |
| vlan 20 (servers) Joost  | NIC       |  192.168.168.141 |255.255.255.240   |192.168.168.129 |192.168.168.130 |
| vlan 20 (servers) Lara   | NIC       |  192.168.168.140 |255.255.255.240   |192.168.168.129 |192.168.168.130 |
| vlan 20 (servers) Liam   | NIC       |  192.168.168.139 |255.255.255.240   |192.168.168.129 |192.168.168.130 |
| vlan 30 (crew) Jonas     | NIC       |  192.168.168.62  |255.255.255.192   |192.168.168.1   |192.168.168.130 |
| vlan 30 (crew) Joost     | NIC       |  192.168.168.61  |255.255.255.192   |192.168.168.1   |192.168.168.130 |
| vlan 30 (crew) Lara      | NIC       |  192.168.168.60  |255.255.255.192   |192.168.168.1   |192.168.168.130 |
| vlan 30 (crew) Liam      | NIC       |  192.168.168.59  |255.255.255.192   |192.168.168.1   |192.168.168.130 |
| vlan 40 (cast) Jonas     | NIC       |  192.168.168.126 |255.255.255.192   |192.168.168.65   |192.168.168.130 |
| vlan 40 (cast) Joost     | NIC       |  192.168.168.125 |255.255.255.192   |192.168.168.65  |192.168.168.130 |
| vlan 40 (cast) Lara      | NIC       |  192.168.168.124 |255.255.255.192   |192.168.168.65   |192.168.168.130 |
| vlan 40 (cast) Liam      | NIC       |  192.168.168.123 |255.255.255.192   |192.168.168.65   |192.168.168.130 |


## Uitwerking VLAN's IPV6

Gestandariseerde subnet voor IPV6 werd vastgelegd is /64. (https://datatracker.ietf.org/doc/rfc7421/)
Om aan /64 te komen voor end-hosts starten we van /62

Keuze netwerkadres: ``` 2001:db8:a::/62 ```

| Subnet ID | Omschrijving     | # nodig|Subnet Address   |Host address range                                |
| :---      | :---             | :---   | :---            | :---                                             |
| VLAN 20   | interne servers  | 5      |``` 2001:db8:a::/64 ``` |``` 2001:db8:a:: - 2001:db8:a:0:ffff:ffff:ffff:ffff ```|
| VLAN 30   | werkstation crew | ?      |``` 2001:db8:a:1::/64 ```|``` 2001:db8:a:1:: - 2001:db8:a:1:ffff:ffff:ffff:ffff ```|
| VLAN 40   | werkstation cast | ?      |``` 2001:db8:a:2::/64 ```|``` 2001:db8:a:2:: - 2001:db8:a:2:ffff:ffff:ffff:ffff ```|
<br/>

| Toestel   | Interface | IP address        |Link-local     |DNS server           |
| :---      | :---      | :---              | :---          | :---                |
|R1         | via ISP   | ``` via isp ```| ``` fe80::1 ``` |``` ------ ``` |
|R1         | G0/1.20   | ``` 2001:db8:a::1/64 ``` | ``` fe80::1 ``` | ``` ------ ``` |
|R1         | G0/1.30   | ``` 2001:db8:a:1::1/64 ``` | ``` fe80::1 ``` | ``` ------ ``` |
|R1         | G0/1.40   | ``` 2001:db8:a:2::1/64 ``` | ``` fe80::1 ``` | ``` ------ ``` |
|DC         | NIC       | ``` 2001:db8:a::2/64 ``` | ``` / ``` | ``` ------ ``` |
|Webserver  | NIC       | ``` 2001:db8:a::3/64 ``` | ``` / ``` | ``` ------ ``` |
|e-mail     | NIC       | ``` 2001:db8:a::4/64 ``` | ``` / ``` | ``` ------ ``` |
|matrix.org | NIC       | ``` 2001:db8:a::5/64 ``` | ``` / ``` | ``` ------ ``` |
|eigen keuze| NIC       | ``` 2001:db8:a::6/64 ``` | ``` / ``` | ``` ------ ``` |
|PC crew 1  | NIC       | ``` DHCP ``` | ``` / ``` |``` 2001:db8:a::2/64 ``` |
|PC crew 2  | NIC       | ``` DHCP ``` | ``` / ``` |``` 2001:db8:a::2/64 ``` |
|PC cast 1  | NIC       | ``` DHCP ``` | ``` / ``` |``` 2001:db8:a::2/64 ``` |
|PC cast 2  | NIC       | ``` DHCP ``` | ``` / ``` |``` 2001:db8:a::2/64 ``` |



#### Wijzingen / history

VLAN20: subnet naar /28 gewijzigd => grotere range => ip adressen blijven behouden, enkel subnet wijzigt <br/>
Voorstel toegevoegd voor vastleggen van gereserveerde adressen bridged netwerk Nics team-leden <br/>
VLAN50 verwijderd <br/>
