#!/bin/bash

# If its showing Rofi for the first time
if [ $ROFI_RETV == "0" ];then
	# Gets all browser .desktop files
	BROWSER_DEKSTOP_FILES=$(grep 'x-scheme-handler/https' /usr/share/applications/mimeinfo.cache | awk -F "=" '{ print $2 }')

	# Transform the string into an array
	IFS=';' read -r -a BROWSER_DEKSTOP_FILES <<< $BROWSER_DEKSTOP_FILES

	# For each browser desktop file, get the name and exec path
	for desktop_file in "${BROWSER_DEKSTOP_FILES[@]}";
	do
		BROWSER_NAME=$(grep 'Name=' /usr/share/applications/$desktop_file | awk -F "=" '{ print $2 }' | head -n 1)
		BROWSER_EXEC=$(grep 'Exec=' /usr/share/applications/$desktop_file | awk -F "Exec=" '{ print $2 }' | head -n 1)
		BROWSER_ICON=$(grep 'Icon=' /usr/share/applications/$desktop_file | awk -F "Icon=" '{ print $2 }' | head -n 1)
		echo -en "$BROWSER_NAME\0icon\x1f$BROWSER_ICON\x1finfo\x1f$BROWSER_EXEC\n"
	done
fi

# If the user has choose one option
if [ $ROFI_RETV == "1" ];then
	# Strip the exec path from the '%U' or '%u' and launch with the provided URL
	coproc ( $(echo $ROFI_INFO | sed "s/\%[Uu]//g")$URL  > /dev/null  2>&1 )
	exit 0
fi