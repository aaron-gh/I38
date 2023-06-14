#!/usr/bin/env bash

path="$(readlink -f $0)"
path="${path%/*/*}"
path="${path##*/}"
if [[ "$path" == "i3" ]]; then
mapfile -t windowList < <(python3 -c '
import i3ipc

i3 = i3ipc.Connection()

for con in i3.get_tree():
    if con.window and con.parent.type != "dockarea":
        print(con.window)
        print(con.name)')
id="$(yad --title "I38" --list --separator "" --column "id" --column "Select Window" --hide-column 1 --print-column 1 "${windowList[@]}")"
if [[ -z "${id}" ]]; then
    exit 0
fi
    i3-msg \[id="${id}"\] focus
else
mapfile -t windowList < <(python3 -c '
import i3ipc
                                                                                                                                                                
i3 = i3ipc.Connection()
                                                                                                                                                                
for con in i3.get_tree():
    if con.window or con.type == "con":
        if con.name:
            print(con.window)
            print(con.name)')
                                                                                                                                                                
# Remove the first entry if it is "none"
if [[ "${windowList[0]}" == "none" ]]; then
    unset "windowList[0]"
fi
                                                                                                                                                                
id="$(yad --title "I38" --list --separator "" --column "id" --column "Select Window" --hide-column 1 --print-column 1 "${windowList[@]}")"
                                                                                                                                                                
if [[ -z "${id}" ]]; then
    exit 0
fi
swaymsg \[id="${id}"\] focus
fi
