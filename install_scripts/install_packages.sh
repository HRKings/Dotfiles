#! /usr/bin/bash

#========================================================================================================================
# Packages from the official Arch repository
#========================================================================================================================
declare -a OFFICIAL_PKGS=(
	# System ------------------------------------------------------------------------------------------
	"bluez"											                    # Bluetooth support
	"hunspell" "hunspell-en_US"			          			# Spellchecking and the english dictionary
	"kvantum-qt5"									                  # SVG theme engine for KDE
	"lshw"										                    	# To list the hardware
	"gnome-keyring"						                 			# Some programs need the keyring to store auth data
	"xclip"							                    				# Clipboard manager for the command line
	"xdotool"							                    			# Send keypresses via terminal
	"lshw"								                     			# Hardware configuration info
	"hwinfo"									                    	# Hardware general info
	"keychain"								                  		# Handle ssh-agent
	"bluedevil"									                  	# Bluetooth support for KDE
  "qt5-imageformats"                              # Thumbnails for other image formats, like WEBP
  "kio-extras"                                    # Additional functionality for KIO
  "ffmpegthumbs"                                  # Thumbnails for video formats

	# Base ------------------------------------------------------------------------------------------------------
	"exa"								                      			# A better ls
	"neovim"								                     		# The only vim
	"ranger"								                     		# Terminal file explorer
	"trash-cli"							                   			# Send files to the DE trashbin instead of obliterating them
	#"kitty"									                    	# GPU rendered terminal
	"rofi"                                          # Highly customizable application launcher
	"zoxide"								                     		# Z autojumping

	# Development -------------------------------------------------------------------------------
	"docker"										                    # Containerize all the things
	"github-cli"								                  	# Finer access to GitHub features
	"jre-openjdk" "jdk-openjdk"				          		# Run Java apps
	"python" "python-pip"				              			# Python and its package manager
	"git-delta"									                  	# Next-Gen Diff engine
	"shellchek"							                  			# Syntax and checker for shellscripts
	"qpick"									                    		# Super advanced color picker

	# Utils -----------------------------------------------------------------------------------------------------------
	"mpv"										                      	# The best universal media player
	"qbittorrent"								                  	# My preferred torrent client
	"thunderbird"								                  	# Email client
	"libreoffice-fresh"						              		# Because everyone needs to edit documents (fresh = latest version)
	"chromium"								                  		# A chromium engine is needed more times that you may think
	"jq"										                      	# A terminal JSON formatter
	"fzf"										                      	# Fuzzy finder for any list
	"bpytop"									                    	# A more advanced htop
	"krita"										                	    # Digital drawing software
	"inkscape"									                   	# Vector image editor
	"sd"										                      	# A faster replacement for sed

	# Gaming ----------------------------------------------------------------------------------
	"vulkan-icd-loader" "lib32-vulkan-icd-loader"  	# Vulkan libs required by some games
	"steam"											                    # One-stop game shop
	"lutris"										                    # For when "one-stop" is actually two-stops
	"discord"										                    # Communication at its finest

	# Fonts -----------------------------------------------------------------------------------------------
	"ttf-roboto"								                  	# Roboto, a beautiful Google font
	"noto-fonts-emoji"							               	# OpenSource emoji font, because we like emojis, right?

	# Misc --------------------------------------------------------------------------------------
	"cowsay"									                    	# Because just printing to terminal is boring
	"fortune-mod"							                   		# And to have something for cows to say
	"neofetch"								                  		# Vizualize distro infos in a cool way
	"onefetch"								                  		# Vizualize repository infos in a cool way
	"lolcat"										                    # Rainbow terminal
)

#========================================================================================================================
# Packages from AUR
#========================================================================================================================
declare -a AUR_PKGS=(
	# System --------------------------------------------------------------------------------
	"antigen"								                      	# ZSH plugin manager
	"bluez-utils-compat"							              # More bluetooth support
	"hunspell-pt-br"							                	# Portuguese spellcheck
	"epson-inkjet-printer-escpr"		          			# EPSON printer drivers
	"gestures"									                  	# GUI configurator for touchpad gestures
	"input-wacom-dkms"						              		# Wacom tablet driver
	"dotbot"									                    	# Dotfiles bootstraper

	# Base ------------------------------------------------------------------------------------------------
	"google-chrome"								                	# Chrome with sync
	"google-chrome-dev"							              	# Chrome latest features
	"firefox-developer-edition"				          		# My to-go browser, with lots of feature for developers
	"gdu-bin"								                     		# Disk usage vizualizer
	"bat"									                      		# Cat but with syntax highlighting
	"glow-bin"						                  				# TUI markdown viwer
	"tealdeer"						                  				# Tldr provides example usages for some commands

	# Utils ---------------------------------------------------------------------------------------------
	"teams"							                    				# Because unforunally, discord isn't enough
	"spotify"								                    		# Let's dance, baby
	"keepassxc"						                  				# My favorite password manager
	"quiterss"					                   					# One of the best RSS feed readers
	"stretchly-bin"						                			# Take frequent breaks
	"gallery-dl-bin"						                		# CLI image downloader for various sources
	"ookla-speedtest-bin"			               				# Speedtest.net CLI
	#"tdrop-git"						                				# Turn any application in a quake-mode dropdown
	#"espanso-bin"					                				# Substitute aliases strings
	"sleek"								                     			# Todo.txt GUI

	# Communication ---------------------------------------------------------------
	"discord-ptb"						                  			# Double profile for discord

	# Development ---------------------------------------------------------------------------------------------------
	"visual-studio-code-bin"					            	# Proprietary VSCode, because we need things to work
	"jetbrains-toolbox"							              	# Installs any jetbrains related product with one authentication
	"insomnia-bin"								                	# REST API designing and testing workspace
	"gitgudcli-git"							                		# GitGud CLI wrapper
	"gibo"										                    	# Github's gitignore collection from the CLI
	"lazygit"									                    	# Git TUI
	"lazydocker-bin"					                			# Docker TUI
	"earthly-bin"							                  		# Universal build system

	# Gaming ------------------------------------------------------------------------------------
	# "mcrcon"										                    # RCON CLI for Minecraft Servers
	"ds4drv-cemuhook-git"					              		# DualShock 4 drivers with Cemuhook support
	"multimc-bin"									                  # Minecraft multi instance launcher

	# Fonts -------------------------------------------------------------
	"nerd-fonts-fira-code"		  	          				# FiraCode Nerd Font

	# Misc --------------------------------------------------------------------------
	"shell-color-scripts"						              	# Vizualize shell colors
	"img2xterm"										                  # Display images on the terminal
	"pokemonsay-newgenerations-git"			        		# Cowsay with pokemons
	"mpv-mpris"								                  		# Enable MPRIS for MPV
)

#========================================================================================================================
# Instalation
#========================================================================================================================

# Install everything from the offical repostiory --------
sudo pacman -Suy --needed "${OFFICIAL_PKGS[@]}"

# Install everything from AUR -------
yay -Sy --needed "${AUR_PKGS[@]}"
