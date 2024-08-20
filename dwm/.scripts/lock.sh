#!/bin/bash
setxkbmap us
dunstctl set-paused true && i3lock -i ~/.local/share/wallpapers/wallpaper-lock.png -u -n
dunstctl set-paused false && . ~/.scripts/kblayout.sh
