#!/bin/bash

location=""

# Parse location and check if it's set
location_curl=$(echo "$location" | sed -e "s/ /+/g")
if [ -z "$location" ]; then
    dunstify "weather_status.sh" "You must set location to query" -i "dialog-error" && exit
fi

all_data=$(curl https://wttr.in/"$location_curl"?format="%s%c%t+(%f)" --silent --max-time 7.0)
sunset_hour=$(echo "$all_data" | cut -c 1-2)
current_hour=$(date +"%k" | sed -e "s/ //g")
icon_emoji=$(echo "$all_data" | cut -c 9-15 | sed -e "s/ //g")
weather=$(echo "$all_data" | cut -c 17-)

# Set greeting based on current time
if [ $current_hour -ge 19 ]; then
    greeting="Good evening!"
elif [ $current_hour -ge 12 ]; then
    greeting="Good day!"
elif [ $current_hour -ge 6 ]; then
    greeting="Good morning!"
else
    greeting="Good night!"
fi

if [ -z "$weather" ] || [ -z "$icon_emoji" ]; then
    dunstify "$greeting" && exit
fi

# Set icon based on weather
if [ "$icon_emoji" = "☁️" ]; then
    icon="weather-overcast-symbolic"
elif [ "$icon_emoji" = "🌫" ]; then
    icon="weather-windy"
elif [ "$icon_emoji" = "🌧" ]; then
    icon="weather-showers-symbolic"
elif [ "$icon_emoji" = "❄️" ]; then
    icon="weather-snow-symbolic"
elif [ "$icon_emoji" = "🌦" ]; then
    icon="weather-showers-symbolic"
elif [ "$icon_emoji" = "🌨" ]; then
    icon="weather-snow-symbolic"
elif [ "$icon_emoji" = "⛅️" ]; then
   if [ $current_hour -ge $sunset_hour ]; then
       icon="weather-few-clouds-night-symbolic"
   else
       icon="weather-few-clouds-symbolic"
   fi
elif [ "$icon_emoji" = "☀️" ]; then
   if [ $current_hour -ge $sunset_hour ]; then
       icon="weather-clear-night-symbolic"
   else
       icon="weather-clear-symbolic"
   fi 
elif [ "$icon_emoji" = "🌩" ]; then
    icon="weather-storm-symbolic"
elif [ "$icon_emoji" = "⛈" ]; then
    icon="weather-storm-symbolic"
fi

dunstify "$greeting" "Temperature: $weather" -i "$icon"
