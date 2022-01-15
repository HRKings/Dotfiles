# Load the oh-my-zsh's library ----
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh) ----
antigen bundle git

# Bundles from other repos --------------------------------------------------------
antigen bundle Aloxaf/fzf-tab						                    # Use fzs for tab auto completion
antigen bundle zsh-users/zsh-autosuggestions		            # Fish-like auto suggestions
antigen bundle zsh-users/zsh-completions			              # Extra zsh completions
antigen bundle zdharma-continuum/fast-syntax-highlighting		# Syntax highlighting bundle
antigen bundle sobolevn/wakatime-zsh-plugin                 # WakaTime for terminal

# Load the theme. -------------------------------
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done. ----------------
antigen apply
