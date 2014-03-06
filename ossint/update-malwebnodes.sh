#!/bin/bash
# update-malwebnodes.sh
# Matthew Ulm
# 2014-03-05

#
# DISCLAIMER #1:
#
# This script is not intended for commercial use.
# this script is to help organizations monitor, combat, find, eradicate, etc. malware
# from their internal networks. The genesis for this list is just too many years
# being behind the eight ball as a system admin, and tired of re-imaging user machines.
# if we can detect it faster/ better/ stronger, we can hopefully tilt the scales back in 
# our favor.
#
#
# DISCLAIMER #2:
# The commercial or unauthorized use of any material within this script may violate copyright, trademark, and other laws. 
# From the sites the information is gathered from. THis script, adn teh data it collects must only be for non-commercial  
# use, and is intended to help system and network administrators protect the networks that they maintain only. This script can
# also be used for non-commercial home user. Any violation of this or any commercial use, the user of the script is instructed to
# immediately destroy any downloaded or printed materials.
#
#

# This script will gather a listing of different IP addresses from the malicious web
# and gather them all together in one listing, so that it can be uploaded into a SIEM,
# IDS< or other network level monitoring device.
# Commands used:
# touch, echo, wget, cat, wc, grep, sort, uniq, zip, cp, mv, date
# Let's get started
# First create some files
touch working.malweb.csv
touch working.malwebnodes.log


echo "We are starting our collection at: $(date)" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log

# Let's get the listing from the Malware Domains website
echo "Getting our first list from the Malware Domains site" >> working.malwebnodes.log
wget "http://www.malwaredomainlist.com/mdl.php?search=&colsearch=IP&quantity=All" -O malwaredomains.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' malwaredomains.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log

# This will gather our second list, which is a collection of three other sites.
# we will still gather from those sites as well, as a precaution, in case they do 
# not fully overlap with each other.
# There is a copyright notice included at the end of this file for this list.
echo "Gathering from Emerging Threats" >>
wget http://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt -O emergingthreats.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'  emergingthreats.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log


# This is our third list
echo "Gathering our list from the CI badguy list" >> working.malwebnodes.log
wget http://www.ciarmy.com/list/ci-badguys.txt -O ci.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'  ci.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log


# Our next list
# this list has mostly domain names, but we can find a few IPs in this list.
echo "Grabbing a list from siri-urz." >> working.malwebnodes.log
wget http://vxvault.siri-urz.net/URL_List.php -O siriurz.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' siriurz2.list >> working.malweb.csv
echo "-----" >> working.malwebnodes.log
echo "grabbing a second list from thsi site, that does not seem to match 100%" >> working.malwebnodes.log
# This will grab all URLs, hashes, and IPs on this list for the last 2.5 months
wget "http://vxvault.siri-urz.net/ViriList.php?s=40&m=500" >> -Osiriurz2.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' siriurz.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log


# next list
echo "Grabbing a listing from the RSS feed at Malware Block List" >> working.malwebnodes.log
wget http://www.malwareblacklist.com/mbl.xml -O mblrss.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mblrss.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log


# next set of lists
# this is a few pages we have to go through in order to get the last few months worth of data.
# We are going to grab 7 pages in all from this site and sort through them.
wget "http://malwaredb.malekal.com/" -O mdb0.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mdb0.list >> working.malweb.csv
wget "http://malwaredb.malekal.com/index.php?page=1" -O mdb1.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mdb1.list >> working.malweb.csv
wget "http://malwaredb.malekal.com/index.php?page=2" -O mdb2.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mdb2.list >> working.malweb.csv
wget "http://malwaredb.malekal.com/index.php?page=3" -O mdb3.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mdb3.list >> working.malweb.csv
wget "http://malwaredb.malekal.com/index.php?page=4" -O mdb4.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mdb4.list >> working.malweb.csv
wget "http://malwaredb.malekal.com/index.php?page=5" -O mdb5.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mdb5.list >> working.malweb.csv
wget "http://malwaredb.malekal.com/index.php?page=6" -O mdb6.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' mdb6.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
# Need to investigate, but this could be a daily listing of malware
# http://malwaredb.malekal.com/daily.zip



# Another larger list
# not a whole lot of IPs in this list, but certainly a few that make it 
# worthwhile to download, parse, adn add to our growing collection.
wget http://cybercrime-tracker.net/all.php -O ccrimetracker.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' ccrimetracker.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log


# This is a very short list of IPs from Poland.
# I think it is only 10 or so IPs that we get from this
# but it adds 10 r so IPs to this list.
wget http://www.malware.pl/index.malware -O poland.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' poland.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log


# Again another small list of IP addresses
# for us to parse and add to our working list
wget http://www.malwareurl.com/ -O malwareurl.list
grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' malwareurl.list >> working.malweb.csv
wc -l working.malweb.csv >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
echo "-----" >> working.malwebnodes.log
# you can register on this site for a personal download link to access
# the complete database. This link is paired to the user registration, so
# I will not add it here.


# we are going to grab another listing of sites, and what not,
# that we will haev to pull a few pages from.
wget http://malc0de.com/database/
wget http://malc0de.com/database/?&page=2
wget http://malc0de.com/database/?&page=3
wget http://malc0de.com/database/?&page=4
wget http://malc0de.com/database/?&page=5
wget http://malc0de.com/database/?&page=6
wget http://malc0de.com/database/?&page=7
wget http://malc0de.com/database/?&page=8
wget http://malc0de.com/database/?&page=9

# EOS



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

# EOF
