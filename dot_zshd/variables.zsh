#================================================================================================================================
# PATH
#================================================================================================================================

export PATH="${HOME}/.local/path_override:$PATH:${HOME}/.local/bin:${HOME}/.local/scripts:${GOPATH}/bin:${HOME}/.cargo/bin:${HOME}/.local/share/JetBrains/Toolbox/scripts:${HOME}/.dotnet/tools:${HOME}/go/bin:${HOME}/.bun/bin"

#================================================================================================================================
# Exports
#================================================================================================================================

# Get sudo password from 1Password ---------------------------
export SUDO_ASKPASS="${HOME}/.local/scripts/1password_sudo"

# Go path config -------------
export GOPATH="${HOME}/go"

# Enable Anti Aliasing for fonts inside Java GUI applications ----------------
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

# Colorize LS matching my theme of choice ---------------
export LS_COLORS="$(vivid generate catppuccin-mocha)"

#================================================================================================================================
# ZSH plugins configs
#================================================================================================================================

# Configure ZSH Notify ------------------------------
zstyle ':notify:*' command-complete-timeout 1
zstyle ':notify:*' app-name 'zsh'
zstyle ':notify:*' error-title '❌ Failed in #{time_elapsed} | Exit-Code: #{exit-code}'
zstyle ':notify:*' success-title 'Finished in #{time_elapsed}'
zstyle ':notify:*' expire-time 15000
