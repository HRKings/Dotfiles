#================================================================================================================================
# Exports
#================================================================================================================================

# .NET path config ---------------------------------------
export PATH="$PATH:${HOME}/.dotnet:${HOME}/.dotnet/tools"
export DOTNET_ROOT="$(dirname $(realpath $(which dotnet)))"

# Go path config -------------
export GOPATH="${HOME}/go"

# External global tools -----------------------------------------
export PATH="$PATH:${HOME}/.local/bin:${GOPATH}/bin:${HOME}/.cargo/bin"

# Enable Anti Aliasing for fonts inside Java GUI aplications ---
export _JAVA_OPTIONS='-Dswing.aatext=TRUE -Dawt.useSystemAAFontSettings=on'

# WakaTime CLI -----------------------------
export ZSH_WAKATIME_BIN='/usr/bin/wakatime'

#================================================================================================================================
# ZStyle configs
#================================================================================================================================

# Configure ZSH Notify ------------------------------
zstyle ':notify:*' command-complete-timeout 1
zstyle ':notify:*' error-title "Command failed"
zstyle ':notify:*' success-title "Command finished"
zstyle ':notify:*' expire-time 15000
