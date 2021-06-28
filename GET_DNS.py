#!/usr/bin/env python3
from scapy.all import *
import os

os.system('clear')
interface=os.popen("ip route get 8.8.8.8 | awk -- '{printf $5}'").read()
def DNSSNIFFER(packet):
	if IP in packet:
		if packet.haslayer(DNS):
			dns_layer = packet.getlayer(DNS)
			IP_SRC = packet[IP].src
			MAC_SRC = packet[Ether].src
			if dns_layer.qr == 0:
				URL = str(dns_layer.qd.qname)
				URL = URL[2:-2]
				data=MAC_SRC+","+IP_SRC+","+URL
				#with open("all.log", mode="a") as f:
				#	f.write(data+"\n")
				data = MAC_SRC+" | "+IP_SRC+" --> "+str(URL)
				print(data)

while True:
    try:
        sniff(filter="port 53", prn=DNSSNIFFER, timeout=3) 
    except:
        pass

