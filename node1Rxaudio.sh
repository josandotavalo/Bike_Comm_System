#!/bin/bash

sudo tcpdump -vvv -tt -i wlan1 -U -w ./node1Rxolsr.pcap &

sleep 1s

ffplay -probesize 1000 udp://10.0.0.22:1234

sleep 1s

pid=$(ps -e | pgrep tcpdump)
echo "========= PID: "$pid" ========="
sleep 2s
kill -2 $pid

exit
