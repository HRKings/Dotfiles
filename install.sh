# ZSH Config ---------------------------------------------------
echo "Creating symlink to zsh config"
ln -sf ${PWD}/config/.zshrc ${HOME}/.zshrc

# Aliases ------------------------------------------------------
echo "Creating symlink to the aliases script"
ln -sf ${PWD}/scripts/.zsh_aliases.sh ${HOME}/.zsh_aliases.sh

# Ranger config ------------------------------------------------
echo "Creating symlink to ranger config"
ln -sf ${PWD}/config/rc.conf ${HOME}/.config/ranger/rc.conf

# Noto Color Emoji ------------------------------------------------
echo "Creating symlink to ranger config"
ln -sf ${PWD}/config/99-noto-color-emoji.conf ${HOME}/.config/fontconfig/conf.d/99-noto-color-emoji.conf