#!/bin/bash

# Activate batman-adv
sudo modprobe batman-adv
# Disable and configure wlan0
sudo ip link set wlan0 down
sudo ifconfig wlan0 mtu 1500
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 essid "batman-network"
sudo iwconfig wlan0 ap any
sudo iwconfig wlan0 channel 1
sleep 3s
sudo ip link set wlan0 up
sleep 3s
sudo batctl if add wlan0
sleep 3s
sudo ifconfig bat0 up
sleep 3s
sudo ifconfig bat0 10.0.0.14/24
