#!/usr/bin/env bash

# Not for multiple screens.
# Get the name of the screen.
screenName="$(xrandr --query | grep "connected" | cut -d ' ' -f1 | head -n 1)"

menuOptions=(
    "1.0" "Maximum Brightness"
    "0.75" "75 percent"
    "0.5" "50 percent"
    "0.25" "25 percent"
    "0" "Screen Curtain"
)

brightness="$(yad --list --title "I38" --text "Set Screen Brightness" --columns 2 --hide-column 1 --column "" --column "Select" "${menuOptions[@]}")"

if [[ ${#brightness} -lt 1 ]]; then
    exit 0
fi

xrandr --output ${screenName} --brightness ${brightness%%|*} &&
    spd-say -P important -Cw "Screen set to ${brightness##*|}."

exit 0
