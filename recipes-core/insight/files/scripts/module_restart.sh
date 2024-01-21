#!/bin/sh

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2020 ? Ingersoll-Rand
# *                         All Rights Reserved
# *
# * This document is the property of Ingersoll-Rand Company and contains
# * contains proprietary and confidential information of Ingersoll-Rand
# * Company.  Neither this document nor said proprietary information
# * shall be published, reproduced, copied, disclosed, or communicated to
# * any third party, nor be used for any purpose other than that stated
# * in the particular enquiry or order for which it is issued. The
# * reservation of copyright in this document extends from each date
# * appearing thereon and in respect of the subject matter as it appeared
# * at the relevant date.
# *
# *****************************************************************************

#*****************************************************************************
# MODULE      : Module Restart
#
# SUBSYSTEM   : 
#
# DESCRIPTION : soft reboot the system
#
#*****************************************************************************
echo "`date` : Killing All Modules." >> /var/log/diskcheck.log
echo "`date` : Killing All Modules." >> /dev/console
killall -9 WD
kill -2 $(ps aux | grep [B]IN | awk '{ print $2 }') 
killall -9 QXUD
killall -9 QXRD
killall -9 BR
killall -9 node
kill -9 $(ps aux | grep [p]ython | awk '{ print $2 }')
sleep 2

echo "`date` : Run DB Init Script" >> /var/log/diskcheck.log
echo "`date` : Run DB Init Script" >> /dev/console
sh /scripts/db_init.sh
# release shared mem and msg queue
echo "`date` : Release shared mem and msg queue" >> /var/log/diskcheck.log
echo "`date` : Release shared mem and msg queue" >> /dev/console
for x in `ipcs -m | cut -d' ' -f2 | grep '^[0-9]'`; do ipcrm -m $x; done
for x in `ipcs -q | cut -d' ' -f2 | grep '^[0-9]'`; do ipcrm -q $x; done

sleep 2
ipcs -m -q

#start sys log
echo "`date` : Restart Sys log" >> /var/log/diskcheck.log
echo "`date` : Restart Sys log" >> /dev/console 
/etc/init.d/rsyslog restart
sleep 2

#Start Application Modules:
echo "`date` : Starting Application Modules" >> /var/log/diskcheck.log
echo "`date` : Starting Application Modules" >> /dev/console 
chmod +x /scripts/application_start.sh
sh /scripts/application_start.sh & 
sleep 2
