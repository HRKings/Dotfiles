#! /bin/bash

# Set the default shell to ZSH ---
chsh -s "$(which zsh)"

# Install pacdef -----
yay --Syyu pacdef

# Sync pacdef --------
pacdef package sync
