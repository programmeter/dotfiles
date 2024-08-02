#!/bin/bash

playerctlstatus=$(playerctl status 2> /dev/null)
playerctlstatusrandom=$(playerctl -p somethingsomething status 2> /dev/null)

if [ "$playerctlstatus" = "$playerctlstatusrandom" ]; then
    xset dpms force suspend
    . ~/.scripts/lock.sh
fi
