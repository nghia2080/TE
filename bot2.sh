#!/bin/bash
while true
do
DISPLAY=:1 nohup chromium --no-sandbox --new-window  --disable-popup-blocking --incognito "http://247webhits.com/exchange?key=gxjepc7sqbgzshrvdj7j6otp4xdi711sz8xntashuwd0thq3trm7bqfwnpo3wvjz" & sleep 1000
pkill -f -9 chromium
sleep 5
done