#!/bin/zsh

zmodload zsh/regex

BG_FOLDER=~/Bilder/BG
XRANDR_STATE=$(xrandr)

function set_background() {
    [[ $(cat ~/.fehbg) -regex-match "$BG_FOLDER/(.*)'" ]] && CURRENT_BG=$match
    BACKGROUND=$(ls -1 -d $BG_FOLDER/* | grep -vF $CURRENT_BG | sort -R | head -n 1)
    feh --bg-max $BACKGROUND
}

case "_$1" in
    (_dp)
        if [[ $XRANDR_STATE -regex-match "DP2 connected" ]] then
            xrandr --output LVDS1 --off --output DP2 --auto --primary
            set_background
        else
            echo "DP2 is not connected."
        fi
    ;;
    (_vga)
        if [[ $XRANDR_STATE -regex-match "VGA1 connected" ]] then
            xrandr --output LVDS1 --auto --primary --output VGA1 --auto --left-of LVDS1
            set_background
            [[ $(xrandr) -regex-match "VGA1 connected (\d+x\d+)" ]] && echo "VGA1 resolution: " $match[1]
        else
            echo "VGA1 is not connected."
        fi
    ;;
    (_lv)
        xrandr --output LVDS1 --auto --primary --output VGA1 --off --output DP2 --off
        set_background
    ;;
    (_)
        set_background
        echo $XRANDR_STATE
    ;;
esac
