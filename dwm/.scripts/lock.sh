#!/bin/bash
setxkbmap us
dunstctl set-paused true && slock
dunstctl set-paused false && . ~/.scripts/kblayout.sh
