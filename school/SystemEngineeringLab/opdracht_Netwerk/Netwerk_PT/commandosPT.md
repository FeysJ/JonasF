# Commando's vlanconfiguratie

## Vlan creation
VlanSwitch(config)#vlan 20 <br/>
VlanSwitch(config-vlan)#name servers <br/>
VlanSwitch(config)#vlan 30 <br/>
VlanSwitch(config-vlan)#name crew <br/>
VlanSwitch(config-vlan)#vlan 40 <br/>
VlanSwitch(config-vlan)#name cast <br/>
<br/>

## Management vlan
S1(config)# interface vlan 100 <br/>
S1(config-if)# ip add 192.168.x.X 255.255.255.0 <br/>
S1(config-if)# no shutdown <br/>
S1(config-if)# exit <br/>
S1(config)# ip default-gateway 192.168.X.X <br/>
S1(config)# <br/>

## native vlan
zie configuratie Trunk-ports

## Access-ports toekennen aan vlans:
VlanSwitch(config)#interface range FastEthernet0/1 - 4 <br/>
VlanSwitch(config-if-range)#switchport mode access  <br/>
VlanSwitch(config-if-range)#switchport access vlan 20 <br/>
VlanSwitch(config-if-range)#no shutdown <br/>
VlanSwitch(config)#interface range FastEthernet0/5 - 8 <br/>
VlanSwitch(config-if-range)#switchport mode access  <br/>
VlanSwitch(config-if-range)#switchport access vlan 30 <br/>
VlanSwitch(config-if-range)#no shutdown <br/>
VlanSwitch(config-if-range)#interface range FastEthernet0/9 - 12 <br/>
VlanSwitch(config-if-range)#switchport mode access  <br/>
VlanSwitch(config-if-range)#switchport access vlan 40 <br/>
VlanSwitch(config-if-range)#no shutdown <br/>

## Trunk-port aanmaken 
VlanSwitch(config-if-range)# interface range Fastethernet0/23-24 <br/>
VlanSwitch(config-if-range)#switchport mode trunk <br/>
VlanSwitch(config-if-range)#switchport trunk native vlan 101 <br/>
VlanSwitch(config-if-range)#switchport trunk allowed vlan 20,30,40,100,101
VlanSwitch(config-if-range)#no shutdown <br/>

## Intervlan routering via router on a stick

Router(config)#interface gigabitEthernet0/0/1.20 <br/>
Router(config-subif)#description  Default gateway for servers <br/>
Router(config-subif)#encapsulation dot1Q 20 <br/>
Router(config-subif)#ip address 192.168.168.129 255.255.255.240 <br/>
Router(config-subif)#exit<br/><br/>

Router(config)#interface gigabitEthernet0/0/1.30<br/>
Router(config-subif)#description Default gateway for crew<br/>
Router(config-subif)#encapsulation dot1Q 30<br/>
Router(config-subif)#ip address 192.168.168.1 255.255.255.192<br/>
Router(config-subif)#exit<br/><br/>

Router(config)#interface gigabitEthernet0/0/1.40<br/>
Router(config-subif)#description Default gateway for cast<br/>
Router(config-subif)#encapsulation dot1Q 40<br/>
Router(config-subif)#ip address 192.168.168.65 255.255.255.192<br/>
Router(config-subif)#exit<br/><br/>

Router(config)#interface gigabitEthernet0/0/1 <br/>
Router(config-if)#description trunk line to vlan-switch <br/>
Router(config-if)#no shutdown <br/><br/>


<# nog iet in PT gedaan
Router(config)# hostname R_on_stick
R_On_Stick(config)#enable secret Ti02
R_On_Stick(config)#enable password Ti02conf
R_On_Stick(config)#line vty 0 4 
R_On_Stick(config-line)# password Ti02remote 
R_On_Stick(config-line)# login 
R_On_Stick(config-line)# transport input ssh telnet 
R_On_Stick(config-line)# exit 
R_On_Stick(config)# service password-encryption 
R_On_Stick(config)# banner motd $Access only for members of Ti02$
#>

## ACLs op router on a stick
vlan30 (crew): enkel enkel http, https en internal servers <br/>  <br/>
R1(config)# ip access-list extended Vlan30Crew <br/>
R1(config-ext-nacl)# <br/>
    Remark laat surfen toe vanuit vlan crew<br/>
    permit tcp 192.168.168.0 0.0.0.63 any eq www<br/>
    permit tcp 192.168.168.0 0.0.0.63 any eq 443<br/>
    Remark laat access tot servers netwerk toe vanuit vlan crew<br/>
    permit tcp 192.168.168.0 0.0.0.63 192.168.168.128 0.0.0.15<br/>
    exit<br/><br/><br/>
vlan40 (cast): enkel http en https, enkel naar DC <br/> <br/>
R1(config)# ip access-list extended Vlan40Cast <br/>
R1(config-ext-nacl)# <br/>
    Remark laat surfen toe vanuit vlan cast<br/>
    permit tcp 192.168.168.64 0.0.0.63 any eq www<br/>
    permit tcp 192.168.168.64 0.0.0.63 any eq 443 <br/>
    expliciet deny naar netwerk servers<br/>
    deny tcp 192.168.168.64 0.0.0.63 192.168.168.128 0.0.0.15<br/>
    exit<br/>

R1(config)# interface gigabitEthernet0/0/1.30<br/>
R1(config-if)# ip access-group Vlan30Crew in<br/>
R1(config-if)# end<br/>
R1(config)# interface gigabitEthernet0/0/1.40<br/>
R1(config-if)# ip access-group Vlan40Cast in<br/>
R1(config-if)# end<br/>

## Configureren van Router als DHCPv4 relay agent
voorzien van ip helper-address adressen op de sub-interfaces om broadcasts (voor dhcp) te forwarden vanuit crew of cast naar DC:<br/><br/>
R1(config)# interface gigabitEthernet0/0/1.30<br/>
R1(config-if)# ip helper-address 192.168.168.130<br/>
R1(config)# interface gigabitEthernet0/0/1.40<br/>
R1(config-if)# ip helper-address 192.168.168.130<br/>

# open vragen / to do
- Met show interfaces fastethernet0/23 switchport zie ik "trunking native mode vlan Vlan: 101 (inactive)<br/>
Is dit doordat er nog geen connectie is op de port? (operational mode = down)
- management vlan nog verder bekijken

