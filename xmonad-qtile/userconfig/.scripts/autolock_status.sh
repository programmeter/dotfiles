#!/bin/bash
autolock=$(pgrep -a xautolock$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

if [ "$autolock" != "" ]; then
    echo "<span color='#262320'></span>"
else
    echo "<span color='#c27b62'></span>"
fi
