#================================================================================================================================
# Exports
#================================================================================================================================

# .NET path config ---------------------------------------
export PATH="$PATH:${HOME}/.dotnet:${HOME}/.dotnet/tools"
export DOTNET_ROOT=$(dirname $(realpath $(which dotnet)))

# Go path config -------------
export GOPATH="${HOME}/go"

# External global tools -----------------------------------------
export PATH="$PATH:${HOME}/.bin:${GOPATH}/bin:${HOME}/.cargo/bin"

# Enable Anti Aliasing for fonts inside Java GUI aplications ---
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
