#! /bin/bash

desktop-file-install --dir=$HOME/.local/share/applications misc/browser-chooser.desktop

sed -r "4s;.*;Exec=env URL=%U /usr/bin/rofi -modi 'bc:$HOME/.bin/browser_chooser.sh' -show bc;" -i $HOME/.local/share/applications/browser-chooser.desktop

update-desktop-database ~/.local/share/applications