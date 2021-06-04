#========================================================================================================================
# Packages from the official Arch repository
#========================================================================================================================
declare -a OFFICIAL_PKGS=(
	# System ------------------------------------------------------------------------------------------
	"bluez" "bluez-utils-compat"					# Bluetooth support
	"hunspell" "hunspell-en_US"						# Spellchecking and the english dictionary
	"kvantum-qt5"									# SVG theme engine for KDE
	"lshw"											# To list the hardware
	"gnome-keyring"									# Some programs need the keyring to store auth data
	"xclip"											# Clipboard manager for the command line
	"xdotool"										# Send keypresses via terminal
	"lshw"											# Hardware configuration info
	"hwinfo"										# Hardware general info

	# Base ------------------------------------------------------------------------------------------------------
	"exa"											# A better ls
	"neovim"										# The only vim
	"ranger"										# Terminal file explorer
	"ueberzug"										# To preview images in the terminal when using ranger
	"trash-cli"										# Send files to the DE trashbin instead of obliterating them
	"ncdu"											# Disk usage vizualizer

	# Development -------------------------------------------------------------------
	"dotnet-runtime" "dotnet-sdk"					# Make and run .NET code
	"aspnet-runtime" "aspnet-targeting-pack"		# And target and run ASP.NET
	"docker" "docker-compose"						# Containerize all the things
	"github-cli"									# Finer access to GitHub features
	"jre-openjdk" "jdk-openjdk"						# Run Java apps
	"python-pip"									# Python package manager
	"kitty"											# GPU rendered terminal

	# Utils -----------------------------------------------------------------------------------------------------------
	"mpv"											# The best universal media player
	"qbittorrent"									# My preferred torrent client
	"thunderbird"									# Email client
	"qutebrowser"									# An minimal and keyboard centered browser
	"flameshot"										# Screenshot tool
	"libreoffice-fresh"								# Because everyone needs to edit documents (fresh = latest version)
	"chromium"										# A chromium engine is needed more times that you may think
	"braus-git"										# Ask which browser to use when opening each link
	"jq"											# A terminal JSON formatter
	"fzf"											# Fuzzy finder for any list
	"bpytop"										# A more advanced htop
	"krita"											# Digital drawing software
	"inkscape"										# Vector image editor

	# Gaming ----------------------------------------------------------------------------------
	"vulkan-icd-loader" "lib32-vulkan-icd-loader"  	# Vulkan libs required by some games
	"steam"											# One-stop game shop
	"lutris"										# For when "one-stop" is actually two-stops
	"discord"										# Communication at its finest
	"multimc5"										# Minecraft multi instance launcher

	# Fonts -----------------------------------------------------------------------------------------------
	"ttf-roboto"									# Roboto, a beautiful Google font
	"noto-fonts-emoji"								# OpenSource emoji font, because we like emojis, right?

	# Misc --------------------------------------------------------------------------------------
	"cowsay"										# Because just printing to terminal is boring
	"fortune-mod"									# And to have something for cows to say
	"neofetch"										# Vizualize distro infos in a cool way
	"onefetch"										# Vizualize repository infos in a cool way
	"lolcat"										# Rainbow terminal
)

#========================================================================================================================
# Packages from AUR
#========================================================================================================================
declare -a AUR_PKGS=(
	# System --------------------------------------------------------------------------------
	"hunspell-pt-br"								# Portuguese spellcheck
	"epson-inkjet-printer-escpr"					# EPSON printer drivers
	"antigen"										# A plugin manager for ZSH
	"gestures"										# GUI configurator for touchpad gestures
	"input-wacom-dkms"								# Wacom tablet driver

	# Base ------------------------------------------------------------------------------------------------
	"google-chrome"									# Chrome with sync
	"google-chrome-dev"								# Chrome latest features
	"firefox-nightly"								# To test upcoming features
	"firefox-developer-edition"						# My to-go browser, with lots of feature for developers

	# Utils -------------------------------------------------------------------------------------------
	"whatsapp-nativefier"							# Because unforunally, discord isn't enough
	"teams"											# Because unforunally, discord isn't enough, part 2
	"spotify"										# Let's dance, baby
	"keepassxc"										# My favorite password manager
	"stretchly"										# Break reminder
	"quiterss"										# One of the best RSS feed readers
	"braus-git"										# Choose on which browser you wanna open a link
	"stretchly-bin"									# Take frequent breaks
	"gallery-dl"									# CLI image downloader for various sources

	# Communication -------------------------------------------------------------
	"discord-ptb"									# Double profile for discord

	# Development --------------------------------------------------------------------------------------------------
	"visual-studio-code-bin"						# Proprietary VSCode, because we need things to work
	"jetbrains-toolbox"								# Installs any jetbrains related product with one authentication
	"insomnia"										# REST API testing workspace
	"insomnia-designer-bin"							# REST API designing workspace
	"dockstation"									# Control docker containers in a GUI fashion
	"mongodb-compass"								# Access MongoDB
	"gitgudcli-git"									# GitGud CLI wrapper
	"gibo"											# Github's gitignore collection from the CLI
	"lazygit"										# Git TUI

	# Customization -----------------------------------------------------------------
	"spicetify-cli" "spicetify-themes-git"			# Custom theme and extensions
	"spicetify-custom-apps-and-extensions-git"		# for the offical Spotify client
	"latte-dock-git"								# Official dock for KDE

	# Fonts -------------------------------------------------------------
	"nerd-fonts-fira-code"		  					# FiraCode Nerd Font

	# Misc --------------------------------------------------------------------------
	"shell-color-scripts"							# Vizualize shell colors
	"img2xterm"										# Display images on the terminal
	"pokemonsay-newgenerations-git"					# Cowsay with pokemons
	"mpv-mpris"										# Enable MPRIS for MPV
)

#========================================================================================================================
# Instalation
#========================================================================================================================

# Install everything from the offical repostiory --------
sudo pacman -Suy ${OFFICIAL_PKGS[@]}

# Install everything from AUR -------
yay -Sy ${AUR_PKGS[@]}