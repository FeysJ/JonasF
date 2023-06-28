
# Configuration

**Router:**

**<u>R1:</u>**

hostname R1

no ip domain-lookup

service password-encryption

banner motd ! Unauthorized access is not allowed. !

enable secret changeme

line con 0

password changeme

login

exit

ip access-list extended surfing
Remark permits inside HTTP, HTTPS and access to DC
permit ip 192.168.168.64 0.0.0.63 host 192.168.168.130
permit tcp 192.168.168.64 0.0.0.63 any eq www
permit tcp 192.168.168.64 0.0.0.63 any eq 443
permit udp any any eq bootpc
permit udp any any eq bootps

exit

ip nat inside source list 1 interface G0/0/0
access-list 1 permit 192.168.168.128 0.0.0.15

ip nat inside source list 2 interface G0/0/0
access-list 2 permit 192.168.168.0 0.0.0.63

ip nat inside source list 3 interface G0/0/0
access-list 3 permit 192.168.168.64 0.0.0.63

interface g0/0/1.20
description subinterface internal servers
encapsulation dot1q 20
ip address 192.168.168.129 255.255.255.240
ip nat inside

interface g0/0/1.30
description subinterface crew
encapsulation dot1q 30
ip address 192.168.168.1 255.255.255.192
ip helper-address 192.168.168.130
ip nat inside

interface g0/0/1.40
description subinterface cast
encapsulation dot1q 40
ip address 192.168.168.65 255.255.255.192
ip helper-address 192.168.168.130
ip access-group surfing in
ip nat inside

interface g0/0/1
description trunk link naar switch
no shut
exit

interface G0/0/0
ip address dhcp
ip nat outside
no shut

exit

ip route 0.0.0.0 0.0.0.0 G0/0/0

**Switch:**

**<u>S1:</u>**

hostname S1

no ip domain-lookup

service password-encryption

banner motd ! Unauthorized access is not allowed. !

enable secret changeme

line con 0

password changeme

login

exit

vlan 20
name internal_servers
vlan 30
name crew
vlan 40
name cast

exit

interface range  f0/1-8
switchport mode access
switchport access vlan 20

interface range  f0/9-16
switchport mode access
switchport access vlan 30

interface range  f0/17-22
switchport mode access
switchport access vlan 40

interface range f0/23-24
switchport mode trunk
switchport trunk allowed vlan 20,30,40






