#================================================================================================================================
# PATH
#================================================================================================================================

export PATH="$PATH:${HOME}/.local/bin:${GOPATH}/bin:${HOME}/.cargo/bin:${HOME}/.local/share/JetBrains/Toolbox/scripts:${HOME}/.dotnet/tools:${HOME}/go/bin"

#================================================================================================================================
# Exports
#================================================================================================================================

# Go path config -------------
export GOPATH="${HOME}/go"

# Enable Anti Aliasing for fonts inside Java GUI aplications ----------------
export _JAVA_OPTIONS='-Dswing.aatext=TRUE -Dawt.useSystemAAFontSettings=on'

# Set miniconda as the main Conda ----------
export CONDA_ROOT_PREFIX="/opt/miniconda3"

# Use browser chooser as default ----
export BROWSER="re.sonny.Junction"

# Use `ov` for `man` pages -----------------------------------------
export MANPAGER="ov --section-delimiter '^[^\s]' --section-header"

# Use `ov` for `bat` ---------
export BAT_PAGER="ov -F -H3"

# Enable cheatsheet integration with fzf -----
export CHEAT_USE_FZF=true

#================================================================================================================================
# ZSH plugins configs
#================================================================================================================================

# Configure ZSH Notify ------------------------------
zstyle ':notify:*' command-complete-timeout 1
zstyle ':notify:*' app-name 'zsh'
zstyle ':notify:*' error-title '❌ Failed in #{time_elapsed} | Exit-Code: #{exit-code}'
zstyle ':notify:*' success-title 'Finished in #{time_elapsed}'
zstyle ':notify:*' expire-time 15000

#================================================================================================================================
# Keybinds for ZSH
#================================================================================================================================

# Ctrl+Arrow Keys to jump between words (this replaces the only use case I had for oh-my-zsh. At least I think...)
# bindkey "^[[1;5C" forward-word
# bindkey "^[[1;5D" backward-word
