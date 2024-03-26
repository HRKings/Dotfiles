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
# ZStyle configs
#================================================================================================================================

# Configure ZSH Notify ------------------------------
zstyle ':notify:*' command-complete-timeout 1
zstyle ':notify:*' error-title "Command failed"
zstyle ':notify:*' success-title "Command finished"
zstyle ':notify:*' expire-time 15000
