#!/bin/bash

sudo iptables -t raw -A PREROUTING -m mac --mac-source 00:c0:ca:5a:27:8a -j DROP
sudo iptables -t raw -A PREROUTING -m mac --mac-source 00:c0:ca:5a:27:87 -j DROP
sudo iptables -t raw -A PREROUTING -m mac --mac-source 00:c0:ca:98:63:4b -j DROP
