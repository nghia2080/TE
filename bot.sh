#!/bin/bash
if [ `ps -e | grep -c bot.sh` -gt 2 ]; then echo "Already running, i'm killing old process!"; pkill -9 -o bot.sh; fi
usage() { echo -e "Usage: $0 [-t <Timer to restart chrome (seconds)>] -o \"account,password\" [-l <Separate traffic exchange links with space delimiter(in quote)>]\nExample: $0 -t 3600 -l http://22hit...\nExample: $0 -t 3600 -l \"http://22hit... http://247webhit... http://...\"\nExample: $0 -t 3600 -o \"otohit_account,otohits_password\" -l \"http://22hit...\"\nExample: $0 -t 3600 -o \"otohit_account,otohits_password\"" 1>&2; exit 1; }
[ $# -eq 0 ] && usage
otolink=""
while getopts ":ht:l:o:" arg; do
    case $arg in
        t)
            timer=${OPTARG}
            ;;
        l)
            links=${OPTARG}
            ;;
        o)
            IFS=', ' read -r -a otohits <<< ${OPTARG}
            otolink="http://www.otohits.net/account/wfautosurf"
            ;;
        h | *)
            usage
            exit 1
            ;;
    esac
done
if [ -z "${timer}" ]; then
    usage
fi
echo "Checking update Chromium and related package..."
#wget --no-check-certificate -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
#echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
killall apt-get
killall dpkg
apt-get update
apt-get clean
apt-get autoclean
apt-get autoremove -y
apt-get install -y psmisc lsb-release
apt-get install -y xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable xfonts-cyrillic x11-apps
apt-get install -y gtk2-engines-pixbuf libexif12 libxpm4 libxrender1 libgtk2.0-0
apt-get install -y libnss3 libgconf-2-4
if [[ `lsb_release -si` == "Debian" ]]
then
    apt-get install -y chromium
    browser="chromium"
fi
if [[ `lsb_release -si` == "Ubuntu" ]]
then
    apt-get install -y chromium-browser
    browser="google-chrome"
fi
if [ -z "${browser}" ]; then
    echo "Sorry, this script does not support your OS, please use Ubuntu/Debian Linux OS!"
    exit 1
fi
apt-get install -y pepperflashplugin-nonfree
update-pepperflashplugin-nonfree --install
#apt-get install -y google-chrome-stable
dpkg --configure -a
apt-get install -f -y
if [[ `lsb_release -rs` == "12.04" ]]
then
    apt-get install -y defoma x-ttcidfont-conf
    (cd /var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType && mkfontdir > fonts.dir)
fi
echo "Killing old chrome/chromium and virtual X display..."
pkill -9 -o chrome
killall -9 chrome
pkill -9 -o chromium
killall -9 chromium
pkill -9 -o chromium-browser
killall -9 chromium-browser
killall -9 Xvfb
killall -9 sleep
while :
do
    echo "Downloading chrome user data dir profile..."
    wget --no-check-certificate http://duclvz.github.io/chromeTE.tar.gz -O /root/chromeTE.tar.gz
    echo "Recreating/extracting chrome user data dir..."
    rm -fr /root/chromeTE/
    tar -xzf /root/chromeTE.tar.gz -C /root/
    echo "Starting virtual X display..."
    Xvfb :2 -screen 1 1024x768x16 -nolisten tcp & disown
    echo "Starting chrome TE viewer..."
    echo "Open link $links"
    if [ ! -z "${otohits}" ]
    then
        sed -i "s/otoacc/${otohits[0]}/g" /root/chromeTE/Default/Extensions/jikpgdfgobpifoiiojdngpekpacflahh/1.0_0/account.json
        sed -i "s/otopass/${otohits[1]}/g" /root/chromeTE/Default/Extensions/jikpgdfgobpifoiiojdngpekpacflahh/1.0_0/account.json
    fi
    DISPLAY=:2.1 ${browser} --no-sandbox --user-data-dir="/root/chromeTE" --user-agent="Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36" --disable-popup-blocking --incognito ${otolink} ${links} & disown
    browserPID=$!
    sleep ${timer}
    timeplus=$(shuf -i 10-100 -n 1)
    sleep ${timeplus}
    echo "Kill chrome PID $browserPID"
    kill $browserPID
    echo "Killing virtual X display..."
    killall -9 Xvfb
    echo "Restart TE bots after $((${timer}+${timeplus})) seconds."
done
