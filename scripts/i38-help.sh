#!/usr/bin/env bash


configPath="$(readlink -f $0)"
configPath="${configPath%/*/*}"

if [[ -f "${configPath}/config" ]]; then
    mod="$(grep 'set $mod ' "${configPath}/config" | cut -d ' ' -f3)"
    mod="${mod//Mod1/Alt}"
    mod="${mod//Mod4/Super}"
    mapfile helpText < <(sed -e '/set \($mod\|mod\)/d' \
        -e '/set $ws/d' \
        -e 's/bindsym/Key:/g' \
        -e 's/Mod1/Alt/g' \
        -e 's/, mode "default"//g' \
        -e 's/--no-startup-id //g' \
        -e 's/$ws\([0-9]\)/\1/g' \
        -e 's/play \(.*\)& //g' \
        -e "s/\$mod/$mod/g" "${configPath}/config")
else
    exit 1
fi
for i in "${!helpText[@]}" ; do
    helpText[$i]="${helpText[$i]//${configPath}\/scripts\//}"
    helpText[$i]="${helpText[$i]/.sh/}"
    helpText[$i]="${helpText[$i]/, exec announce*/$'\n'}"
    helpText[$i]="${helpText[$i]/, exec spd-say*/$'\n'}"
done
helpText+=("End of text. Please press Control+Home to jump to the beginning of this document.")
echo "${helpText[@]}" | yad --text-info --show-cursor --title "I38 help" --button "Close:0" --listen

exit 0
