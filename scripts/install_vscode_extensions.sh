# Extension IDs to install ------------------------------------------
declare -a VSCODE_EXTENSIONS=(
	# Languages -----------------------------------------------
	"ms-dotnettools.csharp"					# C# Support
	"ms-python.python"						# Python Support
	"redhat.vscode-yaml"					# YAML Support
	"yzhang.markdown-all-in-one"			# Markdown All-In-One
	"octref.vetur"							# Vetur, Vue tools

	# Appearance --------------------------------------------
	"pkief.material-icon-theme"				# Material Icons
	"zhuangtongfa.material-theme"			# OneDark Pro Theme

	# Utilities -------------------------------------------------------------
	"eamodio.gitlens"						# Gitlens
	"ms-vsliveshare.vsliveshare"			# LiveShare
	"coenraads.bracket-pair-colorizer-2"	# BracketPair Colorizer 2
	"alefragnani.project-manager"			# Project Manager
	"streetsidesoftware.code-spell-checker"	# Spell Checking
	"wix.vscode-import-cost" 				# JS Package Import Cost
	"WallabyJs.quokka-vscode" 				# Inline function results for JS
	"hediet.vscode-drawio"					# Draw.io
	"lostintangent.vsls-whiteboard"			# Collaborative Whiteboard for Live Share

	# Intellisense ------------------------------------------------------
	"christian-kohler.npm-intellisense"		# Intellisense for NPM
	"christian-kohler.path-intellisense"	# Intellisense for File Path
	"octref.vetur"							# Vue Tooling

	# Workflow ------------------------------------------------------
	"ritwickdey.liveserver"					# Live server with hot reloading
	"fosshaas.fontsize-shortcuts"			# Add fontsize shortcuts
	
	# Linter/ Formatter ------------------------------
	"esbenp.prettier-vscode"				# Prettier
	"dbaeumer.vscode-eslint"				# ESLint
	"HookyQR.beautify"						# Beautify JS, CSS, JSON files
)

# Install each extension --------------------------------------------
for EXTENSION in "${VSCODE_EXTENSIONS[@]}"
do
	 code --install-extension $EXTENSION
done
