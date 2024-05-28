#!/bin/bash

if ! command -v acpi &> /dev/null; then
    exit 0
fi

while : ; do
    acpi_output=$(acpi -b)
    status=$(echo "$acpi_output" | awk -F'[,:%]' '{print $2}')
    capacity=$(echo "$acpi_output" | awk -F'[,:%]' '{print $3}')

    if [[ "$status" == "Discharging" ]]; then
        if [[ "$capacity" -le 15 ]] && [[ "$capacity" -gt 10 ]]; then
            play -qV0 "|sox -n -p synth saw E2 fade 0 0.25 0.05" "|sox -n -p synth saw E2 fade 0 0.25 0.05" norm -7
            spd-say -P important "Battery $capacity percent."
        elif [[ "$capacity" -le 10 ]] && [[ "$capacity" -gt 5 ]]; then
            play -qV0 "|sox -n -p synth saw E2 fade 0 0.25 0.05" "|sox -n -p synth saw E2 fade 0 0.25 0.05" norm -7
            spd-say -P important "Battery $capacity percent."
        elif [[ "$capacity" -lt 5 ]]; then
            play -qV0 "|sox -np synth sq C#5 sq D#5 sq F#5 sq A5 sq C#6" remix - fade 0 5.5 5 pitch -400
            spd-say -P important "Battery $capacity percent."
        fi
    fi

    sleep 5
done

exit 0

