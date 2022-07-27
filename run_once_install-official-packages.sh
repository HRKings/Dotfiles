#! /bin/bash

official_packages=(
	# System ------------------------------------------------------------------------------------------
	bluez																				 	# Bluetooth support
	hunspell																			# Spellchecking and the english dictionary
	hunspell-en_US
	kvantum-qt5																	 	# SVG theme engine for KDE
	lshw																					# To list the hardware
	xclip																				 	# Clipboard manager for the command line
	xdotool																				# Send key presses via terminal
	wmctrl																				# Control the window manager via CLI
	lshw																					# Hardware configuration info
	hwinfo																				# Hardware general info
	keychain																			# Handle ssh-agent
	bluedevil																		 	# Bluetooth support for KDE
	qt5-imageformats															# Thumbnails for other image formats, like WEBP
	kio-extras																		# Additional functionality for KIO
	ffmpegthumbs																	# Thumbnails for video formats
	sheldon																			 	# Shell plugin manager

	# Base ------------------------------------------------------------------------------------------------------
	exa																					 	# A better ls
	neovim																				# The only vim
	ranger																				# Terminal file explorer
	trash-cli																		 	# Send files to the DE trash bin instead of obliterating them
	rofi																					# Highly customizable application launcher
	zoxide																				# Z auto-jumping
	wireshark-qt																	# Network traffic monitoring like a hacker
	glow																					# TUI markdown viewer
	pigz																					# Parallel GZip
	lbzip2																				# Parallel BZip2

	# Development -------------------------------------------------------------------------------
	docker																				# Containerize all the things
	docker-compose
	github-cli																		# Finer access to GitHub features
	jre-openjdk																	 	# Run Java apps
	jdk-openjdk
	python																				# Python and its package manager
	python-pip
	git-delta																		 	# Next-Gen Diff engine
	shellcheck																		# Syntax and checker for shellscript
	gpick																				 	# Super advanced color picker
	dbeaver																			 	# GUI to manage DBMS
	git-lfs																			 	# Really large files support for Git, like your momma
	gource																				# Git history visualization
	kubectl																			 	# Container hell management
	lazygit																			 	# Git TUI
	go																						# Go core compiler tools
	rustup																				# Rust management tool
	hexyl																					# Hex vizualizer for the CLI

	# Utils -----------------------------------------------------------------------------------------------------------
	mpv																					 	# The best universal media player
	qbittorrent																	 	# My preferred torrent client
	thunderbird																	 	# Email client
	libreoffice-fresh														 	# Because everyone needs to edit documents (fresh = latest version)
	chromium																			# A chromium engine is needed more times that you may think
	jq																						# A terminal JSON formatter
	fzf																					 	# Fuzzy finder for any list
	btop																					# A more advanced htop
	krita																				 	# Digital drawing software
	inkscape																			# Vector image editor
	sd																						# A faster replacement for sed
	dua-cli																			 	# Disk usage visualizer
	atool																				 	# Manage file archives of various types
	hyperfine																		 	# Benchmark CLI execution times
	age																						# Modern file encryption

	# Gaming ----------------------------------------------------------------------------------
	vulkan-icd-loader														 	# Vulkan libs required by some games
	lib32-vulkan-icd-loader
	steam																				 	# One-stop game shop
	lutris																				# For when one-stop is actually two-stops
	discord																			 	# Communication at its finest

	# Fonts -----------------------------------------------------------------------------------------------
	ttf-roboto																		# Roboto, a beautiful Google font
	noto-fonts-emoji															# OpenSource emoji font, because we like emojis, right?

	# Misc --------------------------------------------------------------------------------------
	cowsay																				# Because just printing to terminal is boring
	fortune-mod																	 	# And to have something for cows to say
	onefetch																			# Visualize repository infos in a cool way
	lolcat																				# Rainbow terminal
	wakatime																		 	# WakaTime CLI
)

# Install all packages from the official Arch Linux Package Repository, if they are not already installed
sudo pacman -Syyu "${official_packages[@]}" --needed
