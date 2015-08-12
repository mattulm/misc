#!/bin/sh

touch /root/update.yum.log;

yum -y --exclude=kernel\* update >> /root/update.yum.log;
sleep 1;

cat /root/update.yum.log | /usr/bin/mutt -s "Server_Name" destination@domain.com -a /root/update.yum.log;

sleep 2;
rm -rf /root/update.yum.log;