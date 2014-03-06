#!/bin/bash
#
# update-tornodes.sh
# Matthew Ulm
# 2014-03-05
# This script will gather a listing of the TOR node IPs and will merge them
# all into a single CSV file, that can be uploaded into a SIEM, IDS, or other
# network detection/ analysis device.
#
# Commands used:
# touch, echo, wget, cat, wc, grep, sort, uniq, zip, cp, mv, date
#
# TO DO:
# check the 5'th, 10'th and 11'th lists to see if they are back online.
# At this time they are either blocking or have gone off line.
# the 11'th can tell I am a script, so will need to work around that.
# 5: http://tornode.webatu.com/
#
# let's get started
# create our working files and directories, and then move into there for the remainder of the script.
mkdir tornodes
cd tornodes
touch torlist.log
touch working.csv

# start our log of activities
echo "script started at $(date)" >> torlist.log
echo "-------" >> torlist.log
echo "Working on our TOR node list" >> torlist.log
echo "-------" >> torlist.log
echo "-------" >> torlist.log

# Let's get all of the files we are going to work on first.
# we have to do different sets of tasks on each file, as they format things differently.
echo "Getting our first list" >> torlist.log
echo "https://www.dan.me.uk/torlist/" >> torlist.log
wget --no-check-certificate  https://www.dan.me.uk/torlist/ -O ukdan.list
echo "-------" >> torlist.log
echo "getting our second list" >> torlist.log
echo "http://torstatus.blutmagie.de/ip_list_all.php/Tor_ip_list_ALL.csv" >> torlist.log
wget http://torstatus.blutmagie.de/ip_list_all.php/Tor_ip_list_ALL.csv -O german.list
echo "-------" >> torlist.log
echo "getting our third list" >> torlist.log
echo "https://check.torproject.org/exit-addresses" >> torlist.log
wget --no-check-certificate https://check.torproject.org/exit-addresses -O torsite.list
echo "-------" >> torlist.log
echo "getting our fourth list" >> torlist.log
echo "http://en.wikipedia.org/wiki/Category:Blocked_Tor_exit_nodes" >> torlist.log
wget http://en.wikipedia.org/wiki/Category:Blocked_Tor_exit_nodes -O wikipedia.list
echo "-------" >> torlist.log
echo "getting our fifth list" >> torlist.log
echo "http://www.enn.lu/status/" >> torlist.log
wget http://www.enn.lu/status/ -O ennlu.list
echo "-------" >> torlist.log

# Batch 1: UKdan and German site
# Let's start working with, manipulating our files.
# These files are only a listing of IP addresses, so we do not need to do anything more at this time, 
# with these files.
cat ukdan.list >> working.csv
wc -l working.csv >> torlist.log
echo "-------" >> torlist.log
cat german-site-all.list >> working.csv
wc -l working.csv >> torlist.log
echo "-------" >> torlist.log


# Batch 2:
# This grouping of files, requires a bit more processing as the information downloaded, is not in a 
# CSV file format, or contains other information that just an IP list. This next set of commands will
# create an array of these lists, and do the processing we need to strip all non essential data out
# of the files. We will use a FOR loop to go throgh our array.
decalre -a torarray('torsite.list' 'wikipedia.list' 'ennlu.list'
echo "-------" >> torlist.log
echo "-------" >> torlist.log
for list in "${torarray[@]}"
do :
	echo "$list" >> torlist.log
	grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' $list >> working.csv
	wc -l working.csv >> torlist.log
	echo "-----" >> torlist.log
done


# seventh list
echo "getting the seventh list now" >> torlist.log
echo "https://gitweb.torproject.org/tor.git/blob/HEAD:/src/or/config.c#l819" >> torlist.log
echo "-------" >> torlist.log
wget --no-check-certificate https://gitweb.torproject.org/tor.git/blob/HEAD:/src/or/config.c#l819 -O gist.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> torlist.log
echo "-------" >> torlist.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' gist.list >> iponly-gist.list
# This list gives some no valid nu,bers that pass the IP sniff test.
# this next grep will clean out not routable IP addresses.
echo "removing non-internet routable IP addresses." >> torlist.log
echo "This will also remove any IP addres in the 0.0.0.0/8 range, as these are reservered for the IETF." >> torlist.log
echo "-------" >> torlist.log
grep -E -v '(^127\.0\.0\.1)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)|(^0.)' iponly-gist.list >> validated-iponly-gist.list
cat validated-iponly-gist.list >> working.csv
wc -l working.csv >> torlist.log
echo "-------" >> torlist.log
echo "-------" >> torlist.log


# eighth list
# this one might have some copyright issues with it.
# As a precaution the copyright is included at the bottom of this script.
# please make sure to read and understand this copyright.
echo "getting list number eight now" >> torlist.log
echo "http://rules.emergingthreats.net/blockrules/emerging-tor.rules" >> torlist.log
echo "-------" >> torlist.log
wget http://rules.emergingthreats.net/blockrules/emerging-tor.rules -O emergingthreats.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> torlist.log
echo "-------" >> torlist.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' emergingthreats.list >> iponly-emergingthreats.list
cat iponly-emergingthreats.list >> working.csv
wc -l working.csv >> torlist.log
echo "-------" >> torlist.log
echo "-------" >> torlist.log


# ninth list
echo "getting the ninth list now"
echo "http://hqpeak.com/torexitlist/free/?format=json" >> torlist.log
echo "-------" >> torlist.log
wget http://hqpeak.com/torexitlist/free/?format=json -O hqpeak.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
echo "removing non-IP address information from current file" >> torlist.log
echo "-------" >> torlist.log
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' hqpeak.list >> iponly-hqpeak.list
cat iponly-hqpeak.list >> working.csv
wc -l working.csv >> torlist.log
echo "-------" >> torlist.log
echo "-------" >> torlist.log


# tenth list
# i think this site has blocked me for trying to pull this list too often.
# for now it is not working.
echo "getting our tenth list now"
echo "http://blog.bannasties.com/2013/04/ips-blocked-as-tor-exit-nodes/" >> torlist.log
echo "-------" >> torlist.log
#wget http://blog.bannasties.com/2013/04/ips-blocked-as-tor-exit-nodes/ -O bannsitesblog.list
# This list includes other information besides IP addresses
# this will clean up the file and only give us the IP addresses
#echo "removing non-IP address information from current file" >> torlist.log
echo "-------" >> torlist.log
#grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' bannsitesblog.list >> iponly-bannsitesblog.list
#cat iponly-bannsitesblog.list >> working.csv
#wc -l working.csv >> torlist.log
echo "-------" >> torlist.log
echo "-------" >> torlist.log


# list number eleven
echo "grabbing the final list now"
echo "http://proxy.org/proxies_sorted2.shtml" >> torlist.log
echo "-------" >> torlist.log
echo "This list can tell I am a script and not a human, so for now it will be disabled" >> torlist.log
#wget http://proxy.org/proxies_sorted2.shtml -O proxyorg.list
#cat proxyorg.list >> working.csv
#wc -l working.csv >> torlist.log
echo "-------" >> torlist.log
echo "-------" >> torlist.log



# OK, at this point we need to start sorting our list adn removing any duplicates
echo "Now, I am going to sort our list that we have been working on" >> torlist.log
sort working.csv >> sorted.tor.list.csv
echo "-------" >> torlist.log
echo "-------" >> torlist.log
echo "Now, we will remove any duplicates in the list, using uniq." >> torlist.log
echo "before removing duplicates.:" >> torlist.log
wc -l sorted.tor.list.csv >> torlist.log
echo "-------" >> torlist.log
echo "After pulling out dumplicates:" >> torlist.log
uniq sorted.tor.list.csv >> clean.tor.list.csv
wc -l clean.tor.list.csv >> torlist.log
echo "-------" >> torlist.log
echo "-------" >> torlist.log


# Now, we need to grab all of our files, and zip them up for long term storage.
# I am using zip, since that is more common on windows systems.
zip csv-files.zip *.csv
mv clean.tor:.list.csv tornodes.upload
rm -rf *.csv
zip list-files.zip *.list
rm -rf *.list
# this will create our final zip file, and will date stamp the file.
# this will help us go back and find when an IP was added to our lists.
zip tor-nodes-$(date +%F).zip csv-files.zip list-files.zip torlist.log
# clean up our remaining files
rm -rf csv-files.zip
rm -rf list-files.zip
rm -rf torlist.log
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
