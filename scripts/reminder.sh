#!/usr/bin/env bash

error() {
        yad --form --selectable-labels --title "I38 - Reminder Error" --field="${*}":lbl --button="Close!gtk-ok":0
}

message() {
        yad --form --selectable-labels --title "I38 - Reminder" --field="${*}":lbl --button="Close!gtk-ok":0
}

add_custom_reminder() {
    info="$(yad --form --selectable-labels  \
        --title "I38 - New Custom Reminder" \
        --field="Comment for ~/.reminders file":lbl "" \
        --field="Reminder Comment" "" \
        --field="Reminder entry. Remember for notifications, it must ccontain the +5 after the time and the %2. at the end of the MSG.":lbl "" \
        --field="Reminder" "REM  at  +5 MSG  %2.")"
    if [[ $? -eq 1 || $? -eq 252 ]]; then
        return
    fi
    while [[ $info =~ \|\| ]]; do
        info="${info//||/|}"
    done
    info="${info#|#}"
    # Get information for reminder into an array
    IFS='|' read -a reminder <<< $info
    if [[ "${reminder[0]}" != "# " ]]; then
        echo "# ${reminder[0]}" >> ~/.reminders
    fi
    if [[ "${reminder[1]}" != "REM  at  +5 MSG  %2." ]]; then
    echo "${reminder[1]}" >> ~/.reminders
    message "Custom reminder added."
    else
    error "No reminder text entered, No action taken."
    fi
}


add_weekly_reminder() {
    info="$(yad --form --selectable-labels  \
        --title "I38 - New Weekly Reminder" \
        --field="Reminder Text" "" \
        --field="Select Days":lbl "" \
        --field="Sunday":chk "FALSE" \
        --field="Monday":chk "FALSE" \
        --field="Tuesday":chk "FALSE" \
        --field="Wednesday":chk "FALSE" \
        --field="Thursday":chk "FALSE" \
        --field="Friday":chk "FALSE" \
        --field="Saturday":chk "FALSE" \
        --field="Select Hour:":num '1!1..12' \
        --field="Select Minute:":num '0!0..59' \
        --field="Select AM or PM":cb 'AM!PM' \
        --button="Cancel:1" \
        --button="Create Reminder:0")"

    # Get information for reminder into an array
    IFS='|' read -a reminder <<< $info

    # Change checked days into their name.
    reminder[2]="${reminder[2]/TRUE/Sun}"
    reminder[3]="${reminder[3]/TRUE/Mon}"
    reminder[4]="${reminder[4]/TRUE/Tue}"
    reminder[5]="${reminder[5]/TRUE/Wed}"
    reminder[6]="${reminder[6]/TRUE/Thu}"
    reminder[7]="${reminder[7]/TRUE/Fri}"
    reminder[8]="${reminder[8]/TRUE/Sat}"

    # Make sure we have reminder text
    if [[ ${#reminder[0]} -lt 3 ]]; then
    error "No reminder text given, addition canceled."
    return
    fi
    reminderEntry="REM "
    noDays=1
    for ((i=2;i<=8;i++)) ; do
        if [[ "${reminder[i]}" != "FALSE" ]]; then
            reminderEntry+="${reminder[i]} "
            noDays=0
        fi
    done
    if [[ $noDays -eq 1 ]]; then
        error "No days were selected for the reminder. Nothing changed."
        return
    fi
    reminderEntry+="AT ${reminder[9]}:${reminder[10]}${reminder[11]} +5 REPEAT weekly MSG ${reminder[0]} %2."
    echo "# Added by I38." >> ~/.reminders
    echo "$reminderEntry" >> ~/.reminders
    if [[ -N ~/.reminders ]]; then
        message "Reminder added."
    else
        error "Something went wrong. The reminder was not added."
    fi
}

view_reminders() {
mapfile -t lines < ~/.reminders
                                                                                                                                                                          
    # Create an empty array to store cleaned-up reminders
    yadMenu=()
                                                                                                                                                                          
    # Iterate through the reminder lines and clean them up
    for i in "${lines[@]}"; do
        # Remove the "REM" prefix and leading/trailing spaces
        formattedLine="${i#*REM }"
        # Remove MSG from the output.
        formattedLine="${formattedLine/MSG /}"
        # remove the usually %2. from the end of the line, but accept any digit in case someone changes it.
        formattedLine="${formattedLine% %[[:digit:]].}"
                                                                                                                                                                          
        # Add to the menu
        yadMenu+=("$formattedLine")
    done
                                                                                                                                                                          
    # Display the reminders
    reminder="$(yad --list --title "I38 - Reminders" --text "Current reminders:" \
        --column "Reminder" "${yadMenu[@]}" \
        --button="Close:1" --button="Delete:0" --response=1)"
        if [[ $? -ne 0 ]]; then
            return
        fi
        if [[ "${reminder:0:1}" == "#" ]]; then
            error "Please select the actual reminder to be deleted, anything starting with # is only a comment. Nothing changed."
            return
        fi
        # Remove the | from the end of reminder
        reminder="${reminder%|}"
        # Find the index to remove from lines.
        for i in "${!yadMenu[@]}" ; do
        if [[ "${yadMenu[i]}" == "${reminder}" ]]; then
        # Delete selected reminder and possible preceeding comment.
        commentIndex=$((i - 1))
        if [[ "${lines[commentIndex]:0:1}" == "#" ]]; then
            unset lines[$commentIndex]
        fi
        unset lines[$i]
        message "Reminder deleted."
        printf "%s\n" "${lines[@]}" > ~/.reminders
        fi
        done
}

if ! command -v remind &> /dev/null ; then
    error "Please install remind. For notifications, please make sure to have notification-daemon and notify-send as well. Run i38.sh to regenerate your i3 config after the needed components are installed."
    exit 1
fi

if [[ $# -ne 0 ]]; then
    sox -ndqV0 synth .1 tri 600 norm -9 pad .05 repeat
    notify-send "$*"
    exit 0
fi

while : ; do
    action=$(yad --title "I38 - Reminders" --form \
        --button="_Add Reminder!gtk-ok":0 \
        --button="_View Reminders!gtk-info":2 \
        --button="Add Custom Reminder!gtk-edit":3 \
        --button="Close!gtk-cancel":1 \
        --separator="")
                                                                                                                                                                          
    case $? in
        0)
            # Handle "Add Weekly Reminder" button click
            add_weekly_reminder
            ;;
        1|252)
            # Handle "Close" button click and escape.
            exit 0
            ;;
        2)
            # View reminders
            view_reminders
        ;;
        3)
            # Handle "Add Custom Reminder" button click
            add_custom_reminder
            ;;
    esac
done
