#! /usr/bin/bash

#==================================================================================================
# Extension IDs to install
#==================================================================================================
declare -a VSCODE_EXTENSIONS=(
	# Languages ---------------------------------------------------------
	"ms-dotnettools.csharp"			         			# C# Support
	"ms-python.python"						          	# Python Support
	"redhat.vscode-yaml"					          	# YAML Support
	"yzhang.markdown-all-in-one"			      	# Markdown All-In-One
	"earthly.earthfile-syntax-highlighting"		# Earthly Build Support

	# Appearance ----------------------------------------------------
	"pkief.material-icon-theme"				      	# Material Icons
	"zhuangtongfa.material-theme"			      	# OneDark Pro Theme

	# Utilities -----------------------------------------------------------------------------
	"eamodio.gitlens"						            	# Gitlens
	"ms-vsliveshare.vsliveshare"			      	# LiveShare
	"alefragnani.project-manager"			      	# Project Manager
	"streetsidesoftware.code-spell-checker"		# Spell Checking
	"wix.vscode-import-cost" 				        	# JS Package Import Cost
	"WallabyJs.quokka-vscode" 				      	# Inline function results for JS
	# "hediet.vscode-drawio"					        	# Draw.io
	"lostintangent.vsls-whiteboard"			    	# Collaborative Whiteboard for Live Share
	"j-brooke.fracturedjsonvsc"				      	# A JSON formatter focusing on readability
	"formulahendry.auto-rename-tag"			    	# HTML Auto-Rename Tags
	"formulahendry.auto-close-tag"			    	# HTML Auto-Close Tags
	"oderwat.indent-rainbow"				        	# Colorize identation
	"timonwong.shellcheck"					        	# Analyzer for shell scripts
	"quicktype.quicktype"					          	# Paste JSON as types (TS, C#, etc.)

	# Intellisense ------------------------------------------------------------
	"christian-kohler.npm-intellisense"		  	# Intellisense for NPM
	"christian-kohler.path-intellisense"	  	# Intellisense for File Path
	# "octref.vetur"							             	# Vue Tooling
	"johnsoncodehk.volar"					           	# Vue 3 Tooling

	# Workflow --------------------------------------------------------------------
	"ms-vscode.live-server"				      	  	# Live server with hot reloading
	"fosshaas.fontsize-shortcuts"			      	# Add fontsize shortcuts
	
	# Linter/ Formatter ---------------------------------------------------------
	"esbenp.prettier-vscode"				       	  # Prettier
	"dbaeumer.vscode-eslint"				        	# ESLint
	"HookyQR.beautify"							          # Beautify JS, CSS, JSON files
	"editorconfig.editorconfig"				      	# Override workspace configs based on .editorconfig
)

#==================================================================================================
# Install each extension
#==================================================================================================
for EXTENSION in "${VSCODE_EXTENSIONS[@]}"
do
	code --install-extension "$EXTENSION"
done
