#!/bin/bash/

# Gets all browser .desktop files
BROWSER_DEKSTOP_FILES=$(grep 'x-scheme-handler/https' /usr/share/applications/mimeinfo.cache | awk -F "=" '{ print $2 }')

# Transform the string into an array
IFS=';' read -r -a BROWSER_DEKSTOP_FILES <<< $BROWSER_DEKSTOP_FILES

# Initialize an key-value pair array to hold the browser names and exec paths
declare -A BROWSERS

# For each browser desktop file, get the name and exec path, storing them on the key-value pair array
for desktop_file in "${BROWSER_DEKSTOP_FILES[@]}";
do
	BROWSERS[$(grep 'Name=' /usr/share/applications/$desktop_file | awk -F "=" '{ print $2 }' | head -n 1)]=$(grep 'Exec=' /usr/share/applications/$desktop_file | awk -F "Exec=" '{ print $2 }' | head -n 1)
done

# Launch Rofi to present the user the browser name to choose
CHOICE=$(printf '%s\n' "${!BROWSERS[@]}" | rofi -dmenu -i -p "Select the browser to open the link")

# Strip the exec path from the '%U' or '%u' and launch with the provided URL
$(echo ${BROWSERS[$CHOICE]} | sed "s/\%[Uu]//g")$1