#==================================================================================================
# Powerlevel10k Instant Prompt
#==================================================================================================
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#==================================================================================================
# Antigen (ZSH Plugins)
#==================================================================================================

# Load Antigen --------------------------
source /usr/share/zsh/share/antigen.zsh

# Load Antigen bundles (cache) ----
antigen init ~/.antigenrc

#==================================================================================================
# Powerlevel10k Config 
#==================================================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#==================================================================================================
# The rest of my .zshrc
#==================================================================================================

source ~/.zshd/aliases.zsh
source ~/.zshd/variables.zsh
source ~/.zshd/functions.zsh
source ~/.zshd/completions.zsh

#====================================================================================================================================
# SSH Agent Auto-Start
#====================================================================================================================================

# Use keychain to handle SSH Agent startup and key loading, to keep only one instance
eval $(keychain --eval --noask -Q -q)
keychain -q $(find "$HOME/.ssh" -type f -not -name "*.pub" -and -not -name "config" -and -not -name "known_hosts*")

#================================================================================================================================
# Source other scripts
#================================================================================================================================

# Setup Zoxide ------------
eval "$(zoxide init zsh)"

# Set up Node Version Manager -----
source /usr/share/nvm/init-nvm.sh