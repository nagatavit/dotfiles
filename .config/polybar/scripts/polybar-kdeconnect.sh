#!/usr/bin/env bash

# CONFIGURATION
LOCATION=0
YOFFSET=0
XOFFSET=0
WIDTH=12
WIDTH_WIDE=24
THEME=solarized

# Color Settings of Icon shown in Polybar
COLOR_DISCONNECTED='#000'       # Device Disconnected
COLOR_NEWDEVICE='#00f'          # New Device
COLOR_BATTERY_100='#00f0ff'        # Battery == 100
COLOR_BATTERY_90_99='#0f0'      # 90 <= Battery < 100
COLOR_BATTERY_70_80='#78ec6c'   # 70 <= Battery < 90
COLOR_BATTERY_50_60='#a9f36a'   # 50 <= Battery < 60
COLOR_BATTERY_30_40='#ddf969'   # 30 <= Battery < 50
COLOR_BATTERY_20_30='#fefe69'   # 20 <= Battery < 30
COLOR_BATTERY_LOW='#f00'        # Battery <  20

# Icons shown in Polybar
# ICON_100=''
ICON_100=''
ICON_90=''
ICON_70=''
ICON_50=''
ICON_30=''
ICON_20=''
ICON_LOW=''
# ICON_QUESTION=''
ICON_DISCONECTED=''

ICON_SMARTPHONE=''
ICON_TABLET=''
SEPERATOR=' '

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

show_devices (){
    IFS=$','
    devices=""
    for device in $(qdbus --literal org.kde.kdeconnect /modules/kdeconnect org.kde.kdeconnect.daemon.devices); do
        deviceid=$(echo "$device" | awk -F'["|"]' '{print $2}')
        devicename=$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.name)
        devicetype=$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.type)
        isreach="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.isReachable)"
        istrust="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.isTrusted)"
        if [ "$isreach" = "true" ] && [ "$istrust" = "true" ]
        then
            battery="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid/battery" org.kde.kdeconnect.device.battery.charge)"
            icon=$(get_icon "$battery" "$devicename")
            devices+="%{A1:$DIR/polybar-kdeconnect.sh -n '$devicename' -i $deviceid -b $battery -m:}$icon%{A}$SEPERATOR"
        elif [ "$isreach" = "false" ] && [ "$istrust" = "true" ]
        then
            devices+="$(get_icon -1 "$devicetype")$SEPERATOR"
        else
            haspairing="$(qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$deviceid" org.kde.kdeconnect.device.hasPairingRequests)"
            if [ "$haspairing" = "true" ]
            then
                show_pmenu2 "$devicename" "$deviceid"
            fi
            icon=$(get_icon -2 "$devicetype")
            devices+="%{A1:$DIR/polybar-kdeconnect.sh -n $devicename -i $deviceid -p:}$icon%{A}$SEPERATOR"

        fi
    done
    echo "${devices::-1}"
}

show_menu () {
    menu="$(rofi -sep "|" -dmenu -i -p "$DEV_NAME" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -theme $THEME -width $WIDTH -hide-scrollbar -line-padding 4 -padding 10 -lines 5 <<< "Battery: $DEV_BATTERY%|Ping|Find Device|Send File|Browse Files|Unpair")"
                case "$menu" in
                    *Ping) qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/ping" org.kde.kdeconnect.device.ping.sendPing ;;
                    *'Find Device') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/findmyphone" org.kde.kdeconnect.device.findmyphone.ring ;;
                    *'Send File') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/share" org.kde.kdeconnect.device.share.shareUrl "file://$(zenity --file-selection)" ;;
                    *'Browse Files')
                        if "$(qdbus --literal org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.isMounted)" == "false"; then
                            qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.mount
                        fi
                        qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID/sftp" org.kde.kdeconnect.device.sftp.startBrowsing
                        ;;
                    *'Unpair' ) qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID" org.kde.kdeconnect.device.unpair
                esac
}

show_pmenu () {
    menu="$(rofi -sep "|" -dmenu -i -p "$DEV_NAME" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -theme $THEME -width $WIDTH -hide-scrollbar -line-padding 1 -padding 20 -lines 1<<<"Pair Device")"
                case "$menu" in
                    *'Pair Device') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$DEV_ID" org.kde.kdeconnect.device.requestPair
                esac
}

show_pmenu2 () {
    menu="$(rofi -sep "|" -dmenu -i -p "$1 has sent a pairing request" -location $LOCATION -yoffset $YOFFSET -xoffset $XOFFSET -theme $THEME -width $WIDTH_WIDE -hide-scrollbar -line-padding 4 -padding 20 -lines 2 <<< "Accept|Reject")"
                case "$menu" in
                    *'Accept') qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$2" org.kde.kdeconnect.device.acceptPairing ;;
                    *) qdbus org.kde.kdeconnect "/modules/kdeconnect/devices/$2" org.kde.kdeconnect.device.rejectPairing
                esac

}
get_icon () {
    initial="$(echo $2 | head -c 3)"
    case $1 in
    # "-1")     ICON="%{F$COLOR_DISCONNECTED}$ICON_DISCONECTED%{F-}" ;;
    "-1" | "-2" )     ICON="" ;;
    # "-2")     ICON="%{F$COLOR_NEWDEVICE}$ICON_QUESTION%{F-}" ;;
    100)      ICON="%{F$COLOR_BATTERY_100}$initial$ICON_90$1%%{F-}" ;;
    9*)       ICON="%{F$COLOR_BATTERY_90_99}$initial$ICON_90$1%%{F-}" ;;
    7*|8*)    ICON="%{F$COLOR_BATTERY_70_80}$initial$ICON_70$1%%{F-}" ;;
    5*|6*)    ICON="%{F$COLOR_BATTERY_50_60}$initial$ICON_50$1%%{F-}" ;;
    3*|4*)    ICON="%{F$COLOR_BATTERY_30_40}$initial$ICON_30$1%%{F-}" ;;
    2*)       ICON="%{F$COLOR_BATTERY_20_30}$initial$ICON_20$1%%{F-}" ;;
    *)        ICON="%{F$COLOR_BATTERY_LOW}$initial$ICON_LOW$1%%{F-}" ;;
    esac
    echo $ICON
}

notify_bat () {
    notify-send -t 900 "$DEV_NAME" "Battery: $DEV_BATTERY%"
}

unset DEV_ID DEV_NAME DEV_BATTERY
while getopts 'di:n:b:mp' c
do
    # shellcheck disable=SC2220
    case $c in
        d) show_devices ;;
        i) DEV_ID=$OPTARG ;;
        n) DEV_NAME=$OPTARG ;;
        b) DEV_BATTERY=$OPTARG ;;
        m) notify_bat  ;;
        # m) show_menu  ;;
        p) show_pmenu ;;
    esac
done
