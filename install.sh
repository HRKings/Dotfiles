# ZSH Config ---------------------------------------------------
echo "Creating symlink to zsh config"
ln -sf ${PWD}/config/.zshrc ${HOME}/.zshrc

# Aliases ------------------------------------------------------
echo "Creating symlink to the aliases script"
ln -sf ${PWD}/scripts/.zsh_aliases.sh ${HOME}/.zsh_aliases.sh

# Ranger config ------------------------------------------------
echo "Creating symlink to ranger config"
ln -sf ${PWD}/config/rc.conf ${HOME}/.config/ranger/rc.conf
echo "Installing ranger devicons"
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# Noto Color Emoji ------------------------------------------------
echo "Creating symlink to ranger config"
ln -sf ${PWD}/config/99-noto-color-emoji.conf ${HOME}/.config/fontconfig/conf.d/99-noto-color-emoji.conf