#================================================================================================================================
# Functions
#================================================================================================================================

# Reload all ZSH configs ------------
reloadzsh() {
	for file in $HOME/.zshd/*.zsh
	do
  		echo "> Reloading $file"
		source $file
	done
}

# List all packages in both Upstream and AUR, with fuzzy searching via fzf ----------------------------------------------------
pkgfind() {
	yay -Sl | awk '{print $2($4=="" ? "" : " *")}' | fzf --multi --preview 'yay -Si {1}' | cut -d " " -f 1 | xargs -ro yay -S
}

# Execute a Git command in all repositories contained in nested directories ----
gitrecurse() {
	for dir in $(find . -name ".git")
	do 
		cd ${dir%/*}
		echo "> $PWD"
		git $@
		cd - > /dev/null
	done
}

# Executes a diff in two strings ----------------------------------------
stringdiff() {
	echo $1 > /tmp/string_diff_file_1
	echo $2 > /tmp/string_diff_file_2
	kitty +kitten diff /tmp/string_diff_file_1 /tmp/string_diff_file_2
}