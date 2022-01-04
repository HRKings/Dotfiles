#! /usr/bin/bash

#==================================================================================================
# Complete installation
#==================================================================================================

# Install all packages ---------------------
echo "> Installing all required packages..."
source "${PWD}/install_scripts/install_packages.sh"

# Clone private dotfiles --------------------------------------
echo "> Cloning private dotfiles..."
git clone https://github.com/HRKings/Private-Dotfiles.git .private

# Install configs ---------------------
echo "> Installing all the configs..."
dotbot -c install.conf.yaml

# Set ZSH as the default shell ----
echo "> Setting ZSH as the default shell..."
chsh -s /bin/zsh

# Install VSCode extensions ------------------------------
echo "> Installing all the required VSCode extensions..."
source "${PWD}/install_scripts/install_vscode_extensions.sh"

# Install .NET ---------------------------------------
echo "> Installing .NET..."
wget 'https://dot.net/v1/dotnet-install.sh' -O "${HOME}/.bin/dotnet-install"
chmod +x "${HOME}/.bin/dotnet-install"
dotnet-install

# Install .NET global tools --------------------------
echo "> Installing all the .NET global tools..."
source "${PWD}/install_scripts/install_dotnet_tools.sh"

# Install Rust -------------------------------------------------
echo "> Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Ranger icons ----------------------------------------------------------------------------------
echo "> Installing Ranger icons..."
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

# =========================================================================
# Finish installation
# =========================================================================

echo "Installation complete, restart the terminal to load the new setup!"