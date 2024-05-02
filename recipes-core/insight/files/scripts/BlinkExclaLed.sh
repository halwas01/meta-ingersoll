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

# include header file 
source /root/DiskCheck/sataheader.sh

# ****************************************************************************
# fn         message_send
#
# Purpose:   This function send message queue to WBA and Controll manager  
#
# ****************************************************************************
function blink_exclamation_led
{
	while [ 1 ]
	do
		echo 1 > /sys/class/leds/en-led4/brightness
		sleep $1
		echo 0 > /sys/class/leds/en-led4/brightness
		sleep $2
	done	
}

# call function
blink_exclamation_led $1 $2
