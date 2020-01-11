#!/bin/sh

# brightness
curBright= light -G

case "$1" in
    --get)
        light -G
        ;;
    --up)
        light -A 5
        ;;
    --down)
        light -U 5
        ;;
    --max)
        light -S 100
        ;;
    --min)
        light -S 0.02
        ;;
esac
