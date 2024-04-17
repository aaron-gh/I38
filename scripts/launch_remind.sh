#!/usr/bin/env bash

pgrep remind > /dev/null 2>&1 && exit 0
command remind -z '-k:${HOME}/.config/i3/scripts/reminder.sh %s &' ${HOME}/.reminders < /dev/null > /dev/null 2>&1 &
