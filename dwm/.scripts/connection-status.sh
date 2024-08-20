#!/bin/bash

HOST=debian.org

ping -c1 $HOST 1>/dev/null 2>/dev/null
SUCCESS=$?

if [ $SUCCESS -eq 0 ]
then
    echo "^c#81a1c1^󰈀"
else
    echo "^c#333c4c^󰈀"
fi
