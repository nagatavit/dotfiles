#!/bin/bash

ICON=""

case "$(echo -e "Cancel\nConfirm" | rofi -dmenu -theme confirmation_dialog -mesg "$ICON Poweroff")" in
    "Cancel")  exit 1;;
    "Confirm") poweroff;;
esac

exit 1
