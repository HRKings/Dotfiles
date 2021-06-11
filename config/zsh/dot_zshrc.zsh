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
# ZInit (ZSH Plugins)
#==================================================================================================

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit snippet OMZ::plugins/git/git.plugin.zsh           # Load OhMyZsh!
zinit snippet PZT::modules/helper/init.zsh              # Load Prezto

zinit light Aloxaf/fzf-tab					            # Use fzs for tab auto completion
zinit light zsh-users/zsh-autosuggestions	            # Fish-like auto suggestions
zinit light zsh-users/zsh-completions		            # Extra zsh completions
zinit light zdharma/fast-syntax-highlighting	        # Syntax highlighting bundle
zinit light agkozak/zsh-z					            # Z directory auto-jumping

zinit ice depth=1; zinit light romkatv/powerlevel10k    # Custom prompt

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
# Source other scripts
#================================================================================================================================

# Set up Node Version Manager -----
source /usr/share/nvm/init-nvm.sh