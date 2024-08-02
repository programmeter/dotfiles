#!/bin/bash

vpn=$((pgrep -a openvpn$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1 && echo down) | head -n 1)

if [ "$vpn" = "down" ]; then
    echo "<fc=#262320> </fc>"
else
    echo "<fc=#425a61> </fc>"
fi
