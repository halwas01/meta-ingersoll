#!/bin/sh


python /usr/src/ir/insight/Firmware/WebBackend/pyscripts/websocket.py --ip=0.0.0.0 &

/etc/init.d/rsyslog restart
service ssh stop

echo "************************************************************************"
echo "                      STARTING ESSEPROJECT                              "
echo "************************************************************************"

echo "`date` : Starting WBA" >> /dev/console
pm2 start /usr/src/ir/insight/Firmware/nwba/index.js --name "archer"
sleep 20


# echo "`date` : STARTUP - chromium" >> /dev/console
# sh /scripts/chromium.sh

echo "`date` : Starting QX Radio Driver" >> /dev/console
/usr/src/ir/insight/Firmware/ToolRadioDriver/Output/BIN/QXRD &
sleep 1

echo "`date` : Starting Port Monitor" >> /dev/console
/usr/src/ir/insight/Firmware/PortMonitor/Output/BIN/PORTMONITOR &
sleep 1

echo "`date` : Starting TCP Driver" >> /dev/console
/usr/src/ir/insight/Firmware/ToolTCPDriver/Output/BIN/QXTD &
sleep 1

echo "`date` : Starting Process Controller" >> /dev/console
/usr/src/ir/insight/Firmware/ProcessControl/Output/BIN/PC &
sleep 1 

echo "`date` : Starting License Manager" >> /dev/console
/usr/src/ir/insight/Firmware/LicenseManager/Output/BIN/LM &
sleep 1 

echo "`date` : Starting Network Settings" >> /dev/console
/usr/src/ir/insight/Firmware/NetworkSettings/Output/BIN/NETWORK_SET &
sleep 1 

echo "`date` : Starting QX USB Driver" >> /dev/console
/usr/src/ir/insight/Firmware/ToolUSBDriver/Output/BIN/QXUD &
sleep 1
sleep 1

echo "`date` : Starting PowerFocusOpenProtocol" >> /dev/console
/usr/src/ir/insight/Firmware/OpenProtocol/PowerFocusOpenProtocol/Output/BIN/PFOP &
sleep 1

echo "`date` : Starting Ford Open Protocol" >> /dev/console
/usr/src/ir/insight/Firmware/OpenProtocol/FOP/Output/BIN/FOP &
sleep 1

echo "`date` : Starting ToolsNet" >> /dev/console
/usr/src/ir/insight/Firmware/TN/Output/BIN/TN &
sleep 1

echo "`date` : Starting PFCS" >> /dev/console
/usr/src/ir/insight/Firmware/PFCS/Output/BIN/PFCS &
sleep 1

echo "`date` : Starting VwXml" >> /dev/console
/usr/src/ir/insight/Firmware/VwXml/Output/BIN/VW &
sleep 1

echo "`date` : Starting Firmware Manager" >> /dev/console
/usr/src/ir/insight/Firmware/FirmwareManager/Output/BIN/FWUP &
sleep 1

echo "`date` : Starting Barcode" >> /dev/console
/usr/src/ir/insight/Firmware/Barcode/Output/BIN/BAM &
sleep 1

echo "`date` : Starting Ethernet Barcode" >> /dev/console
/usr/src/ir/insight/Firmware/EthernetBarcode/Output/BIN/ETHBAM &
sleep 1

echo "`date` : Starting Pokayoke" >> /dev/console
/usr/src/ir/insight/Firmware/Pokayoke/Output/BIN/PY &
sleep 1

echo "`date` : Starting EOR Data Out" >> /dev/console
/usr/src/ir/insight/Firmware/EORDataOut/Output/BIN/EDO &
sleep 1

echo "`date` : Starting IOManager" >> /dev/console
/usr/src/ir/insight/Firmware/IOManager/Output/BIN/IOMgr &
sleep 1

echo "`date` : Starting Discovery" >> /dev/console
/usr/src/ir/insight/Firmware/Discovery/Output/BIN/DISCOVERY &
sleep 1


echo "`date` : Starting QX Tool Manager" >> /dev/console
/usr/src/ir/insight/Firmware/ToolManager/Output/BIN/QXX &
sleep 1

echo "`date` : Starting Backup & Restore" >> /dev/console
/usr/src/ir/insight/Firmware/BackupRestore/Output/BIN/BR &
##sleep 1

echo "`date` : Starting Watchdog" >> /dev/console
/usr/src/ir/insight/Firmware/Watchdog/Output/BIN/WD &
#sleep 1

sh /scripts/browserrefresh.sh

ifup eth0
ifconfig eth1 up
sleep 5
ifup eth1
