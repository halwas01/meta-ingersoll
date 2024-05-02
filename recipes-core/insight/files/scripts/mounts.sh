#!/bin/bash

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

echo "`date` : Start DiskCheck script"
# Check SATA presence
echo "`date` : Check presence of SATA drive"
if [ -e "/dev/sda" ] ; 
then 
	echo "`date` : /dev/sda is present"
	# verify it is SATA device
	DeviceType=`/sbin/udevadm info --query=all --name=sda | grep ata | wc -l`
	if (( "$DeviceType" == 0 )) 
	then
		echo "`date` : Invalid SATA drive" 
		exit
	else
		echo "`date` : Valid SATA drive" 
	fi
	
	DiskSize=`fdisk -l | grep sda: | awk '{ print $5 }'`
	echo "`date` : SATA drive size " $DiskSize
	if (( "$DiskSize" == 0 )) 
	then
		echo "`date` : Invalid SATA drive size"
		exit
	fi	
	echo "`date` : Check first partition"
	# Check first partition
	if [ -e "/dev/sda1" ] ; 
	then 
		echo "`date` : /dev/sda1 is present" 
		DiskSize=`fdisk -l | grep sda1 | awk '{ print $4 }'`
		echo "`date` : Total Size = "$DiskSize
		# Truncate fraction value from DiskSize 
		DiskSize=${DiskSize%.*}
		echo "`date` : First partition present with size " $DiskSize
		if (( DiskSize == 0 )) 
		then
			echo "`date` : Invalid Partition"
			exit
		fi
	else
		echo "`date` : First partition not present so creating parition"
		echo "`date` : Format Partition"
		temp='mkfs.ext4 /dev/sda1 <<EOF' 
	fi
else
	echo "`date` : /dev/sda is not present"
	exit
fi

#create and mount the database and temp folders if they do not exist
DB_DIR=/database
TEMP_DIR=/temp_data
 
if [ ! -d "$DB_DIR" ]
then
    mkdir "$DB_DIR"
    mount /dev/sda1 "$DB_DIR"
else
    mount /dev/sda1 "$DB_DIR"
fi

if [ ! -d "$TEMP_DIR" ]
then
    mkdir "$TEMP_DIR"
    mount /dev/sda2 "$TEMP_DIR"
else
    mount /dev/sda2 "$TEMP_DIR"
fi
