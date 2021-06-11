#==================================================================================================
# Complete installation
#==================================================================================================

# Install all packages ---------------------
echo "> Installing all required packages..."
source ${PWD}/install_scripts/install_packages.sh

# Install Zinit -----------------------------------------------------------------------------
echo "> Installing ZInit..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
echo "After everything is done, run 'zinit self-update' in a new terminal to complete ZInit installation!"

# Install configs ---------------------
echo "> Installing all the configs..."
dotbot -c install.conf.yaml

# Install VSCode extensions --------------------------
echo "> Installing all the required VSCode extensions"
source ${PWD}/install_scripts/install_vscode_extensions.sh

# Install .NET global tools --------------------------
echo "> Installing all the .NET global tools"
source ${PWD}/install_scripts/install_dotnet_tools.sh