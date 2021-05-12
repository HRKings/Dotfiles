# Load Antigen --------------------------------------------------------------------------
source /usr/share/zsh/share/antigen.zsh

# Load the oh-my-zsh's library --------------------------------
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh) ----
antigen bundle git

# Bundles from other repos ----------------------------------------------------
antigen bundle zsh-users/zsh-syntax-highlighting # Syntax highlighting bundle.
antigen bundle zsh-users/zsh-autosuggestions	 # Fish-like auto suggestions
antigen bundle zsh-users/zsh-completions		 # Extra zsh completions
antigen bundle agkozak/zsh-z					 # Z directory auto-jumping

# Load the theme. -------------------------------
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done. ----------------
antigen apply

# Powerlevel10k Config ------------------------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH parameter completion for the dotnet CLI -------------------------------------------

_dotnet_zsh_complete()
{
	local completions=("$(dotnet complete "$words")")

	reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

# Config keys ---------------------------------------------------------------------------
export DISABLE_LS_COLORS="true"
zstyle ':completion:*' list-colors

# Exports -------------------------------------------------------------------------------

## .NET path config for Arch --------------------------------
export PATH="$PATH:${HOME}/.dotnet/tools"
export DOTNET_ROOT=$(dirname $(realpath $(which dotnet)))

## External global tools ---------
export PATH="$PATH:${HOME}/.bin"

## Set default browser to Braus (Select broswer for each link) --
export BROWSER=braus

# Source other scripts ------------------------------------------------------------------

### Set up Node Version Manager -----------------
source /usr/share/nvm/init-nvm.sh

### Aliases -------------------------------------
source ~/.zsh_aliases.sh