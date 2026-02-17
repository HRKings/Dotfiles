# Set the autoload file path
let autload_path = ([$nu.default-config-dir "autoload.nu"] | path join)

# Make the autoload file blank
"" | save -f $autload_path

# Autoload a directory
def autoload-dir [
  dirname: string
] {
  let full_path = ([$nu.default-config-dir $dirname] | path join)
  ls $full_path | each { $"source (['$nu.default-config-dir' $in.name] | path join)" } | save -a $autload_path
}

def autoload-plugin [
  plugin_name: string
] {
  $"plugin add nu_plugin_($plugin_name)\n" | save -a $autload_path
  $"plugin add nu_plugin_($plugin_name)\n" | save -a $autload_path
}

# Modules ------------------------
autoload-dir ./modules

# External commands Nu wrappers -----
autoload-dir ./externals

# Scripts ------------------------
autoload-dir ./scripts

# Plugins -------------------------
autoload-plugin skim
autoload-plugin json_path
