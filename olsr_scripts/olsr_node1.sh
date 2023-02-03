#!/bin/bash

# Config mode ad-hoc
sudo systemctl stop dhcpcd
# Disable and configure wlan0
sudo ip link set wlan0 down
sudo ifconfig wlan0 mtu 1500
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 essid "olsr-network"
sudo iwconfig wlan0 ap any
sudo iwconfig wlan0 channel 1
sleep 3s
sudo ip link set wlan0 up
sleep 3s
sudo ifconfig wlan0 20.0.0.11/24
sleep 3s
#start_olsrd
sudo olsrd -i wlan0
