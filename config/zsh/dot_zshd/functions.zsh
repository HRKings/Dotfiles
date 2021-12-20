#================================================================================================================================
# Functions
#================================================================================================================================

# Reload all ZSH configs ----------------------------------
function reloadzsh {
	for file in $(find "$HOME/.zshd" -type l -name "*.zsh")
	do
  	echo "\u001b[32m> Reloading \u001b[36m$file\u001b[0m"
		source $file
	done
}

# Select which Git email and GPG signing key to use inside a repository -----------------------------------------------
function gitcfg {
  GPG_EMAILS=$(gpg --list-secret-keys | grep ".*\@.*" | cut -d '<' -f 2 | cut -d '>' -f 1)
  GIT_EMAIL=$(printf "%s\n" "${GPG_EMAILS[@]}" | fzf --preview 'gpg --keyid-format=long --locate-keys {1}')

  if [[ ! -z "$GIT_EMAIL" ]]; then
    GPG_KEY=$(gpg --keyid-format=long --locate-keys "${GIT_EMAIL}" | head -n 1 | cut -d '/' -f 2 | cut -d ' ' -f 1)

    git config user.email "${GIT_EMAIL}" && git config user.signingkey "${GPG_KEY}"

    echo "\u001b[32mYour current GIT credentials are:\u001b[0m"
    echo "\u001b[36m - Name  :\u001b[0m $(git config user.name)"
    echo "\u001b[36m - Email :\u001b[0m $(git config user.email)"
    echo "\u001b[36m - GPG   :\u001b[0m $(git config user.signingkey)"
  fi
}

# Dump a GitHub gist into the specified file -----------------------------------------------------------------------------------------------------------
function dumpgist {
  if [[ -z "$1" ]]; then
    echo "Please provide a file name..."
    return
  fi

  GIST=$(gh gist list | cut -f 1,2 | fzf --preview 'echo {1} | cut -f 1 | xargs gh gist view --raw ')

  if [[ ! -z "$GIST" ]]; then
    gh gist view --raw "$(echo $GIST | cut -f 1)" | tail -n +3 > $1 \
      && echo "\u001b[32mCreated '\u001b[36m$1\u001b[0m' \u001b[32mwith the gist '\u001b[36m$(echo $GIST | cut -f 2)\u001b[32m' contents...\u001b[0m"
  fi
}

# List all packages in both Upstream and AUR, with fuzzy searching via fzf ----------------------------------------------------
function pkgfind {
	yay -Sl | awk '{print $2($4=="" ? "" : " *")}' | fzf --multi --preview 'yay -Si {1}' | cut -d " " -f 1 | xargs -ro yay -S
}

# Execute a Git command in all repositories contained in nested directories ----
function gitrecurse {
	for dir in $(find . -name ".git")
	do 
		cd ${dir%/*}
		echo "\u001b[32m> $PWD\u001b[0m"
		git $@
		cd - > /dev/null
	done
}

# Executes a diff in two strings ----------------------------------------
function stringdiff {
	echo $1 > /tmp/string_diff_file_1
	echo $2 > /tmp/string_diff_file_2
	delta /tmp/string_diff_file_1 /tmp/string_diff_file_2
}

# Open ranger and cd into the directory if you quit with Q ------------------------------------
function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )
    
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}