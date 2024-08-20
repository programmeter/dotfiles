#!/bin/bash
 autolock=$(pgrep -a xautolock$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

 if [ "$autolock" != "" ]; then
     pkill xautolock
 else
     . ~/.scripts/autolock-start.sh &
 fi
