#! /bin/bash

aur_packages=(
	# System ----------------------------------------------------------------------------------------------------------
	bluez-utils-compat															# More bluetooth support
	hunspell-pt-br																	# Portuguese spellcheck
	epson-inkjet-printer-escpr											# EPSON printer drivers
	input-wacom-dkms																# Wacom tablet driver
	ventoy-bin																			# Multi ISO USB manager
	kwallet-secrets																	# KDE secrets management with support for org.freedesktop.secrets
	huiontablet																			# Huion tablet driver

	# Base ------------------------------------------------------------------------------------------------------------
	google-chrome																		# Chrome with sync
	google-chrome-dev																# Chrome latest features
	firefox-developer-edition												# My to-go browser, with lots of feature for developers
	bat																							# Cat but with syntax highlighting
	tealdeer																				# Tldr provides example usages for some commands
	qalculate-qt5																		# The best calculator in existence
	tdrop																						# Transform any application into a dropdown window
	7-zip-full																			# Official full replacement for p7zip
	pacseek																					# TUI for downloading ArchLinux packages

	# Utils ---------------------------------------------------------------------------------------------
	teams-insiders																	# Because unfortunately, discord isn't enough
	spotify																					# Let's dance, baby
	quiterss																				# One of the best RSS feed readers
	stretchly-bin																		# Take frequent breaks
	gallery-dl-bin																	# CLI image downloader for various sources
	ookla-speedtest-bin															# Speedtest.net CLI
	1password																				# My favorite password manager
	1password-cli
	tere																						# Navigate folders like a pro
	cheat																						# Vizualize cheatsheets on the terminal
	cellwriter																			# Handwritting input
	dragon-drop																			# Drag and drop from the CLI
	microsoft-edge-beta-bin													# Well, can't have too many browsers
	streamdeck-ui																		# StreamDeck for Linux
	wine																						# Run Windows programs

	# Communication ---------------------------------------------------------------
	discord-ptb																			# Double profile for discord

	# Development ---------------------------------------------------------------------------------------------------
	visual-studio-code-bin													# Proprietary VSCode, because we need things to work
	jetbrains-toolbox																# Installs any JetBrains related product with one authentication
	insomnia-bin																		# REST API designing and testing workspace
	gitgudcli-bin																		# GitGud CLI wrapper
	gibo																						# Github's gitignore collection from the CLI
	lazydocker-bin																	# Docker TUI
	aws-cli-v2-bin																	# AWS management, because managing your own infra is hard (and you don't really care about money, do you ?)
	pnpm																						# A better and more disk efficient NPM, because disk space if expensive
	nvm																							# Node Version Manager, because having just one circle of hell isn't enough
	kubecolor																				# Colorize kubectl output
	astronvim																				# Defaults for neovim
	dura-git																				# Never lose your work while using Git
	flutter																					# Flutter SDK
	godot-mono-bin																	# The best 2D game engine out there
	imhex																						# Hex editor and analyzer
	mongodb-compass																	# GUI for MongoDB
	ngrok																						# Tunneling for localhost
	go-yq																						# jq for YAML

	# Gaming ------------------------------------------------------------------------------------
	ds4drv-cemuhook-git															# DualShock 4 drivers with CemuHook support
	multimc-bin																			# Minecraft multi instance launcher
	citra-qt-git																		# 3DS emulator, because I like Pokemon
	yuzu-mainline-bin																# Switch emulator, because (I like Pokemon)² and Zelda
	ryujinx-ldn-bin																	# Another Switch emulator
	vintagestory																		# Minecraft survival on steroids

	# Fonts -------------------------------------------------------------
	nerd-fonts-fira-code														# FiraCode Nerd Font

	# Misc --------------------------------------------------------------------------
	shell-color-scripts															# Visualize shell colors
	img2xterm																				# Display images on the terminal
	pokemonsay-newgenerations-git										# Cowsay with pokemon
	mpv-mpris																				# Enable MPRIS for MPV
	fastfetch-git																		# Visualize distro infos in a cool way
	typioca-git																			# Terminal typing speed tester
)

# Install all packages from the official Arch Linux Package Repository, if they are not already installed
for package in "${aur_packages[@]}"
do
	yay -S --noconfirm $(yay -Qi "$package" 2>&1 >/dev/null | grep "error: package" | grep "was not found" | cut -d"'" -f2 | tr "\n" " ")
done
