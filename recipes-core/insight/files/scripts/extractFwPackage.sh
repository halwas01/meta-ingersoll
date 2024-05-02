#!/bin/sh

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
# *
# *****************************************************************************

#*****************************************************************************
# MODULE      : firmware update
#
# SUBSYSTEM   : 
#
# DESCRIPTION : Extract IRB package received for firmware upgrade
#
#*****************************************************************************

#EXIT IF A COMMAND FAILED
exitStatus() {
	exit_status=$?
	if [ "${exit_status}" -ne 0 ]
		then
		echo "Extract Failed"
		exit 1
	fi
}

#PATH VARIABLE DECLARATION FOR TEMP DIRECTORY WHICH CONTAINS LATEST PACKAGE
PACKAGE_PATH=/root/Backup/upload/
TEMP_PATH=/root/Backup/Archer-Temp/

#PACKAGE NAME VARIABLE
#IRB_PACKAGE_NAME=package.irb
IRB_PACKAGE_NAME=$1
TAR_PACKAGE_NAME=package.tar
COMPRESSED_TAR_NAME="$TAR_PACKAGE_NAME".gz
ENCRYPTED_TAR_NAME="$COMPRESSED_TAR_NAME".gpg


mkdir /root/Backup/Archer-Temp
mkdir /root/Backup/Archer-Backup
echo remove old package
rm -rf /root/Backup/Archer-Temp/*

echo "************************************************************************"
echo "                      Extracting new package                            "
echo "************************************************************************"
#Rename irb file to gpg
mv "$PACKAGE_PATH$IRB_PACKAGE_NAME" "$PACKAGE_PATH$ENCRYPTED_TAR_NAME"
exitStatus
#Decrypt package using gpg
gpg -o "$PACKAGE_PATH$COMPRESSED_TAR_NAME" --yes --batch --passphrase=archer "$PACKAGE_PATH$ENCRYPTED_TAR_NAME"
exitStatus
#Extract gz package to tar
tar -zxf "$PACKAGE_PATH$COMPRESSED_TAR_NAME" -C "$PACKAGE_PATH"
exitStatus
#Extract tar package to TEMP_PATH
tar -xf "$PACKAGE_PATH$TAR_PACKAGE_NAME" -C "$TEMP_PATH"
exitStatus
rm -f "$PACKAGE_PATH$TAR_PACKAGE_NAME"
rm -f "$PACKAGE_PATH$COMPRESSED_TAR_NAME"
mv "$PACKAGE_PATH$ENCRYPTED_TAR_NAME" "$PACKAGE_PATH$IRB_PACKAGE_NAME"
exitStatus
