#!/usr/bin/env bash

path="$(readlink -f $0)"
path="${path%/*/*}"
path="${path##*/}"
if [[ "$path" == "i3" ]]; then
    workSpace="$(i3-msg -t get_workspaces \
        | jq '.[] | select(.focused==true).name' \
        | cut -d"\"" -f2)"
else
    workSpace="$(swaymsg -t get_workspaces \
        | jq '.[] | select(.focused==true).name' \
        | cut -d"\"" -f2)"
fi
left=9
right=0
msg="Workspace ${workSpace}"
if ! [[ "${workSpace}" =~ ^[0-9]+$ ]]; then
    right=9
else
    if [[ ${workSpace} -eq 10 ]]; then
        left=0
        right=9
    elif [[ ${workSpace} -eq 5 ]]; then
        right=9
    elif [[ ${workSpace} -gt 5 ]]; then
        right=9
        ((left-=${workSpace}))
    else
        ((right+=${workSpace}))
    fi
fi
play -nqV0 synth pi fade 0 .25 .15 pad 0 1 reverb overdrive riaa norm -8 speed 1 remix v0.${left} v0.${right} &
spd-say -P important -Cw "${msg}"
