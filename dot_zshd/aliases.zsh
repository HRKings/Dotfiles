#================================================================================================================================
# Aliases
#================================================================================================================================

# pacman and yay (If needed a LC_ALL=en.US in front of any of these commands to force the language to english) --------
alias pacup="sudo pacman -Syyu"								# Update only standard pkgs
alias yayup="yay -Sua"										# Update only AUR pkgs
alias yayupall="yay -Syyu --noconfirm"						# Update standard pkgs and AUR pkgs
alias pacunlock="sudo rm /var/lib/pacman/db.lck"			# Remove pacman lock
alias paccleanup="sudo pacman -Qtdq | sudo pacman -Rns -"	# Remove orphaned packages

# Get fastest mirrors -------------------------------------------------------------------------------
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Changing "ls" to "exa" --------------------------------------------------------------------------------------------------
alias ls="exa -al --color=always --group-directories-first --icons --header"				# My preferred listing
alias l.="exa -la --color=always --group-directories-first --icons | rg -P '\e\[[0-9]+m\.|\s\.'"	# All .files

# Confirm before overwriting something --------
alias mv="mvg -i"
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

# List installed packages ----
alias listpkg="pacman -Qent"
alias listaur="pacman -Qem"

# Log coloring
alias logc="ov --multi-color 'ERROR.*,WARN,INFO,DEBUG,not,^.{24}'"

# Change name of programs -------------------------------
alias vim="nvim"
alias cat="bat"
alias less="ov"
alias cd="z"
alias gzip="pigz"
alias kubectl="kubecolor"

# Simple shortcuts/renaming ------------------------------------------------------------------
alias open="xdg-open"
alias cshell="csharprepl"			# Open C# interactive shell (REPL)
alias rsshell="irust"					# Open Rust interactive shell (REPL)
alias lgit="lazygit"
alias ldocker="lazydocker"
alias py="python"
alias pbzip2="pbzip2"
alias sg="$HOME/.cargo/bin/sg"

# Kitty aliases --------------------------
alias kssh="kitty +kitten ssh"
alias icat="kitty +kitten icat"
alias hg="kitty +kitten hyperlinked_grep"

# Alias thefuck ----------
eval $(thefuck --alias)

# Alias Qalculate ----------------------------------------------------------------------------------------
aliases[=]='noglob qalc' # The equals sign `=` is not bindable by default, so we have to use this syntax

# Utility aliases ----------------------------------
alias toupper="tr '[:lower:]' '[:upper:]'"
alias tolower="tr '[:upper:]' '[:lower:]'"
alias brcat="brotli --stdout -d"

alias ulidgen="ulid"
alias ulidparse="ulid --format=rfc3339"

#================================================================================================================================
# Personal Shortcuts
#================================================================================================================================

alias editdot="chezmoi edit --apply" # Edit dotfiles
alias getgitbackup='echo "dura/$(git rev-parse HEAD)"' # Get the dura branch for the Git backups
alias zc="zi && code ." # Open Z interactive and open VSCode there
alias pacseek="pacseek -i -u"
alias conda_enable="source /opt/miniconda3/etc/profile.d/conda.sh"

# Create a Docker Compose file with a template
alias mkcompose="fd -at f 'docker-compose.yaml' '/mnt/BulkStorage/Dev/Docker_Projects/docker_compose_templates' | sd '(.*?docker_compose_templates)/' '\$1\t' | sd '/(docker-compose.yaml)' '\t\$1' | fzf --with-nth 2 --preview 'bat -f {1}/{2}/{3}' | sd '\t' '/' | xargs bat > docker-compose.yaml"

# Search python venv and conda envs in the current folder, and activate the selected
alias activate_pyenv='PYVENV=$(fd -HI -d 3 -t f "pyvenv.cfg" . | fzf --preview "ov {}" | xargs dirname) && source "$PYVENV/bin/activate"'
alias activate_conda='conda_enable && CONDA_ENV=$(conda env list | rg "^\s" | sd "^\s+" "" | rg "^$PWD" | fzf) && conda activate "$CONDA_ENV"'

# Download a file using gallery-dl on the current folder
alias gldhere="gallery-dl -D . "

#================================================================================================================================
# Personal Cheatsheets Shortcuts
#================================================================================================================================

alias csa="cheat arsenal -s"
alias csh="cheat shell -s"
alias csps="cheat snippets -s"
