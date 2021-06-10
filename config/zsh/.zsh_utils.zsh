#================================================================================================================================
# Tab completions
#================================================================================================================================

# ZSH parameter completion for the dotnet CLI ---------

_dotnet_zsh_complete()
{
	local completions=("$(dotnet complete "$words")")

	reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

#================================================================================================================================
# General Configs
#================================================================================================================================

# Config keys -----------------------
export DISABLE_LS_COLORS="true"
zstyle ':completion:*' list-colors

#================================================================================================================================
# Exports
#================================================================================================================================

# .NET path config for Arch ------------------------------
export PATH="$PATH:${HOME}/.dotnet/tools"
export DOTNET_ROOT=$(dirname $(realpath $(which dotnet)))

# External global tools ---------
export PATH="$PATH:${HOME}/.bin"

# Set default browser to Braus (Select broswer for each link) --
export BROWSER=braus

#================================================================================================================================
# Aliases 
#================================================================================================================================

# pacman and yay (If needed a LC_ALL=en.US in front of any of these commands to force the language to english) --------
alias pacup="sudo pacman -Syyu"								# Update only standard pkgs
alias yayup="yay -Sua"										# Update only AUR pkgs
alias yayupall="yay -Syyu --noconfirm"						# Update standard pkgs and AUR pkgs
#alias pacunlock="sudo rm /var/lib/pacman/db.lck"			# Remove pacman lock
alias paccleanup="sudo pacman -Qtdq | sudo pacman -Rns -"	# Remove orphaned packages

# Get fastest mirrors -------------------------------------------------------------------------------
#alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
#alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
#alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
#alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Changing "ls" to "exa" --------------------------------------------------------------------------------------------------
alias ls="exa -al --color=always --group-directories-first --icons"									# My preferred listing
alias la="exa -a --color=always --group-directories-first --icons"									# All files and dirs
alias ll="exa -l --color=always --group-directories-first --icons"									# Long format
alias lt="exa -aT --color=always --group-directories-first --icons"									# Tree listing
alias l.="exa -la --color=always --group-directories-first --icons | grep -P '\e\[[0-9]+m\.|\s\.'"	# All .files
alias lss="exa -al --color=always --group-directories-first --icons | egrep"						# A "search" function

# Colorize grep output (good for log files) --------
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# Confirm before overwriting something --------
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# Copy
alias cp="rsync -pogbr -hhh --backup-dir=/tmp/rsync -e /dev/null --progress"

# Trash bin related commands --------------------
alias tp="trash-put"
alias emptytrash="rm -rf ~/.local/share/Trash/*"

# Adding flags --------------------------------
alias df="df -h"		# human-readable sizes
alias free="free -m"	# show sizes in MB

# Get top process eating memory -------------------
alias psmem="ps auxf | sort -nr -k 4"
alias psmem10="ps auxf | sort -nr -k 4 | head -10"

# Get top process eating cpu ----------------------
alias pscpu="ps auxf | sort -nr -k 3"
alias pscpu10="ps auxf | sort -nr -k 3 | head -10"

# Format JSON from the clipboard ------------------------------------------------
alias jsonf="xclip -o | jq" 				# Then print
alias jsonfc="xclip -o | jq | xclip -i"		# Then put it back on the clipboard

# Copy something directly to the clipboard ----
alias clip="xclip -selection clipboard -i"

# Change name of programs -------------------------------
alias vim="nvim"
alias cshell="csharprepl"	# Open C# interactive shell
alias gud="gitgud commit"

#================================================================================================================================
# Personal Shortcuts
#================================================================================================================================

alias editzsh="code ~/.zsh_utils.zsh ~/.zshrc"
alias reloadzsh="source ~/.zsh_utils.zsh"

#================================================================================================================================
# Functions
#================================================================================================================================

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

#================================================================================================================================
# Source other scripts
#================================================================================================================================

# Set up Node Version Manager -----
source /usr/share/nvm/init-nvm.sh