#!/bin/bash

HOST=fedoraproject.org

ping -c1 $HOST 1>/dev/null 2>/dev/null
SUCCESS=$?

if [ $SUCCESS -eq 0 ]
then
    echo "<span color='#c27b62'> </span>"
else
    echo "<span color='#262320'> </span>"
fi
