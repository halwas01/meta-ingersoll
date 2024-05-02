#!/bin/sh
df -H | grep /temp_data |grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 75 ]; then
	/usr/src/ir/insight/Firmware/SystemResources/Output/BIN/SysRes 4
  fi
done