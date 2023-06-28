---
title: 'Usefull stuff'
---

create custom wordlist: `crunch`
   - `crunch 6 8 abcdef -o custom.txt`


# Password cracking

## John  the Ripper

```
zip2john wifi-captures.zip > hash.txt
john hash.txt
```

## Wifi

### WEP
```
aircrack-ng -n 64 wep-easy-01.ivs
aircrack-ng -n 128 wep-medium-01.ivs
```

### WPA
```
aircrack-ng -w rockyou.txt wpa-easy-01.cap
aircrack-ng -w custom.txt wpa-medium-01.cap
```