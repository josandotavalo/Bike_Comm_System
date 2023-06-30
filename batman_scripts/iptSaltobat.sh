#!/bin/bash

sudo iptables -t raw -A PREROUTING -m mac --mac-source 4a:00:e0:99:00:ff -j DROP
sudo iptables -t raw -A PREROUTING -m mac --mac-source a2:06:47:00:29:ef -j DROP
sudo iptables -t raw -A PREROUTING -m mac --mac-source 7a:e4:7d:62:2c:c6 -j DROP

sudo ip route add 10.0.0.11 via 10.0.0.11 dev bat0 metric 2 onlink
sudo ip route add 10.0.0.12 via 10.0.0.11 dev bat0 metric 2 onlink
sudo ip route add 10.0.0.13 via 10.0.0.11 dev bat0 metric 2 onlink
sudo ip route add 10.0.0.14 via 10.0.0.11 dev bat0 metric 2 onlink

# node 1
sudo iptables -t raw -A PREROUTING -m mac --mac-source e2:db:2e:0a:89:d5 -j ACCEPT
# pc no cambiar
sudo iptables -t raw -A PREROUTING -m mac --mac-source a0:88:69:bc:4d:96 -j ACCEPT
# tablet no cambiar
sudo iptables -t raw -A PREROUTING -m mac --mac-source e0:d0:83:87:68:41 -j ACCEPT
# pc nancy no cambiar
sudo iptables -t raw -A PREROUTING -m mac --mac-source b4:6d:83:1d:f9:bb -j ACCEPT

# node 2
sudo iptables -t raw -A PREROUTING -m mac ! --mac-source 2a:bc:23:03:1b:47 -j DROP
# node 3
sudo iptables -t raw -A PREROUTING -m mac ! --mac-source 5a:5f:45:fe:3f:34 -j DROP
# node 4
sudo iptables -t raw -A PREROUTING -m mac ! --mac-source da:a3:4d:ce:4d:fc -j DROP
