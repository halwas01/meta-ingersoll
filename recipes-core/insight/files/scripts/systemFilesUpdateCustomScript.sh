#!/bin/sh

# ******************************************************************************
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
# ******************************************************************************

#*******************************************************************************
# MODULE      : systemFilesUpdateCustomScript Script
#
# DESCRIPTION : This script updates the system files from the .tar file created 
#               by createSystemFilesPackage.sh script. This script should be 
#               added in firmware update package along with the above mentioned 
#               tar file.
#*******************************************************************************

#PATH VARIABLE DECLARATION FOR TEMP DIRECTORY WHICH CONTAINS LATEST PACKAGE
TEMP_PATH=/root/Backup/Archer-Temp/
SYSTEM_ROOT=/
SYSTEM_FILES_TAR=systemFiles.tar

#EXIT IF A COMMAND FAILED
exitStatus() {
	exit_status=$?
	if [ "${exit_status}" -ne 0 ]
		then
		echo "Extract Failed"
		exit 1
	fi
}

cp $TEMP_PATH$SYSTEM_FILES_TAR $SYSTEM_ROOT
exitStatus

cd $SYSTEM_ROOT
rm -rf /root/ESSE/sourcecode/apps/*
mkdir /usr/src/ir/insight/Firmware/IOManager/Profibus
mkdir /usr/src/ir/insight/Firmware/IOManager/Devicenet
tar -xf $SYSTEM_ROOT$SYSTEM_FILES_TAR

