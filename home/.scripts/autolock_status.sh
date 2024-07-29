#!/bin/bash
autolock=$(pgrep -a xautolock$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1)

if [ "$autolock" != "" ]; then
    echo "<fc=#262320></fc>"
else
    echo "<fc=#425a61></fc>"
fi
