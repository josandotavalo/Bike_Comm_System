#!/bin/bash

# Configuracion modo ad-hoc
sudo systemctl daemon-reload
sudo systemctl stop dhcpcd
sudo ip link set wlan0 down
sudo ifconfig wlan0 mtu 1500
sudo iwconfig wlan0 mode ad-hoc
sudo iwconfig wlan0 essid "batman_network"
sudo iwconfig wlan0 ap any
sudo iwconfig wlan0 channel 6
sudo iwconfig wlan0 txpower 30
sudo ip link set wlan0 up

# BATMAN-adv
sudo modprobe batman-adv
sudo batctl if add wlan0
sudo ifconfig bat0 up
sudo ifconfig bat0 10.0.0.1/24
