#! /bin/bash

vscode_extensions=(
	# Languages ---------------------------------------------------------------
  ms-dotnettools.csharp                    	# C# support
  redhat.vscode-yaml                       	# YAML support
  yzhang.markdown-all-in-one               	# Markdown All-In-One
  earthly.earthfile-syntax-highlighting    	# Earthly Build support
	bungcip.better-toml												# Better TOML support
	JuanBlanco.solidity												# Solidity support
	ms-python.python													# Python support
	ms-python.vscode-pylance
	redhat.ansible														# Ansible support
  Vue.volar                      						# Vue 3 Tooling
	redhat.vscode-xml													# XML support
	rust-lang.rust-analyzer										# Rust support
	svelte.svelte-vscode											# Svelte support

  # Appearance -------------------------------------------------------------
  PKief.material-icon-theme                	# Material Icons
  zhuangtongfa.material-theme              	# OneDark Pro Theme
	s-nlf-fh.glassit													# Transparency for VSCode

  # Utilities -----------------------------------------------------------------------------
  eamodio.gitlens                          	# Gitlens
  ms-vsliveshare.vsliveshare               	# LiveShare
  alefragnani.project-manager              	# Project Manager
  streetsidesoftware.code-spell-checker    	# Spell Checking
  wix.vscode-import-cost                   	# JS Package Import Cost
  WallabyJs.quokka-vscode                  	# Inline function results for JS
  j-brooke.fracturedjsonvsc                	# A JSON formatter focusing on readability
  formulahendry.auto-rename-tag            	# HTML Auto-Rename Tags
  formulahendry.auto-close-tag             	# HTML Auto-Close Tags
  oderwat.indent-rainbow                   	# Colorize identation
  timonwong.shellcheck                     	# Analyzer for shell scripts
  quicktype.quicktype                      	# Paste JSON as types (TS, C#, etc.)
	pnp.polacode															# Take a screenshot of the code
	antfu.iconify															# Preview Iconify icons
	bibhasdn.unique-lines											# Delete duplicated lines
	Gruntfuggly.todo-tree											# Display all TODOs in the workspace

	# Editors ------------------------------------------------------------------------
	ms-toolsai.jupyter												# Jupyter Notebooks editor
  ms-vscode.hexeditor                      	# Hex Editor and Viewer
  Arjun.swagger-viewer                     	# Display Swagger specs in a visual way

  # Intellisense ------------------------------------------------------------
  christian-kohler.npm-intellisense        	# Intellisense for NPM
  christian-kohler.path-intellisense       	# Intellisense for File Path

  # Workflow --------------------------------------------------------------------
  ms-vscode.live-server                    	# Live server with hot reloading
  fosshaas.fontsize-shortcuts              	# Add fontsize shortcuts
	vscodevim.vim															# Add Vim keybinds

  # Linter/ Formatter ---------------------------------------------------------
  esbenp.prettier-vscode                   	# Prettier
  dbaeumer.vscode-eslint                   	# ESLint
  HookyQR.beautify                         	# Beautify JS, CSS, JSON files
  EditorConfig.EditorConfig                	# Override workspace configs based on .editorconfig

	# Misc -----------------------------------------------------------------
	WakaTime.vscode-wakatime									# Count time spent on coding
)

# Get already installed VSCode extensions ------------
installed_vscode_extensions=$(code --list-extensions)

# Install extensions ------------------------------------------------------------------------
for extension in "${vscode_extensions[@]}"
do
	# Only install if not already
	if [[ ! $installed_vscode_extensions =~ (^|[[:space:]])$extension($|[[:space:]]) ]]; then
		code --install-extension "$extension"
	fi
done
