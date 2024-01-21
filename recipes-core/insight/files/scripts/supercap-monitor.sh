#!/bin/bash

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2015 ? Ingersoll-Rand
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
# 
# *****************************************************************************

#*****************************************************************************
# MODULE      : 
#
# SUBSYSTEM   : Supercap monitor poweroff
#
# DESCRIPTION : 
# * After power is pulled we sample POWER_FAIL.  If it is high we begin sampling 
# * the ADC on the supercaps to check the remaining charge.  If the sampled voltage
# * is below the percentage "$SHUTDOWN_PCT", then we begin shutting down.
# * At the end of shutdown, if the charge PCT is below "$PANIC_PCT" 
# * then we call an emergency remount,ro, emergency sync, and reboot.  
# * If we reach that point and there is a safe amount of charge, we shut down.
#
#*****************************************************************************

SCRIPT_INFO=2017042101

SHUTDOWN_PCT=80
POWER_RESUME=99 
ESSE_PCT=70
WAIT_PCT=65
PANIC_PCT=50

# HWDOG does not terminate hence minimum remaining process is 1.
ESSE_MIN_PROC=1

gpioctl --ddrin 47
echo "rising" > /sys/class/gpio/gpio47/edge

# This will block until we have a rising edge on POWER_FAIL
# Will make sure it is set a second after detection.
# This timeout is specified in 0.1 seconds.
TIME_CT=0 #Total Time Counter
while true; do
	TIMEOUT=10 # 1 second
	eval $(gpioctl --getin 47)
	if [ $gpio47 != 1 ]; then
		gpioctl --waitfor 47
	fi

	gpio47=1
	while [ "$gpio47" -eq  1 ]; do
	    eval $(silabs-adc)
		let TIME_CT=TIME_CT+1
        let TIMEOUT=TIMEOUT-1
        echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Timeout =" $TIMEOUT >> /dev/console
      
        # Debounce logic: complete the debounce timeout
 		if [ "$TIMEOUT" -eq 0 ]; then
		    eval $(silabs-adc)
            echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Timeout =" $TIMEOUT "debounce completed" >> /dev/console
			break;
		fi
         
        # Check cap charge level
        if [ "$CHARGE_PCT" -lt "$SHUTDOWN_PCT" ]; then
            eval $(silabs-adc)
            echo "`date` : CHARGE_PCT =" $CHARGE_PCT "SHUTDOWN_PCT =" $SHUTDOWN_PCT "VIN =" $VIN "Timeout =" $TIMEOUT "Break due to charge level" >> /dev/console
			break;
        fi

		eval $(gpioctl --getin 47)
	done

	# Check timeout
    if [ "$TIMEOUT" -eq 0 ]; then
        break;
    fi

    # Check cap charge level
    if [ "$CHARGE_PCT" -lt "$SHUTDOWN_PCT" ]; then
        break;
    fi
done

eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Script Info =" $SCRIPT_INFO "Power failed!" >> /var/log/poweroff.log

echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "check panic power down (" $PANIC_PCT ")" >> /dev/console 
if [ "$CHARGE_PCT" -lt "$PANIC_PCT" ]; then
	echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Panic!" >> /dev/console
	echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Panic!" >> /var/log/poweroff.log
	# Emergency remount ro
	echo 'u' > /proc/sysrq-trigger
	# Emergency sync
	echo 's' > /proc/sysrq-trigger
	# Remove sata drive safely
	echo 1 >/sys/block/sda/device/delete
	sync 
	# Kernel Panic Shutdown
	echo 'c' > /proc/sysrq-trigger 
fi

service postresql stop
killall -9 chromium

# Take steps to save power
# Disable USB entirely 
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Disable the USB" >> /dev/console
peekpoke 32 0x08000020 0x0

# Disable backlight entirely 
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Disable the backlight" >> /dev/console
echo 0 > /sys/class/backlight/backlight_lcd.28/brightness
# slim should disable the display when it is killed, but this will be faster
echo 1 > /sys/devices/soc0/fb.25/graphics/fb0/blank
echo 1 > /sys/devices/soc0/fb.25/graphics/fb1/blank
echo 0 > /sys/class/leds/en-led1/brightness
echo 0 > /sys/class/leds/en-led2/brightness
echo 0 > /sys/class/leds/en-led3/brightness
echo 0 > /sys/class/leds/en-led4/brightness
echo 0 > /sys/class/leds/en-led5/brightness
echo 0 > /sys/class/leds/en-led6/brightness
echo 0 > /sys/class/leds/en-led7/brightness
echo 0 > /sys/class/leds/en-led8/brightness

# Disable the FAN
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Disable the fan" >> /dev/console
gpioctl --clrout 123

eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Stop the browser" >> /dev/console
service browser-frontend stop &
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Stop the watchdog" >> /dev/console
killall -9 WDBin
killall -9 watchdog
service watchdog stop & 
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Stop the blinking LED" >> /dev/console
killall -9 BlinkExclaLed.sh

#************************* ESSE START **********************************#
# Clear boot up disk check status
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Begin shutdown of application tasks" >> /dev/console
#echo "000" >  /root/ESSE/sourcecode/Firmware/Common/bootStatus.txt
# Event log for power fail
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Power fail event log" >> /dev/console
/usr/src/ir/insight/Firmware/SystemResources/Output/BIN/SysRes 2

# Count number of ESSE Modules
num=$(ps aux | grep [B]IN | wc -l)
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Number of Running Application Processes =" $num >> /dev/console

# shutdown ESSE modules
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Kill Application Processes" >> /dev/console
kill -2 $(ps aux | grep [B]IN | awk '{ print $2 }')
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Kill Firmware Update Explicitly" >> /dev/console
killall -11 FWUP

# waiting to terminate all ESSE modules
#ESSE_TIMEOUT=100 # 10 seconds
#while [ $num -gt $ESSE_MIN_PROC ]; do
#	num=$(ps aux | grep [B]IN | grep -v DLOG | wc -l)
#    echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Number of Running Application Processes =" $num >> /dev/console

#	# wait for timeout to break
#	let TIME_CT=TIME_CT+1
#	let ESSE_TIMEOUT=ESSE_TIMEOUT-1
#	if [ $ESSE_TIMEOUT -eq 0 ]; then
#	    eval $(silabs-adc)
#		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Number of Running Application Processes =" $num "Break out due to timeout" >> /dev/console
#		echo $(ps -axo cmd | grep ESSE) >> /dev/console 
#		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Error: Not closed Application Processes when timeout:" >> /var/log/poweroff.log 
#		echo $(ps -axo cmd | grep ESSE) >> /var/log/poweroff.log 
#		break;
#	fi
	
#	eval $(silabs-adc)
#	if [ "$CHARGE_PCT" -lt "$ESSE_PCT" ]; then
#	    eval $(silabs-adc)
#		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Number of Running Application Processes =" $num "Break out due to CHARGE_PCT below" $ESSE_PCT >> /dev/console
#		echo $(ps -axo cmd | grep ESSE) >> /dev/console
#		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Error: Not closed Application Processes when charge level at" $ESSE_PCT ":" >> /var/log/poweroff.log
#		echo $(ps -axo cmd | grep ESSE) >> /var/log/poweroff.log 
#		break
#	fi
#done 

#num=$(ps aux | grep [B]IN | wc -l)
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Number of Running Application Processes After Completed=" $num >> /dev/console

# Clear boot up disk check status
#echo "000" >  /root/ESSE/sourcecode/Firmware/Common/bootStatus.txt
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "End Shutdown of Application Tasks" >> /dev/console

# Stop esse services 
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Stop CouchDB" >> /dev/console
#service couchdb stop &
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Stop Lucene" >> /dev/console
#service couchdb-lucene stop &
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Stop Lighttpd" >> /dev/console
#service lighttpd stop &

# wait for couchdb to stop
#SERVICE_TIMEOUT=200 #20 seconds
#while [ $SERVICE_TIMEOUT -gt 0 ]; do
#	let TIME_CT=TIME_CT+1
#    let SERVICE_TIMEOUT=SERVICE_TIMEOUT-1
#    pgrep couchdb
#    if [ $? != 0 ]; then
#        eval $(silabs-adc)
#        echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Verified the database has stopped at Timeout=" $SERVICE_TIMEOUT >> /dev/console 
#		break; 
#    fi
#done

#pgrep couchdb
#if [ $? == 0 ]; then
#     eval $(silabs-adc)
#     echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "ERROR: the database has NOT stopped" >> /dev/console#
	 echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "ERROR: the database NOT stopped properly" >> /var/log/poweroff.log
#	 break; 
#fi

# Terminate DLOG 
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Kill DLOG Explicitly" >> /dev/console
#killall -2 DLOG

eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Unmounting any USB drives" >> /dev/console
# Unmount all mount points inside /media 
umount /media/*
# Remove all directories inside /media
rmdir /media/*
	
#***************************** ESSE END ********************************#
# Turn off 3 cores and set the one core to 400mhz
# This is assuming shutdown blocks mostly on finalizing IO to the disk.
# If more cpu time is needed during shutdown it may be more efficient to 
# leave these on.
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Turn off 3 cores to save power" >> /dev/console
echo "powersave" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 0 > /sys/devices/system/cpu/cpu2/online
echo 0 > /sys/devices/system/cpu/cpu3/online

# Put ETH PHY in reset
# This breaks ethernet until a reboot
#eval $(silabs-adc)
#echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Put the ETH PHY in reset" >> /dev/console
#echo "116" > /sys/class/gpio/export
#echo "high" > /sys/class/gpio/gpio116/direction

# Wait to poweroff or reboot based on charge level
eval $(silabs-adc)
echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Check for reboot(" $POWER_RESUME ") or power down(" $WAIT_PCT ") Time =" $TIME_CT >> /dev/console 
WAIT_TIMEOUT=5000 # 500 seconds
while [ $WAIT_TIMEOUT -gt 0 ]; do
	let TIME_CT=TIME_CT+1
	let WAIT_TIMEOUT=WAIT_TIMEOUT-1
	eval $(silabs-adc)
    echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Waiting for voltage change" >> /dev/console
	if [ "$CHARGE_PCT" -lt "$WAIT_PCT" ]; then
		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Total Time=" $TIME_CT "Poweroff as charge level" >> /dev/console
		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Total Time=" $TIME_CT "Poweroff as charge level" >> /var/log/poweroff.log
		sync
                echo "`date` : shutdown -P now >> /dev/console" >> /dev/console 
		shutdown -P now >> /dev/console
		break
	elif [ "$CHARGE_PCT" -gt "$POWER_RESUME" ]; then
		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Total Time=" $TIME_CT "Reboot" >> /dev/console 
		echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Total Time=" $TIME_CT "Reboot" >> /var/log/poweroff.log
		sync
		shutdown -r now >> /dev/console
		break
	fi
done
if [ $WAIT_TIMEOUT == 0 ]; then
	echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Total Time=" $TIME_CT "Poweroff as timeout" >> /dev/console
	echo "`date` : CHARGE_PCT =" $CHARGE_PCT "VIN =" $VIN "Total Time=" $TIME_CT "Poweroff as timeout" >> /var/log/poweroff.log
	sync
	shutdown -P now >> /dev/console
fi	
echo 0 > /sys/class/leds/en-led4/brightness
