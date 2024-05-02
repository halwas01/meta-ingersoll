#!/bin/bash

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2016 ? Ingersoll-Rand
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
# MODULE       : CPU core temp/fan monitor script
#
# SUBSYSTEM    : 
#
# DESCRIPTION  : Monitors CPU core temperature, upon exceeding the threshold
#                temperature turn on the CPU fan
#
#*****************************************************************************

# set the threshold temperature.
thresholdMaxTmp=75000
thresholdMinTmp=70000
fanOn=1
fanOff=0
#SYSFS path
GPIO_PATH=/sys/class/gpio/gpio123

#set the GPIO pins
if [ ! -d "$GPIO_PATH" ]; then
  echo 123 > /sys/class/gpio/export
fi
echo "out" > /sys/class/gpio/gpio123/direction

fanState=$fanOff
echo "initial fan state"
echo $fanState

while true; do 
	#read CPU core Temperature
	#cpucoreTmp=`sensors | awk '{print}' | awk -F' ' '{print$2}' | awk -F+ '{print$2}' | awk -F. '{print$1}'` 
        cpucoreTmp=`cat /sys/class/thermal/thermal_zone0/temp`
	#echo $cpucoreTmp

	#check if exceeds the threshold temperature
	if [ "$cpucoreTmp" -ge "$thresholdMaxTmp" ]; then
                if (fanState==fanOff); then
			echo $cpucoreTmp
			echo "exceeding threshold temperature, turning on the fan"
			echo 1 > /sys/class/gpio/gpio123/value
			fanState=$fanOn
		fi
	fi
	if [ "$cpucoreTmp" -lt "$thresholdMinTmp" ]; then
                if (fanState==fanOn); then
			echo $cpucoreTmp
			echo "With in threshold temp, turning off the fan"
			echo 0 > /sys/class/gpio/gpio123/value
			fanState=$fanOff
		fi
	fi
	sleep 1
done
