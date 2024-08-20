#!/bin/bash
status=$(pgrep -a xautolock)

if [ "$status" != "" ]; then
    echo "^c#333c4c^"
else
    echo "^c#81a1c1^"
fi
