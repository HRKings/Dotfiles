source ./utilities.nu

# ----- Git -----

# Git Commit
alias gc = ^git commit
# Git Commit --Amend
alias gca = ^git commit --amend --no-edit

# Git StaTus
alias gst = ^git status
# Git Log Oneline
alias glo = ^git log --oneline
# Git Branch --show-Current
alias gbc = ^git branch --show-current

# Git Switch
alias gs = ^git switch
# Git CheckOut
alias gco = ^git checkout

# Git CloNe
alias gcn = ^git clone

# Git PuSh
alias gps = ^git push
# Git Fetch --All
alias gfa = ^git fetch --all
# Git PulL --autostash
alias gpl = ^git pull --autostash

# Git Rebase
alias gr = ^git rebase
# Git Rebase --Continue
alias grc = ^git rebase --continue
# Git Rebase --Abort
alias gra = ^git rebase --abort

# Git Merge
alias gm = ^git merge
# Git Merge --Continue
alias gmc = ^git merge --continue
# Git Merge --Abort
alias gma = ^git merge --abort

# Git StasH
alias gsh = ^git stash
# Git Stash Pop
alias gsp = ^git stash pop

# ----- Lazy -----

def --wrapped "lzg" [ ...params ] {
  let config_dir = ( $env.HOME | path join ".config" )
  let lazygit_config = ( $config_dir | path join "lazygit/config.yml" )
  let lazygit_theme = ( $config_dir | path join "lazygit/catppuccin_mocha_lavender.yaml" )

  ^lazygit --use-config-file=$"($lazygit_theme),($lazygit_theme)" ...$params
}
alias lazygit = lzg

alias lzd = ^lazydocker

alias "==" = qalc

# ----- Docker -----

# Docker Compose Pull
alias dcp = ^docker compose pull

# Docker Compose Up
alias dcu = ^docker compose up
# Docker Compose Down
alias dcd = ^docker compose down

# ------------------------------------------------------------------------------------------------------------------------

# exa with icons, grouped directories and in list format
alias exa = ^exa -la --icons --group-directories-first

# exa with icons, grouped directories and in list format (always icons and colors, for pipelines)
alias exap = ^exa -la --color=always --icons=always --group-directories-first

# List filesystem with all options, hidden files, multi threading and sorting by type
def --wrapped lsa [
  --short-names (-s), # Only print the file names, and not the path
  --full-paths (-f),  # display paths as absolute paths
  --du (-d),          # Display the apparent directory size ("disk usage") in place of the directory metadata size
  --directory (-D),   # List the specified directory itself instead of its contents
  --mime-type (-m),   # Show mime-type in type column instead of 'file' (based on filenames only; files' contents are not examined)
  ...pattern,
] {
  if ( ("--help" in $pattern) or ("-h" in $pattern) ) {
    print (ls --help)
    return
  }

	let pattern = if ( $pattern | is-empty ) { [ '.' ] } else { $pattern } # Use the current path when no params are provided

	(ls
    -lat
    --short-names=$short_names
    --full-paths=$full_paths
    --du=$du
    --directory=$directory
    --mime-type=$mime_type
    ...$pattern
  ) | sort-by type name --ignore-case
}

# ------------------------------------------------------------------------------------------------------------------------

# Use yazi to navigate the filesystem
def --env ycd [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")

	^yazi ...$args --cwd-file $tmp

	let cwd = (open $tmp)

	if $cwd != "" and $cwd != $env.PWD {
		__zoxide_z $cwd
	}

	rm -fp $tmp
}

# ------------------------------------------------------------------------------------------------------------------------

# Make files executable
def "mkexec" [
  path: glob
] {
  let files = (ls $path | where type == file | get name)

  for filePart in $files {
    print $"Making `($filePart)` executable"
    ^chmod +x $filePart
  }
}

# -----------------------------------------------

# Update all system packages
def "paru update" [] {
  ^paru -Syyu --upgrademenu --combinedupgrade
}

# -----------------------------------------------

# Sometimes I forgot in which folder I am
def whereami [] { echo $env.PWD }

# ------------------------------------------------

# Kubectl but with sparkles
alias kubectl = ^kubecolor

# -------------------------------------------------------------------

# Provides a nice grid from many images and open then in Oculante
def "show imagegrid" [ ...params ] {
  let img_hash = ($params | str join | hash blake3)
  let img_path = $"/tmp/image_grid-($img_hash).png"

  if (not ($img_path | path exists)) {
    ^montage ...$params -mode concatenate -resize 256 $img_path
  }

  ^oculante $img_path
}

# ----------------------------------------------------------------------

# A shorthand for `where $it =~ TERM`
def filter [
  search_term: string,
  input?: list<string>,
] {
  let _in = $in
  let input = ($input | default $_in )

  $input | where $it =~ $search_term
}

# ---------------------------------------------------------------
# Source: https://ghostty.org/docs/help/terminfo

# Copy ghostty terminfo to a remote server
def "terminfo ghostty ssh" [
  ssh_server: string
] {
  ^infocmp -x xterm-ghostty | ^ssh $ssh_server -- tic -x -
}


# --------------------------------------------------

def "ssh passonly" [
  ...params
] {
  ^ssh -o PubkeyAuthentication=no -o PreferredAuthentications=password ...$params
}

def "ssh keyonly" [
  ...params
] {
  ^ssh -o PubkeyAuthentication=yes -o PreferredAuthentications=publickey ...$params
}

# --------------------------------------------------

alias cls = clear
