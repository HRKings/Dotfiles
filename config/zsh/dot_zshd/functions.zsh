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

pkgfind() {
	yay -Sl | awk '{print $2($4=="" ? "" : " *")}' | fzf --multi --preview 'yay -Si {1}' | cut -d " " -f 1 | xargs -ro yay -S
}

gitrecurse() {
	for dir in $(find . -name ".git")
	do 
		cd ${dir%/*}
		echo "> $PWD"
		git $@
		cd - > /dev/null
	done
}

stringdiff() {
	vimdiff  <(echo $1 ) <(echo $2)
}