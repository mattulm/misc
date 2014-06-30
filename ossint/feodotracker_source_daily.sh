#!/bin/bash
##################################################
# Description: Some information about the source
#
# Name: Feodo Bot TRacker
# Host: Abuse.ch (The Swiss Security Blog.)
# Frequency: Daily
# Types: IPv4, domain
# Some Variables
HOME="/tmp/osint"
SOURCES="/tmp/osint/sources"
HEADER="Accept: text/html"
UA21="Mozilla/5.0 Gecko/20100101 Firefox/21.0"
UA22="Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13; ) Gecko/20101203"
TODAY=$(date +"%Y-%m-%d")
if [ ! -d "/tmp/ossint/sources/feodo" ]; then
	mkdir -p /tmp/osint/sources/feodo;
fi
datadirs=( ipv4 domains hashes rules )
for i in "${datadirs[@]}"; do
	if [ ! -d "$HOME/$i" ]; then
		mkdir -p $HOME/$i
	fi
done
cd $SOURCES/feodo
##################################################
# Get the IDS/IPS rules first
wget --header="$HEADER" --user-agent="$UA21" "https://feodotracker.abuse.ch/blocklist/?download=snort" -O feodo_snort_$TODAY.rules
sleep 15;
wget --header="$HEADER" --user-agent="$UA21" "https://feodotracker.abuse.ch/blocklist/?download=suricata" -O feodo_suricatta_$TODAY.rules
sleep 15;
###### Get the bad domains:
wget --header="$HEADER" --user-agent="$UA21" "https://feodotracker.abuse.ch/blocklist/?download=domainblocklist" -O feodo_domain_working_$TODAY.txt
sleep 15;
###### Get the IP lists
wget --header="$HEADER" --user-agent="$UA21" "https://feodotracker.abuse.ch/blocklist/?download=ipblocklist" -O feodo_blocklist_$TODAY.txt
sleep 15;
wget --header="$HEADER" --user-agent="$UA21" "https://feodotracker.abuse.ch/blocklist/?download=badips" -O feodo_verB_$TODAY.txt
sleep 15;
wget --header="$HEADER" --user-agent="$UA22" "https://feodotracker.abuse.ch/" -O feodo_homepage_$TODAY.txt
##################################################
# Move the IDS/IPS rules
cp feodo_snort_$TODAY.rules /tmp/osint/rules/feodo_snort_$TODAY.rules;
cp feodo_suricatta_$TODAY.rules /tmp/osint/rules/feodo_suricatta_$TODAY.rules;
# Some IP file stripping now. I am going to go 
# through all of the files just in case 
for f in feodo_*_$TODAY.txt; do
        cat $f | grep -E -o '(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)' >> feodo_ip_working.txt
done
# sort and remove some duplicates.
cat feodo_ip_working.txt | sort | uniq >> feodo_ipv4_$TODAY.txt
cp feodo_ipv4_$TODAY.txt /tmp/osint/ipv4/feodo_ipv4_$TODAY.txt;
# Some domain file stripping now. This will strip each line
# that begins with the comment character off of the file.
sed '/^#/ d' feodo_domain_working_$TODAY.txt >> feodo_domain_master_$TODAY.txt
cp feodo_domain_master_$TODAY.txt /tmp/osint/domains/feodo_domains_$TODAY.txt
##################################################
# Now the IPv4 addresses
while read p; do
        wget --header="$HEADER" --user-agent="$UA22" "https://feodotracker.abuse.ch/host/$p/" -O feodo_hashes_$p.html
   	sleep 15;
done < feodo_ipv4_$TODAY.txt
# Now the domains
while read p; do
        wget --header="$HEADER" --user-agent="$UA22" "https://feodotracker.abuse.ch/host/$p/" -O feodo_zeus_hashes_$p.html
	sleep 15;
done < feodo_domain_master_$TODAY.txt
# Let's work with these files and only pull out the hashes.
for i in *.html; do 
	cat $i | sed -e 's/^.*FF8000 //g;s/ width.*$//g' | grep -a -o -e "[0-9a-f]\{32\}" >> feodo_md5_working.txt
	cat $i | grep -a -o -e "[0-9a-f]\{64\}" >> feodo_sha256_working.txt
	cat $i | grep -E -o '(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-5][0-9]|[01]?[0-9][0-9]?)' >> feodo_ipv4_old.txt
done
#
### 
cat feodo_md5_working.txt | sort | uniq >> feodo_md5_$TODAY.txt
cp feodo_md5_$TODAY.txt /tmp/osint/hashes/feodo_md5_$TODAY.txt
#
cat feodo_sha256_working.txt | sort | uniq >> feodo_sha256_$TODAY.txt
cp feodo_sha256_$TODAY.txt /tmp/osint/hashes/deodo_sha256_$TODAY.txt
#
cat feodo_ipv4_$TODAY.txt >> feodo_ipv4_old.txt
cat feodo_ipv4_old.txt | sort | uniq >> feodo_ipv4_archive_$TODAY.txt


#
# EOF