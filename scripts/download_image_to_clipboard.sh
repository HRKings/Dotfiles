#!/bin/bash
command -v xclip >/dev/null 2>&1 || { echo "Need command xclip. Aborting." >&2; exit 1; }
wget "$1" -O /tmp/clipboard_image
[[ -f "/tmp/clipboard_image" ]] || { echo "Error: Not a file." >&2; exit 1; }
TYPE=$(file -b --mime-type "/tmp/clipboard_image")
xclip -selection clipboard -t "$TYPE" < "/tmp/clipboard_image"
rm -f /tmp/clipboard_image
echo "The image is now on the clipboard!"