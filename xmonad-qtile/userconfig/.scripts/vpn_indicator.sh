#!/bin/bash

vpn=$((pgrep -a openvpn$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1 && echo down) | head -n 1)

if [ "$vpn" = "down" ]; then
    echo "<span color='#262320'></span>"
else
    echo "<span color='#c27b62'></span>"
fi