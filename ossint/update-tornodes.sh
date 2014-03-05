#!/bin/bash

# update-tornodes.sh
# Matthew Ulm
# 2014-03-05

# This script will gather a listing of the TOR node IPs and will merge them
# all into a single CSV file, that can be uploaded into a SIEM, IDS, or other
# network detection/ analysis device.

# Commands used:
# touch, echo, wget, cat, wc, grep, sort, uniq, zip, cp, mv, date


# TO DO:
# check the 5'th, 10'th and 11'th lists to see if they are back online.
# At this tiem tehy are eitther blocking or have gone off line.
# the 11'th can tell I am a script, so will need to work around that.

# let's get started
# create our working files
echo "script started at $(date)" >> working.tor.list.log
touch working.tor.list.log
touch working.tor.list.csv

# start our log of activities
echo "-------" >> working.tor.list.log
echo "Working on our TOR node list" >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# first list:
echo "Getting our first list" >> working.tor.list.log
echo "https://www.dan.me.uk/torlist/" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget --no-check-certificate  https://www.dan.me.uk/torlist/ -O ukdan.list
cat ukdan.list >> working.tor.list.csv
echo "current working count is:" >> working.tor.list.log
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# second list
echo "getting our second list" >> working.tor.list.log
echo "http://torstatus.blutmagie.de/ip_list_all.php/Tor_ip_list_ALL.csv" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget http://torstatus.blutmagie.de/ip_list_all.php/Tor_ip_list_ALL.csv -O german-site-all.list
cat german-site-all.list >> working.tor.list.csv
echo "current working count is:" >> working.tor.list.log
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# third list
echo "getting our third list" >> working.tor.list.log
echo "https://check.torproject.org/exit-addresses" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget https://check.torproject.org/exit-addresses -O from-tor-site.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> working.tor.list.log
echo "-------" >> working.tor.list.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' from-tor-site.list >> iponly-from-tor-site.list
cat iponly-from-tor-site.list >> working.tor.list.csv
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# fourth list
echo "getting our fourth list" >> working.tor.list.log
echo "http://en.wikipedia.org/wiki/Category:Blocked_Tor_exit_nodes" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget http://en.wikipedia.org/wiki/Category:Blocked_Tor_exit_nodes -O wikipedia.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> working.tor.list.log
echo "-------" >> working.tor.list.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' wikipedia.list >> iponly-wikipedia.list
cat iponly-wikipedia.list >> working.tor.list.csv
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# fifth list
echo "The fifth list appears to be down at this time." >> working.tor.list.log
echo "It has been commented out for now." >> working.tor.list.log
#echo "getting our fifth list" >> working.tor.list.log
echo "http://tornode.webatu.com/" >> working.tor.list.log
echo "-------" >> working.tor.list.log
#wget http://tornode.webatu.com/ -O tornode.list
#cat tornode.list >> working.tor.list.csv
#wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# sixth list
echo "getting our sixth list" >> working.tor.list.log
echo "http://www.enn.lu/status/" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget http://www.enn.lu/status/ -O ennlu.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> working.tor.list.log
echo "-------" >> working.tor.list.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ennlu.list >> iponly-ennlu.list
cat iponly-ennlu.list >> working.tor.list.csv
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# seventh list
echo "getting the seventh list now" >> working.tor.list.log
echo "https://gitweb.torproject.org/tor.git/blob/HEAD:/src/or/config.c#l819" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget --no-check-certificate https://gitweb.torproject.org/tor.git/blob/HEAD:/src/or/config.c#l819 -O gist.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> working.tor.list.log
echo "-------" >> working.tor.list.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' gist.list >> iponly-gist.list
# This list gives some no valid nu,bers that pass the IP sniff test.
# this next grep will clean out not routable IP addresses.
echo "removing non-internet routabel IP addresses." >> working.tor.list.log
echo "This will also remove any IP addres in the 0.0.0.0/8 range, as these are reservered for the IETF." >> working.tor.list.log
echo "-------" >> working.tor.list.log
grep -E -v '(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^0.)' iponly-gist.list >> validated-iponly-gist.list
cat validated-iponly-gist.list >> working.tor.list.csv
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# eighth list
# this one might have some copyright issues with it.
# As a precaution the copyright is included at the bottom of this script.
# please make sure to read and understand this copyright.
echo "getting list number eight now" >> working.tor.list.log
echo "http://rules.emergingthreats.net/blockrules/emerging-tor.rules" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget http://rules.emergingthreats.net/blockrules/emerging-tor.rules -O emergingthreats.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> working.tor.list.log
echo "-------" >> working.tor.list.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' emergingthreats.list >> iponly-emergingthreats.list
cat iponly-emergingthreats.list >> working.tor.list.csv
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# ninth list
echo "getting the ninth list now"
echo "http://hqpeak.com/torexitlist/free/?format=json" >> working.tor.list.log
echo "-------" >> working.tor.list.log
wget http://hqpeak.com/torexitlist/free/?format=json -O hqpeak.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> working.tor.list.log
echo "-------" >> working.tor.list.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' hqpeak.list >> iponly-hqpeak.list
cat iponly-hqpeak.list >> working.tor.list.csv
wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# tenth list
# i think this site has blocked me for trying to pull this list too often.
# for now it is not working.
echo "getting our tenth list now"
echo "http://blog.bannasties.com/2013/04/ips-blocked-as-tor-exit-nodes/" >> working.tor.list.log
echo "-------" >> working.tor.list.log
#wget http://blog.bannasties.com/2013/04/ips-blocked-as-tor-exit-nodes/ -O bannsitesblog.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
#echo "removing non-IP address information from current file" >> working.tor.list.log
echo "-------" >> working.tor.list.log
#grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' bannsitesblog.list >> iponly-bannsitesblog.list
#cat iponly-bannsitesblog.list >> working.tor.list.csv
#wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# list number eleven
echo "grabbing the final list now"
echo "http://proxy.org/proxies_sorted2.shtml" >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "This list can tell I am a script and not a human, so for now it will be disabled" >> working.tor.list.log
#wget http://proxy.org/proxies_sorted2.shtml -O proxyorg.list
#cat proxyorg.list >> working.tor.list.csv
#wc -l working.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log



# OK, at this point we need to start sorting our list adn removing any duplicates
echo "Now, I am going to sort our list that we have been working on" >> working.tor.list.log
sort working.tor.list.csv >> sorted.tor.list.csv
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "Now, we will remove any duplicates in the list, using uniq." >> working.tor.list.log
echo "before removing duplicates.:" >> working.tor.list.log
wc -l sorted.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "After pulling out dumplicates:" >> working.tor.list.log
uniq sorted.tor.list.csv >> clean.tor.list.csv
wc -l clean.tor.list.csv >> working.tor.list.log
echo "-------" >> working.tor.list.log
echo "-------" >> working.tor.list.log


# Now, we need to grab all of our files, and zip them up for long term storage.
# I am using zip, since that is more common on windows systems.
zip csv-files.zip *.csv
rm -rf *.csv
zip list-files.zip *.list
rm -rf *.list
# this will create our final zip file, and will date stamp the file.
# this will help us go back and find when an IP was added to our lists.
zip tor-nodes-$(date +%F).zip csv-files.zip list-files.zip working.tor.list.log
# clean up our remaining files
rm -rf csv-files.zip
rm -rf list-files.zip
rm -rf working.tor.list.log
# EOS



# This copyright notice is included for using the emerging threats rule.
#*************************************************************
#
#  Copyright (c) 2003-2013, Emerging Threats
#  All rights reserved.
#  
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the 
#  following conditions are met:
#  
#  * Redistributions of source code must retain the above copyright notice, this list of conditions and the following 
#    disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the 
#    following disclaimer in the documentation and/or other materials provided with the distribution.
#  * Neither the name of the nor the names of its contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND ANY EXPRESS OR IMPLIED WARRANTIES, 
#  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
#  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
#  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
#
#




# EOF
