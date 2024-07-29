#!/bin/bash

selected=$(
echo "󰹑     Entire screen, save to folder
󱂬     Current window, save to folder
󰒉     Select area, save to folder
󰹑  󰅌   Entire screen, copy to clipboard
󱂬  󰅌   Current window, copy to clipboard
󰒉  󰅌   Select area, copy to clipboard" | rofi -dmenu -p "Screenshot: " -l 6 -format i -theme-str "configuration { show-icons: false; } window { width: 450px; }") 

[[ -z $selected ]] && exit

if [ $selected -eq 0 ]; then
    sleep 1; maim -m 10 "/home/$USER/Pictures/screenshots/$(date +'%X_%d-%m-%Y').png" -u
fi

if [ $selected -eq 1 ]; then
    sleep 1; maim -m 10 --window $(xdotool getactivewindow) "/home/$USER/Pictures/screenshots/$(date +'%X_%d-%m-%Y').png" -u
fi

if [ $selected -eq 2 ]; then
    sleep 1; maim --select "/home/$USER/Pictures/screenshots/$(date +'%X_%d-%m-%Y').png" -u
fi

if [ $selected -eq 3 ]; then
    sleep 1; maim -m 10 -u | xclip -selection clipboard -t image/png
fi

if [ $selected -eq 4 ]; then
    sleep 1; maim -m 10 -u --window $(xdotool getactivewindow) | xclip -selection clipboard -t image/png
fi

if [ $selected -eq 5 ]; then
    sleep 1; maim -m 10 -u --select | xclip -selection clipboard -t image/png
fi
