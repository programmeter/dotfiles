#!/bin/bash

vpn=$((pgrep -a openvpn$ | head -n 1 | awk '{print $NF }' | cut -d '.' -f 1 && echo down) | head -n 1)

if [ "$vpn" = "down" ]; then
    /usr/sbin/openvpn --config /etc/openvpn/CG_Serbia.conf
else
    killall -SIGINT openvpn
fi
