# Nushell Environment Config File
#
# initial version = "0.99.1"

# The prompt indicators are environmental variables that represent ---------
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "› " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "󰗧› " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "› " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "󱞩 " }

# hide-env MISE_INSTALLS_DIR
# hide-env MISE_DATA_DIR

# Mise is done early as some of its paths are used here
# Generate mise activation script ----
(^env -i (which 'mise' | first | get 'path') activate nu) | save -f ([$nu.default-config-dir "shell" "mise.nu"] | path join)
# ^mise activate nu | save -f ([$nu.default-config-dir "shell" "mise.nu"] | path join)

# Directories to search for scripts when calling source or use ----------------------------
$env.NU_LIB_DIRS = [
  ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
  ($nu.data-dir | path join 'completions') # default home for nushell completions

  ($nu.default-config-dir | path join 'modules')
]

# Directories to search for plugin binaries when calling register ------------------------
$env.NU_PLUGIN_DIRS = [
  ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
  # ( $env.HOME | path join ".cargo/bin" )
  (mise where cargo:nu_plugin_skim | path join 'bin')
  (mise where cargo:nu_plugin_ulid | path join 'bin')
  (mise where cargo:nu_plugin_json_path | path join 'bin')
  ("/usr/bin")
]

# Compatibility with session managers --------------

# Set general env variables ---------------------
$env.SUDO_ASKPASS = ($env.HOME | path join ".local/scripts/1password_sudo")
$env.BROWSER = "re.sonny.Junction"
$env.GOPATH = (mise where go | path dirname)
$env.DOTNET_INSTALL_DIR = ($env.HOME | path join ".dotnet")
$env.DOTNET_ROOT = ($env.DOTNET_INSTALL_DIR)
$env.ANDROID_HOME = ($env.HOME | path join "Android/Sdk")

# Add new folders to the PATH -------------------------------------------------------
use std "path add"

path add ($env.HOME | path join ".local/bin")
path add ($env.HOME | path join ".local/scripts")
path add ($env.DOTNET_INSTALL_DIR)

path add ($env.HOME | path join ".local/share/JetBrains/Toolbox/scripts")

# Remove any duplicates from the PATH ---
$env.PATH = ($env.PATH | uniq)

# Add PATH override to the start of the list
$env.PATH = ($env.PATH | insert 0 ($env.HOME | path join ".local/path_override"))

# Cache all the executables in the path for auto-completion ------------------------------------------
$env.EXECUTABLES_IN_PATH = (fd -t x . ...$env.PATH e> /dev/null | lines | path basename)

# Use `ov` for `man` pages -----------------------------------------
# $env.MANPAGER = 'ov --section-delimiter '^[^\s]' --section-header'
$env.MANPAGER = 'bat -l man -fn --paging=always'
$env.MOOR = '--terminal-fg -style catppuccin-mocha'

# # Bold (md) — Lavender
# $env.LESS_TERMCAP_md = (printf '\x1b[38;2;180;190;254;1m')
#
# # Blink (mb) — Lavender (almost never used)
# $env.LESS_TERMCAP_mb = (printf '\x1b[38;2;180;190;254;1m')
#
# # Underline (us) — Blue (more readable than lavender underline)
# $env.LESS_TERMCAP_us = (printf '\x1b[38;2;137;180;250m')
#
# # Reset underline/bold/blink
# $env.LESS_TERMCAP_ue = (printf '\x1b[0m')
# $env.LESS_TERMCAP_me = (printf '\x1b[0m')
#
# # Standout / status line — Surface0 bg + Text fg + bold
# $env.LESS_TERMCAP_so = (printf '\x1b[38;2;205;214;244;48;2;49;50;68;1m')
# $env.LESS_TERMCAP_se = (printf '\x1b[0m')
#
# Use `ov` for `bat` ---------
$env.BAT_PAGER = "moor"

# Use `ov` as the default pager ---------
$env.PAGER = "moor"

# Create the LS_COLORS for my preferred theme ----------
$env.LS_COLORS = (vivid generate catppuccin-mocha)

# Disable uv's venv prompt since we already use prompt theming -----
$env.VIRTUAL_ENV_DISABLE_PROMPT = true

# Call the autoload prelude to build the autoload file ---------------------
source ./autoload-prelude.nu
