# Nushell Environment Config File
#
# initial version = "0.99.1"

# The prompt indicators are environmental variables that represent ---------
# the state of the prompt
$env.PROMPT_INDICATOR = { || "› " }
$env.PROMPT_INDICATOR_VI_INSERT = { || "󰗧› " }
$env.PROMPT_INDICATOR_VI_NORMAL = { || "› " }
$env.PROMPT_MULTILINE_INDICATOR = { || "󱞩 " }

# Directories to search for scripts when calling source or use ----------------------------
$env.NU_LIB_DIRS = [
	( $nu.default-config-dir | path join 'scripts' ) # add <nushell-config-dir>/scripts
	( $nu.data-dir | path join 'completions' ) # default home for nushell completions

	( $nu.default-config-dir | path join 'modules' )
]

# Directories to search for plugin binaries when calling register ------------------------
$env.NU_PLUGIN_DIRS = [
	( $nu.default-config-dir | path join 'plugins' ) # add <nushell-config-dir>/plugins
	( $env.HOME | path join ".cargo/bin" )
	( "/usr/bin" )
]

# Compatibility with session managers --------------

if (($env | get -o XDG_SESSION_TYPE | default "wayland") == "wayland") {
  $env.WAYLAND_DISPLAY = "wayland-0"
} else {
  $env.DISPLAY = "0"
}

# Set general env variables ---------------------
$env.SUDO_ASKPASS = ( $env.HOME | path join ".local/scripts/1password_sudo" )
$env.BROWSER = "re.sonny.Junction"
$env.GOPATH = ( $env.HOME | path join "go" )
$env.DOTNET_INSTALL_DIR = "/usr/share/dotnet"
$env.DOTNET_ROOT = "/usr/share/dotnet"
$env.GTK_USE_PORTAL = 1 # Use the correct file picker for everything
$env.ANDROID_HOME = ( $env.HOME | path join "Android/Sdk" )

# Add new folders to the PATH -------------------------------------------------------
use std "path add"

path add ( $env.HOME | path join ".local/bin" )
path add ( $env.HOME | path join ".local/scripts" )

path add ( $env.HOME | path join ".bun/bin" )
path add ( $env.HOME | path join ".cargo/bin" )
path add ( $env.HOME | path join ".dotnet/tools" )

path add ( $env.HOME | path join ".local/share/JetBrains/Toolbox/scripts" )

path add ( $env.GOPATH | path join "bin" )

# Remove any duplicates from the PATH ---
$env.PATH = ( $env.PATH | uniq )

# Add PATH override to the start of the list
$env.PATH = ( $env.PATH | insert 0 ($env.HOME | path join ".local/path_override") )

# Cache all the executables in the path for auto-completion ------------------------------------------
$env.EXECUTABLES_IN_PATH = ( fd -t x . ...$env.PATH e> /dev/null | lines | path basename )

# Use `ov` for `man` pages -----------------------------------------
$env.MANPAGER = 'ov --section-delimiter '^[^\s]' --section-header'

# Use `ov` for `bat` ---------
$env.BAT_PAGER = "ov -F -H3"

# Enable cheatsheet integration with fzf -----
$env.CHEAT_USE_FZF = true

# Create the LS_COLORS for my preferred theme ----------
$env.LS_COLORS = ( vivid generate catppuccin-mocha )

# Disable uv's venv prompt since we already use prompt theming -----
$env.VIRTUAL_ENV_DISABLE_PROMPT = true

# Generate mise activation script and add the shims ----
^mise activate nu | save -f ([$nu.default-config-dir "shell" "mise.nu"] | path join)
let shims_path = ( [ $env.HOME ".local/share/mise/shims" ] | path join )
$env.PATH = ($env.PATH | prepend $shims_path )

# Call the autoload prelude to build the autoload file ---------------------
source ./autoload-prelude.nu
