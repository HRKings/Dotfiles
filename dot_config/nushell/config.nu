# Nushell Config File
#
# initial version = "0.99.1"

# Theme ------------------------------
source ./themes/catppuccin-mocha.nu

# Create the Atuin hiding token -------------------
$env.ATUIN_KEYBINDING_TOKEN = $"# (random uuid)"
$env.ATUIN_CONFIG_DIR = ($env.HOME | path join ".config/atuin-nushell")

# Nushell configs ------------------------------------------------------------------------------------------------------
source ./options/main.nu
source ./options/menus.nu
source ./options/keybinds.nu

# Built-in plugins ----------------------------------------
use std *

# External shell utilities -----
source ./shell/atuin.nu
source ./shell/zoxide.nu
source ./shell/starship.nu
use ./shell/mise.nu

# Autoload -----------
source ./autoload.nu
