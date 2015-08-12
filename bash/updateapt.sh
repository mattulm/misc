#!/bin/sh

touch /root/update.apt.log;

sudo apt-get update >> /root/update.apt.log;
sleep 1;

cat /root/update.apt.log | /usr/bin/mutt -s "Server_Name" destination@domain.com -a /root/update.apt.log;

sleep 2;
rm -rf /root/update.apt.log;