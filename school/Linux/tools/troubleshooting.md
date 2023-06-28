---
title: 'Troubleshooting a network service'
---

A checklist for troubleshooting a network service running on RHEL/CentOS 7. Basic knowledge of TCP/IP is assumed (addressing, port numbers, main protocols, etc.)

# TL;DR Checklist

Status: `journalctl -fu dhcpd.service`

1. Link layer
    - Check the cable/port LEDs
2. Network layer
    - `ip a`
    - `ip r` (+ ping default gw)
    - is er een DNS-server? `cat /etc/resolv.conf` (+ `dig www.google.com @a.b.c.d +short`)
    - `sudo nmcli device reapply eth1`
    - /etc/sysconfig/network-scripts/ => ip correct? ON_BOOT staat on?
    - controle config files => ip correct? PORT correct? 
    - ubuntu: `sudo ifconfig eth0 192.168.72.6 netmask 255.255.255.0`
    - ubuntu: `sudo route add default gw 192.168.72.1 eth0`
3. Transport layer
    - `sudo systemctl status SERVICE.service`
        - `sudo systemctl start SERVICE.service`
        - `sudo systemctl enable SERVICE.service`
    - `sudo ss -tlnp`
    - `sudo firewall-cmd --list-all`
        - `sudo firewall-cmd --add-service=SERVICE --permanent`
        - `sudo firewall-cmd --add-port=PORT/tcp --permanent`
        - `sudo systemctl restart firewalld`
4. Application layer
    - `sudo journalctl -f -u SERVICE.service`
    - `sudo systemctl restart SERVICE.service` (after each config file change)
    - controle readpermissies in /var/www/html op website: `chmod 644 FILE`
    - `sudo chcon -t httpd_sys_content_t test.php`
    - `restorecon -R /var/www/`
    - `sudo setsebool -P httpd_can_network_connect_db on`

# SELinux File labeling

`ls -lZ`
user:role:type:level

*type wijzigen*
indien hoofdmap reeds bestaat bvb: `restorecon -R /var/www/`
file: `chcon -t httpd_sys_content_t file-name`
directory: `chcon -R -t httpd_sys_content_t directory-name`

*user en type wijzigen*
write changes: `semanage fcontext -a -s system_u -t httpd_sys_content /usr/local/foo.txt`
apply changes: `restorecon -vF /usr/local/foo.txt`

# controle van eigenaar en rechten map/file

`ls -al`
indien nodig wijzigen met `chown` en `chmod`

## Controle Boolean

lijst: `getsebool -a`
voor db: `setsebool -P httpd_can_network_connect_db on`

