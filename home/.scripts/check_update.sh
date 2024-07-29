#!/bin/bash
echo $(apt-get -s upgrade | grep upgraded, | cut -c-2)
