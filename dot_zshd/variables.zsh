#================================================================================================================================
# PATH
#================================================================================================================================

export PATH="$PATH:${HOME}/.local/bin:${GOPATH}/bin:${HOME}/.cargo/bin:${HOME}/.local/share/JetBrains/Toolbox/scripts:${HOME}/.dotnet/tools"

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

#================================================================================================================================
# ZSH plugins configs
#================================================================================================================================

# Configure ZSH Notify ------------------------------
zstyle ':notify:*' command-complete-timeout 1
zstyle ':notify:*' app-name 'zsh'
zstyle ':notify:*' error-title '❌ Failed in #{time_elapsed} | Exit-Code: #{exit-code}'
zstyle ':notify:*' success-title 'Finished in #{time_elapsed}'
zstyle ':notify:*' expire-time 15000
