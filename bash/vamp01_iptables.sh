#!/bin/sh
# My system IP/set ip address of server
SERVER_IP="216.80.73.59"

ETRUSTED_IP=(
	12.9.124.2
	12.38.190.9
	12.38.190.5
	12.170.156.2
	12.170.156.10
	12.176.230.9
	12.176.230.5
	12.176.231.222
	12.234.191.130
	46.38.177.228
	46.38.177.232
	46.38.177.233
	59.167.20.161
	89.202.128.66
	94.56.197.146
	115.112.129.34
	120.29.155.251
	180.150.142.148
	180.150.142.148
	182.71.38.26
	189.8.29.19
	190.111.231.97
	190.210.214.58
	195.143.93.212
	209.167.35.5
	209.202.126.186	
)

# Flushing all rules
iptables -F
iptables -X

# Setting default filter policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
 
 
# Allow ICMP traffic for ping tests only
iptables -A INPUT -p icmp -m icmp --icmp-type 0 -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT



# Allow web traffic when needed:
iptables -A INPUT -p tcp -s 0/0 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --dport 8000 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp -s 0/0 --dport 8443 -j ACCEPT


# Allow SSH for trusted IPs
# using array from the begining of this file
for iplist in ${ETRUSTED_IP[*]}; do
  iptables -A INPUT -p tcp -s $iplist -d $SERVER_IP --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
done




# Backup up last saved config
mv /etc/sysconfig/iptables.save /etc/sysconfig/iptables.save.bak
 
# Save the latest config
echo 'Saving new config to /etc/sysconfig/iptables.save'
iptables-save > /etc/sysconfig/iptables.save
 
 
# Update real iptables file
echo 'Updating /etc/sysconfig/iptables'
/etc/init.d/iptables save


# Restart firewall
/etc/init.d/iptables restart






#
# EOF
