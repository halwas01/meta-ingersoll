
echo"clearing previous message queue"
ipcrm -a
sleep 1
echo "kill the websocket if it was running previously"
pkill -f "python3 /usr/src/ir/insight/Firmware/WebBackend/pyscripts/websocket.py --ip=0.0.0.0"
sleep 1
echo "kill node if it was already running"
pkill -f "node /usr/src/ir/insight/Firmware/nwba/index.js"
sleep 1
echo "killing all the firmware modules"
killall PC
killall QXTD
killall QXX
killall IOMgr
killall PORTMONITOR
sleep 1

