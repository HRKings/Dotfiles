# Install all packages ---------------------
echo "Installing all required packages..."
source ${PWD}/scripts/install_packages.sh

# Install configs ---------------------
echo "Installing all the configs..."
source ${PWD}/install_configs.sh

# Install VSCode extensions --------------------------
echo "Installing all the required VSCode extensions"
source ${PWD}/scripts/install_vscode_extensions.sh