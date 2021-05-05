# Set some variables ------------------------------------------------
CONFIG_DIR=$(dirname $PWD)

# ZSH Config ---------------------------------------------------
echo "-- Creating symlink to zsh config --"
ln -sf ${CONFIG_DIR}/config/.zshrc ${HOME}/.zshrc

# Powerlevel10k Config -----------------------------------------
echo "-- Creating symlink to powerlevel10k config --"
ln -sf ${CONFIG_DIR}/config/.p10k.zsh ${HOME}/.p10k.zsh

# Aliases ------------------------------------------------------
echo "-- Creating symlink to the aliases script --"
ln -sf ${CONFIG_DIR}/scripts/.zsh_aliases.sh ${HOME}/.zsh_aliases.sh

# Ranger config ------------------------------------------------
echo "-- Creating symlink to ranger config --"
ln -sf ${CONFIG_DIR}/config/dotConfig/ranger/rc.conf ${HOME}/.config/ranger/rc.conf

echo "-- Installing ranger devicons --"
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# Noto Color Emoji ------------------------------------------------
echo "-- Creating symlink to emoji config --"
ln -sf ${CONFIG_DIR}/config/fontconfig/99-noto-color-emoji.conf ${HOME}/.config/fontconfig/conf.d/99-noto-color-emoji.conf