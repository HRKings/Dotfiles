use std "path add"

# Load the default env variables for FNM
fnm env --json | from json | load-env

# Add to the path the NodeJS binary path
path add ($env.FNM_MULTISHELL_PATH | path join "bin")
