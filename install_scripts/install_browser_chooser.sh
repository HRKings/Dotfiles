#! /bin/bash

desktop-file-install --dir=$HOME/.local/share/applications misc/browser-chooser.desktop

sed -r "4s;.*;Exec=/usr/bin/sh $HOME/.bin/browser_chooser.sh %U;" -i $HOME/.local/share/applications/browser-chooser.desktop

update-desktop-database ~/.local/share/applications