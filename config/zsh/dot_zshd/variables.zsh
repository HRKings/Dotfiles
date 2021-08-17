#================================================================================================================================
# Exports
#================================================================================================================================

# .NET path config for Arch ------------------------------
#export PATH="$PATH:${HOME}/.dotnet/tools"
export DOTNET_ROOT=$(dirname $(realpath $(which dotnet)))

# External global tools ---------
export PATH="$PATH:${HOME}/.bin"

PATH=$PATH:/home/ton/Dev/Work/Rewrite/consultorio-dev-utilities/bash/scripts

# Set default browser to Braus (Select broswer for each link) --
#export BROWSER=${HOME}/.bin/browser_chooser.sh