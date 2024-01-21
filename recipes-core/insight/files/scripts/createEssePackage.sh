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
# MODULE      : createEssePackage Script
#
# SUBSYSTEM   : Firmware Update
#
# DESCRIPTION : Create irb package for firmware upgrade
# 
# This script is to be used with application version 5.3.4 and above
#
#*****************************************************************************

#EXIT IF A COMMAND FAILED
exitStatus() {
	exit_status=$?
	if [ "${exit_status}" -ne 0 ]
		then
		echo "Zip Failed"
		exit 1
	fi
}

#PATH VARIABLE DECLARATION FOR TEMP DIRECTORY WHICH CONTAINS LATEST PACKAGE
SYSTEM_ROOT=/
CONTROLLER_PATH=/usr/src/ir/insight/Firmware/
APPS_PATH=/usr/src/ir/insight/apps/
UI_PATH=/usr/src/ir/insight/Firmware/nwba/
WBA_PATH=/usr/src/ir/insight/Firmware/WebBackend/
FWUP_PATH=/usr/src/ir/insight/Firmware/FirmwareManager/
COMMON_PATH=/usr/src/ir/insight/Firmware/Common
FWUP_DIRECTORY=FirmwareManager
#COUCH_DB_PATH=usr/var/lib/couchdb/
DB_CREATION_FILES=/scripts/
TEMP_PATH=root/Backup/
#PACKAGE NAME VARIABLE
IRB_PACKAGE_NAME=package.irb
ZIP_PACKAGE_NAME=package
TAR_PACKAGE_NAME=package.tar
COMPRESSED_TAR_NAME="$TAR_PACKAGE_NAME".gz
ENCRYPTED_TAR_NAME="$COMPRESSED_TAR_NAME".gpg

#License manager bin
LICENSE_MANAGER=LicenseManager

MCE_APPLICATION=root/ESSE/sourcecode/Firmware/MCE\ Redesign/PlatformMCE\ Image/MCEApplication.irb
MCE_APPLICATION_IRB=MCEApplication.irb
MCE_APPLICATION_PATH=root/ESSE/sourcecode/Firmware/MCE\ Redesign/PlatformMCE\ Image/

#Path for version files
VERSION_DIRECTORY=/usr/src/ir/insight/Versions

POWER_DOWN_PROCESS_FILE=PowerDownProcess.txt
FWUP_FILE=firmwareupdate.txt
COPY_FILE=copy.txt
BOOT_FILE=bootStatus.txt


echo "************************************************************************"
echo "                 Creating ESSE package at $TEMP_PATH                    "
echo "************************************************************************"

#Change directory to root
cd "$SYSTEM_ROOT"

#Tar all files excluding .c,.h and .o files
if [ "$1" = "BINS" ]
then
	echo "ADDING FIRMWARE BINS TO PACKAGE"

	#Tar executable files
	#find "$CONTROLLER_PATH" -executable -type f ! -name "*.irb" ! -name "*.[cho]*" ! -path "$WBA_PATH*" ! -path "$FWUP_PATH*" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	#Add firmware bins in BIN directory excluding FWUpdateCorded
	find "$CONTROLLER_PATH" -type f ! -path "$UI_PATH*" ! -path "$WBA_PATH*" ! -path "$COMMON_PATH" -path "*BIN*" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	#Add licence manger bin
	find "$CONTROLLER_PATH" -type f -name "$LICENSE_MANAGER" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	find "$CONTROLLER_PATH" -type f ! -path "$UI_PATH*" ! -path "$WBA_PATH*" ! -path "$FWUP_PATH*" ! -path "$COMMON_PATH" -name "*.sh" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	find "$CONTROLLER_PATH" -type f ! -path "$UI_PATH*" ! -path "$WBA_PATH*" ! -path "$FWUP_PATH*" ! -path "$COMMON_PATH" -name "*.so" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	find "$CONTROLLER_PATH" -type f ! -path "$UI_PATH*" ! -path "$WBA_PATH*" ! -path "$FWUP_PATH*" ! -path "$COMMON_PATH" -name "*.py" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	#find "$CONTROLLER_PATH" -type f ! -path "$UI_PATH" ! -path "$WBA_PATH" ! -path "$FWUP_PATH" ! -path "$COMMON_PATH" ! -path "*PlatformMCE*" ! -name "$POWER_DOWN_PROCESS_FILE" ! -name "$FWUP_FILE" ! -name "$COPY_FILE" ! -name "$BOOT_FILE" -name "*.txt" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	
	#echo "ADDING DB CREATION BINARIES TO PACKAGE"
	#find "$DB_CREATION_FILES" -type f ! -name "*.*" ! -name "Makefile" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	#find "$DB_CREATION_FILES" -type f -name "*.sh" -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	#exitStatus
	
	echo "ADDING LICENSED APPS TO PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" "$APPS_PATH"
	exitStatus
fi

#Tar Firmware Update Module
if [ "$1" = "SELF" ]
then
   echo "ADDING FIRMWARE UPDATE MODULE TO PACKAGE"
   tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" -C "$CONTROLLER_PATH" "$FWUP_DIRECTORY"
fi

#Tar WBA directory
if [ "$1" = "WBA" ]
then
	echo "ADDING WBA TO PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" "$WBA_PATH"
fi

#Tar nwba directory
if [ "$1" = "UI" ]
then
	echo "ADDING nwba TO PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" "$UI_PATH"
	exitStatus
fi

#Zip MCE application irb file
if [ "$1" = "MCE" ]
then
	echo "ADDING MCE APPLICATION IRB FILE TO PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" -C "$MCE_APPLICATION_PATH" "$MCE_APPLICATION_IRB"
	exitStatus
fi

#Tar DB
if [ "$1" = "DB" ]
then
	echo "ADDING DB scripts TO PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" "$DB_CREATION_FILES"
	
	exitStatus
fi

#Tar entire couch db except logs
if [ "$1" = "DB_ALL" ]
then
	echo "ADDING ENTIRE COUCH DB  (*.couch) EXCEPT LOGS TO PACKAGE"
	#Add couch db directory contents excluding log files and hidden directories and files
	find "$COUCH_DB_PATH" -type f ! -name "*log*" \( ! -regex '.*/\..*' \) -exec tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" {} \;
	exitStatus
fi

#Tar User script file
if [ "$1" = "CUSTOM_SCRIPT" ]
then
	echo "ADDING USER SCRIPT TO PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" "$2"
	exitStatus
fi

#deb Package to be installed
if [ "$1" = "PACKAGE" ]
then
	echo "ADDING .deb PACKAGE TO BE INSTALLED TO FIRMWARE UPDATE PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME"  "$2"
	exitStatus
fi

#Tar User directroy
if [ "$1" = "DIR" ]
then
	echo "ADDING USER DIRECTORY TO PACKAGE"
	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" -C "$2" "$3"
	exitStatus
fi

#Add version files and rename pacakge as .irb
#******************Adding Home Directory as part of gpg command while automating this script in Jenkins****************************
if [ "$1" = "IRB" ]
then
	echo "ADDING VERSION FILES TO PACKAGE"

	tar -rf "$TEMP_PATH$TAR_PACKAGE_NAME" "$VERSION_DIRECTORY"

	echo "COMPRESS TAR FILE"
	tar -zcf "$TEMP_PATH$COMPRESSED_TAR_NAME" -C "$TEMP_PATH" "$TAR_PACKAGE_NAME"
	echo "ENCRYPT TAR FILE"
#******************Adding Home Directory as part of gpg command while automating this script in Jenkins****************************
	gpg --homedir $TEMP_PATH.gnupg -o "$TEMP_PATH$ENCRYPTED_TAR_NAME" --yes --batch --passphrase=archer -c "$TEMP_PATH$COMPRESSED_TAR_NAME"
	echo "RENAME GPG TO IRB"
	mv "$TEMP_PATH$ENCRYPTED_TAR_NAME" "$TEMP_PATH$IRB_PACKAGE_NAME"
	rm -f "$TEMP_PATH$TAR_PACKAGE_NAME"
	rm -f "$TEMP_PATH$COMPRESSED_TAR_NAME"

fi
echo "\n\nNOTE: IRB file created with this script is compatible with application version 5.3.4 and above"
