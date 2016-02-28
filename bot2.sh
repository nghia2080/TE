#!/bin/bash
while true
do
DISPLAY=:1 chromium --no-sandbox --new-window  --disable-popup-blocking --incognito "http://247webhits.com/exchange?key=gxjepc7sqbgzshrvdj7j6otp4xdi711sz8xntashuwd0thq3trm7bqfwnpo3wvjz" "http://exchange.hornyte.com/mE1qwiLxd7tl9dPYWlp5k6w74U03ZDAy" & sleep 1000
pkill -f -9 chromium
sleep 5
done