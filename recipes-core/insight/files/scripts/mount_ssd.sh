#!/bin/bash
DB_FILE=/database/db_init
m2_device=$(lsblk -o NAME,TRAN | grep -i 'nvme' | awk '{print $1}')

if [-z "$m2_device"]; then
        echo "no m.2 SSD detected"
        exit 1
fi

DEVICE="/dev/$m2_device"

if sudo file -sL $DEVICE | grep -q "ext4";then
        echo "ext4 filesystem already exists"
else
        sudo mkfs.ext4 $DEVICE
        echo "ext4 filesystem created on $DEVICE "
fi


#create a directory to mount the SSD
mkdir -p "/database"

#mount the M.2 SSD
mount /dev/$m2_device /database
if [ $? -eq 0 ];then
        echo "M.2 SSD successfully mounted at "
else
        echo "Failed to mount M.2 SSD"
fi

if [ ! -f "$DB_FILE" ]
then
	#echo "`date` : DB Not Initialized" >> /var/log/diskcheck.log
	echo "`date` : DB Not Initialized" >> /dev/console
	
	# remove any files in the folder - may be old files
	#echo "`date` : Remove any old files" >> /var/log/diskcheck.log
	echo "`date` : Remove any old files" >> /dev/console
	rm -rf /database/*
	#systemctl stop postgresql
	chown -R postgres:postgres /database
	sudo -u postgres pg_ctl initdb -D /database
	sudo -u postgres pg_ctl -D /database
    touch $DB_FILE
else
	echo "DB already exists so no need to create"
fi	





