#!/bin/bash

# Flush Current Rules
iptables -F

# Grab Cloudflare IPs
ip_ranges=$(curl -s https://www.cloudflare.com/ips-v4)
ip_ranges6=$(curl -s https://www.cloudflare.com/ips-v6)

# Set IPtable
for ip in $ip_ranges; do
 iptables -A INPUT -p tcp -m multiport --dports http,https -s $ip -j ACCEPT
done

for ip in $ip_ranges6; do
 ip6tables -A INPUT -p tcp -m multiport --dports http,https -s $ip -j ACCEPT
done
