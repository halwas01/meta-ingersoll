#!/bin/sh

#clean the controller cache
# echo "`date` : Clear Chromium Cache" >> /dev/console
# rm -rf /home/user/Chromium/Default/Cache 

# echo "`date` : Check for X Server to be up" >> /dev/console
# ps auxw | grep xterm  | grep -v grep > /dev/null
# while [ $? != 0 ]
# do
  # echo "`date` : X not up.  Please Wait" >> /dev/console
  # sleep 1 
  # ps auxw | grep xterm  | grep -v grep > /dev/null 
# done
# echo "`date` : X Server is up" >> /dev/console 
#sleep 1 

#start chromium
echo "`date` : Starting Chromium" >> /dev/console
exec su -l insight -c "export DISPLAY=:0; chromium --user-data-dir=/home/insight/Chromium --touch-events --touch-devices=2 --disable-session-crashed-bubble --disable-pinch  --window-position=0,0 --window-size=480,800 --overscroll-history-navigation=0 --disable-download-notification --disable-translate --kiosk --app=http://127.0.0.1"   
