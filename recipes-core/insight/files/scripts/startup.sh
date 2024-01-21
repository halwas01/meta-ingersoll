#!/bin/sh

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2020 Ingersoll-Rand
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

#******************************************************************************
# MODULE       : startup script
#
# SUBSYSTEM    : common
#
# DESCRIPTION  : common implementation of startup script
#
#*****************************************************************************
# stop postgresql service if it is running because the SATA drive is not mounted yet
service postgresql stop

echo "`date` : STARTUP - HARDWARE" >> /dev/console
sh /scripts/hardware_init.sh &

echo "`date` : STARTUP - FAN MONITOR" >> /dev/console
sh /scripts/fanMonitor.sh &

echo "`date` : STARTUP - SUPERCAP MONITOR" >> /dev/console
sh /scripts/supercap-monitor.sh &

echo "`date` : STARTUP - DISK CHECK" >> /dev/console
bash /scripts/DiskCheck.sh

echo "`date` : STARTUP - IR APPLICATIONS" >> /dev/console
sh /scripts/application_start.sh & 

