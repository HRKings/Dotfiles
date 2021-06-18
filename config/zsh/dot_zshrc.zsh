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

#================================================================================================================================
# SSH Agent Auto-Start
#================================================================================================================================

if [ -z "$SSH_AGENT_PID" ]
then
	eval "$(ssh-agent -s)" > /dev/null

	for file in $(find $HOME/.ssh -name "*.pri")
	do 
		ssh-add $file 2> /dev/null
	done
fi

#================================================================================================================================
# Source other scripts
#================================================================================================================================

# Set up Node Version Manager -----
source /usr/share/nvm/init-nvm.sh
