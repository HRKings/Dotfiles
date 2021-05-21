# Packages from the official Arch repository -----------------------------------------------------
declare -a OFFICIAL_PKGS=(
	# System
	"bluez" "bluez-utils-compat"					# Bluetooth support
	"hunspell" "hunspell-en_US"						# Spellchecking and the english dictionary
	"kvantum-qt5"									# SVG theme engine for KDE
	"lshw"											# To list the hardware
	"gnome-keyring"									# Some programs need the keyring to store auth data
	"xclip"											# Clipboard manager for the command line

	# Base 
	"exa"											# A better ls
	"neovim"										# The only vim
	"ranger"										# Terminal file explorer
	"ueberzug"										# To preview images in the terminal when using ranger
	"trash-cli"										# Send files to the DE trashbin instead of obliterating them

	# Development
	"dotnet-runtime" "aspnet-runtime" "dotnet-sdk"	# Make and run .NET code

	# Utils
	"mpv"											# The best universal media player
	"qbittorrent"									# My preferred torrent client
	"thunderbird"									# Email client
	"qutebrowser"									# An minimal and keyboard centered browser
	"flameshot"										# Screenshot tool
	"libreoffice-fresh"								# Because everyone needs to edit documents
	"chromium"										# A chromium engine is needed more times that you may think
	"braus-git"										# Ask which browser to use when opening each link
	"jq"											# A terminal JSON formatter
	"fzf"											# Fuzzy finder for any list

	# Gaming
	"vulkan-icd-loader" "lib32-vulkan-icd-loader"  	# Vulkan libs required by some games
	"steam"											# One-stop game shop
	"lutris"										# For when "one-stop" is actually two-stops
	"discord"										# Communication at its finest

	# Fonts
	"ttf-roboto"									# Roboto, a beautiful Google font
	"noto-fonts-emoji"								# OpenSource emoji font, because we like emojis, right ?
)

# Packages from AUR -------------------------------------------------------------------------------
declare -a AUR_PKGS=(
	# System
	"hunspell-pt-br"					# Portuguese spellcheck
	"epson-inkjet-printer-escpr"		# EPSON printer drivers
	"antigen"							# A plugin manager for ZSH

	# Base
	"google-chrome"						# Chrome with sync

	# Utils
	"whatsapp-nativefier"				# Because unforunally, discord isn't enough
	"teams"								# Because unforunally, discord isn't enough, part 2
	"spotify"							# Let's dance, baby
	"keepassxc"							# My favorite password manager
	"stretchly"							# Break reminder
	"quiterss"							# One of the best RSS feed readers

	# Communication
	"discord-ptb"						# Double profile for discord

	# Development
	"visual-studio-code-bin"			# Proprietary VSCode, because we need things to function
	"firefox-developer-edition"			# My to-go browser, with lots of feature for developers
	"jetbrains-toolbox"					# Installs any jetbrains related product with one authentication
	"insomnia"							# REST API testing workspace

	# Customization
	"spicetify-cli" "spicetify-custom-apps-and-extensions-git" "spicetify-themes-git" # Custom theme and extensions for the offical Spotify client

	# Fonts
	"nerd-fonts-fira-code"		  		# FiraCode Nerd Font
)

# Instalation -------------------------------------------------------------------------------------

## Install powerpill to get faster package downloads from the official repository -------
# yay -Sy powerpill

## Change yay to use powerpill --------
# yay --pacman "powerpill -Syu"

### Install everything from the offical repostiory --------
# sudo powerpill -Sy ${OFFICIAL_PKGS[@]}
sudo pacman -Suy ${OFFICIAL_PKGS[@]}

### Install everything from AUR -------
yay -Sy ${AUR_PKGS[@]}