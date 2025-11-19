#!/bin/sh

set -e

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Flash existing rules
iptables -F
iptables -t nat -F
iptables -X

# Default policy drop
iptables -P FORWARD DROP

# Allow the already established and related connections
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Allow only new HTTP connections in the direction outside -> dmz
iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 80 -d 172.18.0.2 -m conntrack --ctstate NEW -j ACCEPT

# Allow only Postgress connections in the direction dmz -> internal (private LAN)
iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 5432 -s 172.18.0.2 -d 172.19.0.2 -m conntrack --ctstate NEW -j ACCEPT

# Allow dmz and internal to initiate connections with the outside network
iptables - A FORWARD -i eth1 -o eth0 -m conntrack --ctstate NEW -j ACCEPT
iptables - A FORWARD -i eth2 -o eth0 -m conntrack --ctstate NEW -j ACCEPT

# Change the source address of a packet sent by dmz or internal to outsize using NAT
iptables -t nat -A POSTROUTING -o eth0 -s 172.18.0.0/24 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -s 172.19.0.0/24 -j MASQUERADE

# Accept traffic to firewall itself (for management)
iptables -A INPUT -i lo -J ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# show rules
iptables -L -n -v
iptables -t nat -L -n -v

# Keep container running
/bin/sh
