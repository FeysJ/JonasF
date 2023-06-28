# Begeleidend schrijven PT-simulatie netwerkinfrastructuur thematrix.local

## Vlan Switch
### Gegevens
- Passwords
    - priveleged exec mode: Ti02 ( Switch(config)#enable secret Ti02 )
    - global configuration mode: Ti02conf ( Switch(config)#enable password Ti02conf )
        - encryptie enable passwords ( Switch(config)# service password-encryption )
    - vty lijnen : Ti02remote 
            ( VlanSwitch(config)#  line vty 0 4
            VlanSwitch(config-line)#password Ti02remote
            VlanSwitch(config-line)#login
            VlanSwitch(config-line)#exit )

 | user | paswoord | cmd |
 | ---- | -------- | - |
 | joost | joostDC |  VlanSwitch(config)# username Joost secret JoostDC |

- Instellingen
    - Hostname: VlanSwitch ( Switch(config)#hostname VlanSwitch )
    - DNS lookup disabled ( Switch(config)#no ip domain-lookup ) 
    - Motd: "Access only for members of Ti02" ( Switch(config)# banner motd $Access only for members of Ti02$ )
    - encryptie enable passwords ( VlanSwitch(config)# service password-encryption )
    - 

- Vlan configuratie ports

| vlan | name | ports |
| ---- | -------- | - |
| 20 | servers |  FastEthernet0/1 - 4 |
| 30 | crew |  FastEthernet0/4 - 8 |
| 40 | cast |  FastEthernet0/9 - 12 |
| trunk | - |  FastEthernet0/23 - 24 |

- management vlan

- native vlan

| vlan | trunkport | / |
| ---- | -------- | - |
| 101 | FastEthernet0/23-24 |  F |




    


