# Aliases ---------------------------------------------------------------------------------------------------------------

### pacman and yay (If needed a LC_ALL=en.US in front of any of these commands to force the language to english) --------
alias pacman="sudo powerpill"							  # Set powerpill as pacman
alias pacup="sudo powerpill -Syyu"						  # Update only standard pkgs
alias yayup="yay -Sua --noconfirm"						  # Update only AUR pkgs
#alias yayupall="yay -Syyu --noconfirm"					   # Update standard pkgs and AUR pkgs
#alias pacunlock="sudo rm /var/lib/pacman/db.lck"		   # Remove pacman lock
alias paccleanup="sudo powerpill -Rns $(powerpill -Qtdq)" # Remove orphaned packages

#### Get fastest mirrors --------------------------------------------------------------------------
#alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
#alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
#alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
#alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

### Changing "ls" to "exa" ----------------------------------------------------------------
alias ls="exa -al --color=always --group-directories-first --icons" # my preferred listing
alias la="exa -a --color=always --group-directories-first --icons"  # all files and dirs
alias ll="exa -l --color=always --group-directories-first --icons"  # long format
alias lt="exa -aT --color=always --group-directories-first --icons" # tree listing
alias l.="exa -a | egrep '^\.'"

### Colorize grep output (good for log files) --------
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

### Confirm before overwriting something --------
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

### Adding flags ------------------------------
alias df="df -h"		# human-readable sizes
alias free="free -m"	# show sizes in MB

### Get top process eating memory -----------------
alias psmem="ps auxf | sort -nr -k 4"
alias psmem10="ps auxf | sort -nr -k 4 | head -10"

### Get top process eating cpu --------------------
alias pscpu="ps auxf | sort -nr -k 3"
alias pscpu10="ps auxf | sort -nr -k 3 | head -10"

### Shortcuts -----------------------------------
alias editzsh="code ~/.zshrc"
alias updatezsh="source ~/.zshrc"
alias updatealias="source ~/.zsh_aliases.sh"
alias vim="nvim"
alias tp="trash-put"