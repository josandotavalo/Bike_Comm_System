#!/bin/bash

sudo iptables -t raw -A PREROUTING -m mac --mac-source 00:c0:ca:5a:27:87 -j DROP
sudo iptables -t raw -A PREROUTING -m mac --mac-source 00:c0:ca:98:63:4b -j DROP

sudo ip route add 10.0.0.1 via 10.0.0.1 dev bat0 metric 2 onlink
sudo ip route add 10.0.0.12 via 10.0.0.12 dev bat0 metric 2 onlink
sudo ip route add 10.0.0.13 via 10.0.0.12 dev bat0 metric 2 onlink
sudo ip route add 10.0.0.14 via 10.0.0.12 dev bat0 metric 2 onlink

# server
sudo iptables -t raw -A PREROUTING -m mac --mac-source 46:65:c8:12:a0:32 -j ACCEPT
# node 2
sudo iptables -t raw -A PREROUTING -m mac --mac-source 2a:bc:23:03:1b:47 -j ACCEPT

# node 3
sudo iptables -t raw -A PREROUTING -m mac ! --mac-source 5a:5f:45:fe:3f:34 -j DROP
# node 4
sudo iptables -t raw -A PREROUTING -m mac ! --mac-source da:a3:4d:ce:4d:fc -j DROP
