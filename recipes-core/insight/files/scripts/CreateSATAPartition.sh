#!/bin/bash

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2016 © Ingersoll-Rand
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

# *****************************************************************************
# MODULE       : SATA
#
# SUBSYSTEM    : Memory leak test for websocket.py
#
# DESCRIPTION  : Monitor memory leak by websocket and restart websocket when 
#                memory leak reaches to pre-define limit
#
# ****************************************************************************

source /scripts/sataheader.sh

echo "`date` : Partition number $1" >> $LOG_FILE

# ****************************************************************************
# fn         partition_function
#
# Purpose:   This function delete a partition if already exist, create a new  
#            partition with ext4 format. 
#
# ****************************************************************************
function partition_function()
{
	echo "`date` : In function" >> $LOG_FILE
fdisk /dev/sda <<EOF
n
p
$1
$2
$3
w
EOF

	# Format partitions
	mkfs.ext4 /dev/sda$1 <<EOF
y
EOF

	echo "`date` : Result = "$? >> $LOG_FILE

}

if (( $1 == "1" ))
then
	echo "`date` : Database partition" >> $LOG_FILE
	partition_function $1 $DB_START_SECTOR $DB_STOP_SECTOR	
	# Setting up directories structure in the partition	
	mount $FIRST_PART $DB_MOUNT_PT	
	
	#env -i /root/ESSE/DB_Creation/dbcreation.sh <<EOF
#1
#EOF
	#sync	
	umount $DB_MOUNT_PT
	sync
	
elif (( $1 == "2" )) 
then
	echo "`date` : Upload/Download parttion"
	partition_function $1 $BU_START_SECTOR $BU_STOP_SECTOR	
	# Setting up directories structure in the partition
	mount $SEC_PART $BKP_MOUNT_PT	
	umount $BKP_MOUNT_PT
	echo "`date` : Complted $SEC_PART" >> $LOG_FILE
	
elif (( $1 == "3" )) 
then
	echo "`date` : Upload/Download parttion" >> $LOG_FILE
	partition_function $1 $TM_START_SECTOR $TM_STOP_SECTOR	
	chmod -R $ALL_PERM $STMP_MOUNT_PT

fi
