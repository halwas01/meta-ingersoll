#!/bin/bash

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2016 Ingersoll-Rand
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

# include header file 
source /scripts/sataheader.sh

echo "`date` : Start DiskCheck script" >> /var/log/diskcheck.log
# Check SATA presence
echo "`date` : Check presence of SATA drive" >> /dev/console
if [ -e $SATA ] ; then {
	echo "`date` : $SATA is present" >> /var/log/diskcheck.log
	#message_send $MSG_NOT_CONNECTED
	# verify it is SATA device
	DeviceType=`/sbin/udevadm info --query=all --name=sda | grep ata | wc -l`
	if (( DeviceType == 0 )) 
	then
		echo "`date` : Invalid SATA drive" >> /dev/console
		echo "`date` : $SATA is not a SATA device" >> /var/log/diskcheck.log
		$BLINKEXCLAMLED $DISK_INVALID_LED_ON_TIME $DISK_INVALID_LED_OFF_TIME &
		exit
	else
		echo "`date` : Valid SATA drive" >> /dev/console
		echo "`date` : $SATA is a SATA device" >> /var/log/diskcheck.log
	fi
	
	DiskSize=`fdisk -l | grep sda: | awk '{ print $5 }'`
	echo "`date` : Total Size = "$DiskSize >> $LOG_FILE
	echo "`date` : SATA drive size " $DiskSize >> /dev/console
	if (( DiskSize == 0 )) 
	then
		echo "`date` : Invalid SATA drive size" >> /dev/console
		echo "`date` : Disk is Invalid" >> /var/log/diskcheck.log
		# send event to UI via websocket.
		$BLINKEXCLAMLED $DISK_CORRUPT_LED_ON_TIME $DISK_CORRUPT_LED_OFF_TIME &
		exit
	fi
	
	echo "`date` : Check first partition" >> /dev/console
	# Check first partition
	if [ -e $FIRST_PART ] ; then {
		echo "`date` : $FIRST_PART is present" >> /var/log/diskcheck.log
		DiskSize=`fdisk -l | grep sda1 | awk '{ print $4 }'`
		echo "`date` : Total Size = "$DiskSize >> /var/log/diskcheck.log
		# Truncate fraction value from DiskSize 
		DiskSize=${DiskSize%.*}
		echo "`date` : First partition present with size " $DiskSize >> /dev/console
		if (( DiskSize == 0 )) 
		then
			echo "`date` : Invalid Partition" >> /dev/console
			echo "`date` : Disk1 is Invalid" >> /var/log/diskcheck.log
			$BLINKEXCLAMLED $DISK_CORRUPT_LED_ON_TIME $DISK_CORRUPT_LED_OFF_TIME &
			exit
		fi
		
	}
	else
		echo "`date` : First partition not present so creating parition" >> /dev/console
		echo "`date` : $FIRST_PART not present" >> /var/log/diskcheck.log
		echo "`date` : Creating partitions:" >> /var/log/diskcheck.log
		bash $CREATEPARTITION $FIRST
	fi

	# Check second partition
	echo "`date` : Check Second Partition" >> /dev/console
	if [ -e $SEC_PART ] ; then {
		echo "`date` : $SEC_PART is present" >> /var/log/diskcheck.log
		DiskSize=`fdisk -l | grep sda2 | awk '{ print $4 }'`
		echo "`date` : Total Size = "$DiskSize >> /var/log/diskcheck.log
		# Truncate fraction value from DiskSize 
		DiskSize=${DiskSize%.*}
		echo "`date` : Second partition present with size "  $DiskSize >> /dev/console		
		if (( DiskSize == 0 )) 
		then {
			echo "`date` : Invalid partition" >> /dev/console
			echo "`date` : Disk2 is Invalid" >> /var/log/diskcheck.log
			$BLINKEXCLAMLED $DISK_CORRUPT_LED_ON_TIME $DISK_CORRUPT_LED_OFF_TIME &
			exit
		}
		fi		
	}
	else
		echo "`date` : Second partition not present so creating partition" >> /dev/console
		echo "`date` : $SEC_PART not present" >> /var/log/diskcheck.log
		echo "`date` : Creating partitions:" >> /var/log/diskcheck.log
		bash $CREATEPARTITION $SECOND		
	fi
	
	#perform file system check (fsck) on SATA 
	fsck_reboot=0
	DiskStatus=`fsck -a /dev/sda1`
	echo "`date` : Perform fsck on first partition with status" $DiskStatus >> /dev/console
	echo "`date` : fsck status sda1 = "$DiskStatus >> /var/log/diskcheck.log
	#collect exit code of fsck 
	ExitCode=$?
	echo "`date` : fsck exit code sda1 = "$ExitCode >> /var/log/diskcheck.log
	DiskStatus=`fsck -a /dev/sda2`
	echo "`date` : Perform fsck on second partition with status" $DiskStatus >> /dev/console
	echo "`date` : fsck status sda2 = "$DiskStatus >> /var/log/diskcheck.log
	#collect exit code of fsck 
	ExitCode1=$?
	echo "`date` : fsck exit code sda2 = "$ExitCode1 >> /var/log/diskcheck.log
	
	if [ -e $FSCK_REBOOT_FILE ]
	then 
		#reboot count to avoid continue rebooting
		fsck_reboot=$(<$FSCK_REBOOT_FILE)
		echo "`date` : fsckReboot file present = "$fsck_reboot >> /var/log/diskcheck.log
		rm -f $FSCK_REBOOT_FILE
	fi
	
	#exit code 2 requires reboot 
	if (( ExitCode == 2 || ExitCode1 == 2 ))
	then 
		#max reboot allowed is 3 to avoid continue reboot 
		if (( fsck_reboot == 3 ))
		then 
			# send event to UI via websocket.
			echo "`date` : fsckReboot reached max = "$fsck_reboot >> /var/log/diskcheck.log
			$BLINKEXCLAMLED $DISK_CORRUPT_LED_ON_TIME $DISK_CORRUPT_LED_OFF_TIME &
			exit
		else
			#increase the reboot count and write to a file
			echo "`date` : Reboot due to fsck exit code" >> /dev/console
			fsck_reboot=$((fsck_reboot+1))
			echo "$fsck_reboot" >> $FSCK_REBOOT_FILE
			echo "`date` : Reboot system to correct SATA"  >> /var/log/diskcheck.log
			reboot
			exit
		fi
	fi
	#exit code greater than 2 - system can not be repaired and needs to be remains halted
	if (( ExitCode >= 3 || ExitCode1 >= 3 ))
	then 
		echo "`date` : SATA drive corrupted" >> /dev/console
		echo "`date` : SATA Disk is corrupted"  >> /var/log/diskcheck.log
		$BLINKEXCLAMLED $DISK_CORRUPT_LED_ON_TIME $DISK_CORRUPT_LED_OFF_TIME &
		exit
	fi
}
else
	echo "`date` : $SATA is not present" >> /var/log/diskcheck.log
	$BLINKEXCLAMLED $DISK_ABSENT_LED_ON_TIME $DISK_ABSENT_LED_OFF_TIME &
	exit
fi

# mounting disk partitions to required points.
echo "`date` : Mount partitions" >> /dev/console
echo "`date` : mounting disk partitions to required points" >> /var/log/diskcheck.log
#create and mount the database and temp folders if they do not exist
DB_DIR=/database
TEMP_DIR=/temp_data
UPLOAD_DIR=/temp_data/upload
DOWLOAD_DIR=/temp_data/download
LOGS_DIR=/var/log
LOGS_DEBUG_LOG=/temp_data/logs/Firmware.log
LOGS_MAX_DEBUG_LOG_SIZE=20000000
 
if [ ! -d "$DB_DIR" ]
then
    mkdir "$DB_DIR"
    mount /dev/sda1 "$DB_DIR"
else
    mount /dev/sda1 "$DB_DIR"
fi

echo "`date` : Check for database files on first partition" >> /dev/console
sh /scripts/db_init.sh

if [ ! -d "$TEMP_DIR" ]
then
    mkdir "$TEMP_DIR"
    mount /dev/sda2 "$TEMP_DIR"
else
    mount /dev/sda2 "$TEMP_DIR"
fi

if [ ! -d "$UPLOAD_DIR" ]
then
    mkdir "$UPLOAD_DIR"
fi

if [ ! -d "$DOWLOAD_DIR" ]
then
    mkdir "$DOWLOAD_DIR"
fi

if [ ! -d "$LOGS_DIR" ]
then
    mkdir "$LOGS_DIR"
fi

sync

echo "`date` : Check for size of debug log after power cycle" >> /var/log/diskcheck.log
filesize=$(ls -l $LOGS_DEBUG_LOG | awk '{print  $5}')
echo "`date` : Debug log size: $filesize" >> /var/log/diskcheck.log
if [ $filesize -ge $LOGS_MAX_DEBUG_LOG_SIZE ]
then
	echo "`date` : debug log too large - rotating" >> /var/log/diskcheck.log
	chown -R root /temp_data/logs
	chmod 644 /temp_data/logs
	/usr/sbin/logrotate /etc/logrotate.conf
	/usr/sbin/logrotate /etc/logrotate.d/rsyslog
	EXITVALUE=$?
	if [ $EXITVALUE != 0 ]; then
		echo "`date` : ALERT exited abnormally" >> /var/log/diskcheck.log
	fi
else
	echo "`date` : debug log does not need rotating" >> /var/log/diskcheck.log
fi

#********************* END OF DISCKCHECK *********************# 

echo "`date` : End DiskCheck script" >> /dev/console

