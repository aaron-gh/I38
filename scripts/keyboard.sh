#!/usr/bin/env bash


# This script is a modified version of i3-keyboard-layout.
# Originally Copyright (c) 2018 Sergio Gil.
# https://github.com/porras/i3-keyboard-layout
# This modified script, like the rest of I38, is released under the WTFPL license.
# The original work was released under the MIT license.


set -e

get_kbdlayout() {
  layout=$(setxkbmap -query | grep -oP 'layout:\s*\K([\w,]+)')
  variant=$(setxkbmap -query | grep -oP 'variant:\s*\K(\w+)')
  echo "$layout" "$variant"
}

set_kbdlayout() {
  eval "array=($1)"
  setxkbmap "${array[@]}" &&
    spd-say -P important -Cw "${array[@]}"
}

cycle() {
  current_layout=$(get_kbdlayout | xargs)
  layouts=("$@" "$1") # add the first one at the end so that it cycles
  index=0
  while [ "${layouts[$index]}" != "$current_layout" ] && [ $index -lt "${#layouts[@]}" ]; do index=$[index +1]; done
  next_index=$[index +1]
  next_layout=${layouts[$next_index]}
  set_kbdlayout "$next_layout"
}


subcommand="$1"
shift || exit 1

case $subcommand in
  "get")
    echo -n $(get_kbdlayout)
    ;;
  "cycle")
    cycle "$@"
    ;;
esac

exit 0
