#!/bin/bash

sudo tcpdump -vvv -tt -i wlan1 -U -w ./node1Txolsr.pcap &

sleep 1s

ffmpeg -f alsa -i plughw:1,0 -t 150 -acodec aac -ac 1 -b:a 200k -f mpegts udp://10.0.0.22:1235

sleep 1s

pid=$(ps -e | pgrep tcpdump)
echo "========= PID: "$pid" ========="
sleep 2s
kill -2 $pid

exit
