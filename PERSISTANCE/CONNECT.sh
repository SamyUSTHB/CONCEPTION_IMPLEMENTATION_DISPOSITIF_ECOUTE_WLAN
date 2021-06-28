#!/bin/bash

# TESTER LE NOMBRE D'ARGUMENT
if [ ! $# -eq 2 ]; then
    clear
    echo "USAGE: CONNECT.sh [SSID] [PASS]"
    exit 1
fi

# ECRIRE LA NOUVELLE CONFIGURATION
echo "
country=DZ
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
ssid="\"$1\""
psk="\"$2\""
}
" > /etc/wpa_supplicant/wpa_supplicant.conf

# ARRETER LE GESTIONNAIRE
killall wpa_supplicant
sleep 5
# REDEMARRER LE GESTIONNAIRE AVEC LA NOUVELLE CONFIGURATION
sudo wpa_supplicant -B -c /etc/wpa_supplicant/wpa_supplicant.conf -i wlan0 -D nl80211,wext &