#!/bin/sh
# export DISPLAY=:"0.0"
# XAUTHORITY=/home/insight/.Xauthority
# xdotool key CTRL+F5

exec su -l insight -c "export DISPLAY=:0; XAUTHORITY=/home/insight/.Xauthority; xdotool key CTRL+F5"
 # exec su -l insight -c "XAUTHORITY=/home/insight/.Xauthority"
 # exec su -l insight -c "xdotool key CTRL+F5"
