#!/bin/bash
setxkbmap us
pkill picom
dunstctl set-paused true && i3lock -i ~/.local/share/wallpapers/wallpaper-lock.png -u -n
dunstctl set-paused false && setxkbmap -layout 'us,rs,rs' -variant ',latinyz,' -option 'caps:super'
picom --config ~/.config/picom/picom.conf
sleep 1
. ~/.scripts/weather_status.sh