#!/bin/bash
 autolock=$(pgrep -a xautolock$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

 if [ "$autolock" != "" ]; then
     killall xautolock
     pkill -SIGRTMIN+10 i3blocks
 else
     . ~/.scripts/start_xautolock.sh &
     pkill -SIGRTMIN+10 i3blocks
 fi
