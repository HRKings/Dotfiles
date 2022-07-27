#! /bin/bash

# aur_packages=(
# 	# System ----------------------------------------------------------------------------------------------------------
# 	bluez-utils-compat															# More bluetooth support
# 	hunspell-pt-br																	# Portuguese spellcheck
# 	epson-inkjet-printer-escpr											# EPSON printer drivers
# 	input-wacom-dkms																# Wacom tablet driver
# 	ventoy-bin																		 	# Multi ISO USB manager
# 	kwallet-secrets																	# KDE secrets management with support for org.freedesktop.secrets

# 	# Base ------------------------------------------------------------------------------------------------------------
# 	google-chrome																		# Chrome with sync
# 	google-chrome-dev																# Chrome latest features
# 	firefox-developer-edition												# My to-go browser, with lots of feature for developers
# 	bat																							# Cat but with syntax highlighting
# 	tealdeer																			 	# Tldr provides example usages for some commands
# 	qalculate-qt5																		# The best calculator in existence
# 	tdrop																						# Transform any application into a dropdown window
# 	7-zip-full																		 	# Official full replacement for p7zip

# 	# Utils ---------------------------------------------------------------------------------------------
# 	teams-insiders																 	# Because unfortunately, discord isn't enough
# 	spotify																					# Let's dance, baby
# 	quiterss																			 	# One of the best RSS feed readers
# 	stretchly-bin																		# Take frequent breaks
# 	gallery-dl-bin																 	# CLI image downloader for various sources
# 	ookla-speedtest-bin															# Speedtest.net CLI
# 	1password																				# My favorite password manager
# 	tere																					 	# Navigate folders like a pro
# 	cheat																						# Vizualize cheatsheets on the terminal

# 	# Communication ---------------------------------------------------------------
# 	discord-ptb																			# Double profile for discord

# 	# Development ---------------------------------------------------------------------------------------------------
# 	visual-studio-code-bin												 	# Proprietary VSCode, because we need things to work
# 	jetbrains-toolbox																# Installs any JetBrains related product with one authentication
# 	insomnia-bin																	 	# REST API designing and testing workspace
# 	gitgudcli-bin																		# GitGud CLI wrapper
# 	gibo																					 	# Github's gitignore collection from the CLI
# 	lazydocker-bin																 	# Docker TUI
# 	aws-cli-v2-bin																 	# AWS management, because managing your own infra is hard (and you don't really care about money, do you ?)
# 	pnpm																					 	# A better and more disk efficient NPM, because disk space if expensive
# 	nvm																							# Node Version Manager, because having just one circle of hell isn't enough
# 	kubecolor																				# Colorize kubectl output

# 	# Gaming ------------------------------------------------------------------------------------
# 	ds4drv-cemuhook-git															# DualShock 4 drivers with CemuHook support
# 	multimc-bin																			# Minecraft multi instance launcher
# 	citra-qt-bin																		# 3DS emulator, because I like Pokemon
# 	yuzu-mainline-bin																# Switch emulator, because (I like Pokemon)² and Zelda
# 	vintagestory																	 	# Minecraft survival on steroids

# 	# Fonts -------------------------------------------------------------
# 	nerd-fonts-fira-code													 # FiraCode Nerd Font

# 	# Misc --------------------------------------------------------------------------
# 	shell-color-scripts															# Visualize shell colors
# 	img2xterm																				# Display images on the terminal
# 	pokemonsay-newgenerations-git										# Cowsay with pokemon
# 	mpv-mpris																				# Enable MPRIS for MPV
# 	fastfetch-git																		# Visualize distro infos in a cool way
# )

# # Install all packages from the official Arch Linux Package Repository, if they are not already installed
# for package in "${aur_packages[@]}"
# do
# 	yay -S --noconfirm $(yay -Qi "$package" 2>&1 >/dev/null | grep "error: package" | grep "was not found" | cut -d"'" -f2 | tr "\n" " ")
# done
