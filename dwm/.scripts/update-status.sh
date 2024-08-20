#!/bin/bash

aptupgrades=$(apt-get -s upgrade | grep upgraded, | cut -c-2)

if [ "$aptupgrades" = "0 " ]; then
    echo ""
else
    echo "^c#333c4c^ / ^c#a3be8c^ ^c#d8dee9^$aptupgrades"
fi
