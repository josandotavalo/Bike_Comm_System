#!/bin/bash

# Config mode ad-hoc
sudo systemctl stop dhcpcd
sudo ip link set wlan1 down
sudo ifconfig wlan1 mtu 1500
sudo iwconfig wlan1 mode ad-hoc
sudo iwconfig wlan1 essid "olsr-network"
sudo iwconfig wlan1 ap any
sudo iwconfig wlan1 channel 6
sudo ip link set wlan1 up
sudo ifconfig wlan1 20.0.0.12/24

#start_olsrd
sudo olsrd -i wlan1
