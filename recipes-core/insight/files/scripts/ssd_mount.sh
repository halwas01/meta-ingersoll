#!/bin/bash
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
mkdir -p "/mnt/ssd"


#mount the M.2 SSD
mount /dev/$m2_device /mnt/ssd
if [ $? -eq 0 ];then
        echo "M.2 SSD successfully mounted at "
else
        echo "Failed to mount M.2 SSD"
fi



