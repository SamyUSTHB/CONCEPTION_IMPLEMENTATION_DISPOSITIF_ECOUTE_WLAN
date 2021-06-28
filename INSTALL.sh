#!/bin/bash

sudo apt-get install vlc python3 python3-pip hostapd dnsmasq php5 tcpdump dsniff xvfb sshpass bridge-utils alsa-base alsa-utils usbmuxd scapy -y
sudo pip3 install selenium scapy

##########################################################################
################### INSTALLATION DES DRIVER WLAN  ######################## 
sudo wget http://downloads.fars-robotics.net/wifi-drivers/install-wifi -O /usr/bin/install-wifi
sudo chmod +x /usr/bin/install-wifi
sudo install-wifi

##########################################################################
#####################  INSTALLATION DU DYNDNS  ########################### 
wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz
tar vzxf noip-duc-linux.tar.gz
cd noip-2.1.9-1
sudo make
sudo make install




##########################################################################
#################  CONFIGURATION DES INTERFACE  ########################## 
sudo -i
echo "
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

iface eth0 inet manual

allow-hotplug wlan0
iface wlan0 inet static
    address 192.168.1.253
    netmask 255.255.255.0
    gateway 192.168.1.1
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

allow-hotplug wlan1
iface wlan1 inet static
    address 10.0.0.1
    netmask 255.255.255.0
    network 10.0.0.0
    broadcast 10.0.0.255">/etc/network/interfaces

sudo echo "denyinterfaces wlan0" >> /etc/dhcpcd.conf
sudo echo "denyinterfaces wlan1" >> /etc/dhcpcd.conf
sudo echo "denyinterfaces eth0" >> /etc/dhcpcd.conf

###########################################################################
#####################  CONFIGURATION SYSTEM  ############################## 
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6=1"  >> /etc/sysctl.conf

###########################################################################
#####################  CONFIGURATION DNSMASQ  ############################# 
echo "
interface=wlan1
listen-address=10.0.0.1 
bind-interfaces 
server=8.8.8.8 
domain-needed 
bogus-priv 
dhcp-range=10.0.0.2,10.0.0.254,12h
" > /etc/dnsmasq.conf

#####################  CONFIGURATION HOSTAPD  ############################ 
echo "DAEMON_CONF="/etc/hostapd.conf"" >> /etc/default/hostapd

sudo update-rc.d hostapd enable
sudo update-rc.d dnsmasq enable