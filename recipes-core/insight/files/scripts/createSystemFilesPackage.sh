#!/bin/sh

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2017 ? Ingersoll-Rand
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

#*****************************************************************************
# MODULE      : createSystemFilesPackage Script
#
# DESCRIPTION : This script creates .tar file of system files needed for 
#               application. Output .tar file is may be added while creating
#               firmware update package along with systemFilesUpdateCustomScript
#
#*****************************************************************************

SYSTEM_FILES_TAR=systemFiles.tar

rm -rf /$SYSTEM_FILES_TAR
   
find /scripts -name "application_start.sh" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /scripts -name "DiskCheck.sh" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /etc/haproxy -name "haproxy.cfg" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /scripts -name "DB_Creation_Schema.sql" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /scripts -name "Factory_Reset.sql" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /scripts -name "Insert_Default_Records.sql" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /etc/rsyslog.d -name "30-commsLogFilter.conf" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /etc -name "motd" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/serialFlashRW/sfread -name "sfread" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/serialFlashRW/sfwrite -name "sfwrite" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/FirmwareManager/FirmwareVersions -name "qx_irdisplay.bin" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/FirmwareManager/FirmwareVersions -name "qx_mce.out" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/FirmwareManager/FirmwareVersions -name "qx_irradio.bin" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/FirmwareManager -name "qx_irdisplayT.bin" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/FirmwareManager -name "qx_irdisplayW.bin" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/lib/insight -name "DBA.so" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/DbAdapters/Output/BIN -name "DBA.so" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/IOManager/Profibus -name "cifXdps.nxf" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/IOManager/Profibus -name "config.nxd" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/IOManager/DeviceNet -name "cifxdns.nxf" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
find /usr/src/ir/insight/Firmware/IOManager/DeviceNet -name "config.nxd" -exec tar -rf "/$SYSTEM_FILES_TAR" {} \;
tar -rf "/$SYSTEM_FILES_TAR" /usr/src/ir/insight/Firmware/VwXml/xsd;



