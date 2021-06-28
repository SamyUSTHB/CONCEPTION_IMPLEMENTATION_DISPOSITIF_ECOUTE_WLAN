#!/bin/bash

cvlc alsa://plughw:2 --sout '#transcode{acodec=mp3,ab=64,channels=1}:standard{access=http,dst=0.0.0.0:8888/ecoute.mp3}' & >/dev/null
echo "http://192.168.0.253:8888/ecoute.mp3"
echo "touch any key to stop"
read
killall cvlc
