#!/bin/bash

ICON=""

case "$(echo -e "Cancel\nConfirm" | rofi -dmenu -theme confirmation_dialog -mesg "$ICON Restart")" in
    "Cancel")  exit 1;;
    "Confirm") reboot;;
esac

exit 1
