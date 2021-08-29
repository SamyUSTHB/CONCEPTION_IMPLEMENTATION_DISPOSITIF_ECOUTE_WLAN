#!/bin/bash
clear
sudo sysctl net.ipv4.ip_forward=1

ssid=$(cat /root/.BACKDOOR/PERSISTANCE/CONFIG.txt | cut -d ':' -f 2)
password=$(cat /root/.BACKDOOR/PERSISTANCE/CONFIG.txt | cut -d ':' -f 3)

# CONFIGURATION DU POINT D'ACCES WLAN
echo "
interface=wlan1
driver=nl80211
ssid=$ssid
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_passphrase=$password
rsn_pairwise=CCMP
"> /etc/hostapd.conf


#STARTING AP
sudo systemctl force-reload hostapd

exit

# FORWARDING NETWORK
iptables --flush
sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -A FORWARD -i wlan0 -o wlan1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan1 -o wlan0 -j ACCEPT

