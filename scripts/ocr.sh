#!/usr/bin/env bash
#
# Originally made by:
# https://github.com/sdushantha/bin
# I adapted the Rofi language chooser, nothing is wrote to the disk and other QoL changes
# 

# Check if notifi-send is installed
if [ -z $(command -v notify-send) ]; then
    echo "Could not find 'notify-send', is it installed?"
fi

# Check if the needed dependencies are installed
DEPENDENCIES=(tesseract maim xclip)
for DEPENDENCY in "${DEPENDENCIES[@]}"; do
    type -p "$DEPENDENCY" &>/dev/null || {
        # Warn the user about the missing dependency via notify-send (in case this was launched outside a terminal)
        notify-send -u critical "OCR" "Could not find '${DEPENDENCY}', is it installed?"
        exit 1
    }
done

# Select the language to use on the OCR
LANG=$(tesseract --list-langs | tail -n +2 | rofi -dmenu)
[ -z $LANG ] && exit 1

# Take screenshot by selecting the area and pass to tesseract to do the OCR, saving the output to a variable
# Set the page separator to none, so it will be empty if the OCR fails (See: https://askubuntu.com/a/1276441/782646)
OCR=$(maim -us | tesseract -c page_separator="" -l $LANG - - 2> /dev/null)

# Get the exit code of the previous command.
# So in this case, it is the screenshot command. If it did not exit with an
# exit code 0, then it means the user canceled the process of taking a
# screenshot by doing something like pressing the escape key
STATUS=$?

# If the user pressed the escape key or did something to terminate the proccess taking a screenshot, then just exit
[ $STATUS -ne 0 ] && exit 1

# If the variable is empty, then no text was detected
if [ -z "$OCR" ]; then
    notify-send -u critical "OCR" "No text was detected"
    exit 1
fi

# Copy text to clipboard
echo $OCR | xclip -selection clip -i

# Send a notification with the text that was grabbed using OCR
notify-send "OCR" "$OCR"
