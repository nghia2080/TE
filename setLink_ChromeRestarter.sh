#!/bin/bash
#
# Set your 22hits.com URL here
# Example:
# HITS_URL="http://22hits.com/exchange.php?0123456789"
HITS_URL="http://22hits.com/exchange.php?key=aaa551645f59519590fcd8082d49d0038aa0492c215bf3d977520d7236d9c91d"
HITS_URL2="http://goo.gl/NBJAcz"
HITS_URL3="http://exchange.hornyte.com/mE1qwiLxd7tl9dPYWlp5k6w74U03ZDAy"

COUNTER=0
while true
do
if [ ! `pgrep chrome-bin` ] ; then
echo -e 'nOh no, Chrome is not running! Restarting it now! nn'
echo Chrome has been restarted $COUNTER times
let COUNTER=COUNTER+1
nohup google-chrome --incognito $HITS_URL $HITS_URL2 $HITS_URL3
fi
sleep 30
done