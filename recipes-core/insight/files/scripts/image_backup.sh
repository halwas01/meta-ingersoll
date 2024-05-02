#!/bin/bash

service watchdog stop
#service esse-power-on stop-Exphwdog
service postgresql stop
service lighttpd stop
#service browser-frontend stop;
service haproxy stop
mount /dev/mmcblk2p1 /mnt;
cd /mnt
tar --exclude='./temp_data' --exclude='./database' -cjvf /temp_data/emmcimage.tar.bz2 .
