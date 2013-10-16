#!/bin/sh
# My system IP/set ip address of serve
SERVER="192.168.80.174"
mike="192.168.80.81"
tim="192.168.80.120"
Fred="192.168.80.201"
DNS1="192.168.80.205"
DNS2="192.168.80.206"
sue="192.168.80.24"

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


#
# Allow ICMP Traffic
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
 
# Allow incoming ssh
iptables -A INPUT -p tcp -s $mike -d $SERVER --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $mike --sport 22 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s $sue -d $SERVER --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $sue --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Allow incoming http
iptables -A INPUT -p tcp -s 192.168.80.0/24 -d $SERVER --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.80.0/24 -d $SERVER --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d 192.168.80.0/24 --sport 80 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d 192.168.80.0/24 --sport 443 -m state --state ESTABLISHED -j ACCEPT


# Allow nessusd connections from specialized hosts only
iptables -A INPUT -p tcp -s $mike -d $SERVER --dport 8443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $mike --sport 8443 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s $tim -d $SERVER --dport 8443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $tim --sport 8443 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s $Fred -d $SERVER --dport 8443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $Fred --sport 8443 -m state --state ESTABLISHED -j ACCEPT


# Allow metasploit GUI connections from specialized hosts only
iptables -A INPUT -p tcp -s $mike -d $SERVER --dport 7443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $mike --sport 7443 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s $tim -d $SERVER --dport 7443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $tim --sport 7443 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s $Fred -d $SERVER --dport 7443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $Fred --sport 7443 -m state --state ESTABLISHED -j ACCEPT
# Allow metasploit RPCd connections from specified hosts only
iptables -A INPUT -p tcp -s $mike -d $SERVER --dport 55553 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $mike --sport 55553 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s $tim -d $SERVER --dport 55553 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $tim --sport 55553 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s $Fred -d $SERVER --dport 55553 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d $Fred --sport 55553 -m state --state ESTABLISHED -j ACCEPT
#
# Allow Metasploit scanners and shells back
#
### Allow metasploit connect back shells on specified ports only
iptables -A INPUT -p tcp -s 192.168.80.0/24 -d $SERVER --dport 8000:8100 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER -d 192.168.80.0/24 --sport 8000:8100 -m state --state NEW,ESTABLISHED -j ACCEPT
### Checking SMB Services
iptables -A OUTPUT -p tcp -s $SERVER -d 192.168.80.0/24 --dport 445 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.80.0/24 -d $SERVER --sport 445 -m state --state NEW,ESTABLISHED -j ACCEPT


#
# Allow DNS traffic to specified hosts
iptables -A OUTPUT -p udp -d $DNS1 --dport 53 -j ACCEPT
iptables -A INPUT -p udp -s $DNS1 --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp -d $DNS2 --dport 53 -j ACCEPT
iptables -A INPUT -p udp -s $DNS2 --sport 53 -j ACCEPT

iptables -A INPUT -p UDP --sport domain -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p TCP --sport domain -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p UDP --dport domain -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p TCP --dport domain -m state --state NEW,ESTABLISHED -j ACCEPT


#
# Allow outbound Web traffic
iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 80 -m state --state NEW,ESTABLISHED -j ACCEPT


# make sure nothing else comes in of this box
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP


# log dropped packets
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
iptables -A LOGGING -j DROP


