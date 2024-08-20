#!/bin/bash
~/.scripts/lock.sh &
xss-lock --transfer-sleep-lock -- ~/.scripts/lock.sh &
~/.scripts/start_xautolock.sh &
xset s 0 0 dpms 0 0 0 &
xfce4-session &
xfsettingsd &
pipewire &
dunst &
xinput set-prop 'SteelSeries SteelSeries Rival 3' 'libinput Accel Profile Enabled' 0, 1 &
xinput set-prop 'SteelSeries SteelSeries Rival 3' 'libinput Accel Speed' '-0.5' &
xrandr --output DP-2 --primary --mode 2560x1440 --rate 164.83 &
#rsync -r -t -v --progress --delete -s --update --exclude .steam/ --exclude Downloads --exclude .local/share/Trash ~ "/media/martin/'Debian Backup'/home-backup/"
steam -silent &
