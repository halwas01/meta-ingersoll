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
# MODULE       : hardware script 
#
# SUBSYSTEM    : common
#
# DESCRIPTION  : common implementation of startup script
#
#*****************************************************************************

#enable the NetX driver in the kernel
modprobe uio_netx custom_dpm_addr=0x08018000 custom_dpm_len=0x4000 custom_irq=0

# Turn USB off
peekpoke 32 0x08000020 0x0
# Or however long your devices need for a reset 
sleep 1 
# Turn USB on
peekpoke 32 0x08000020 0x1 

# Map ttymxc1 TXD/RXD/CTS/RTS t0 radio
export CN2_94=TTYMXC1_TXD
export TTYMXC1_RXD=CN2_96
export CN2_98=TTYMXC1_CTS
export CN2_100=TTYMXC1_RTS
export CN2_86=GPIO
tshwctl --set

# Set CN2_86 as input
echo "231" >/sys/class/gpio/export
echo "in"  >/sys/class/gpio/gpio231/direction

# Disable 12MHZ clock on CPU board
export CN1_87=GPIO
tshwctl --set

# Set Radio Control Pins
echo "104" >/sys/class/gpio/export
echo "105" >/sys/class/gpio/export
echo "out" >/sys/class/gpio/gpio104/direction
echo "out" >/sys/class/gpio/gpio105/direction
echo 0 >/sys/class/gpio/gpio105/value
echo 1 >/sys/class/gpio/gpio104/value
sleep 1
echo 0 >/sys/class/gpio/gpio104/value
sleep 1
echo 1 >/sys/class/gpio/gpio104/value
