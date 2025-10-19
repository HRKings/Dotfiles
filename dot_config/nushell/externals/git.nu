# Compare the current branch with it's upstream version
def "git compare upstream" [] {
  ^git log --oneline HEAD..@{upstream}
}

# Compare the current branch with it's upstream version, showing the commits on skim for visualizing the diff
def "git compare upstream diff" [] {
  ^git log --format='%h' HEAD..@{upstream} | lines | sk --preview={ git diff $in | delta }
}

# Show on which branch every sub directory is on the current path
def "git branches list-folder" [
  --show-full-paths (-f)
] {
  let folders = ( ls -f | where type == dir | get name )
  mut result = [[path,branch];[null null]]

  for folder in $folders {
    cd $folder

    let current_branch = try {
      git branch --show-current e> /dev/null
    }

    if ($current_branch | is-empty) {
      continue
    }

    let folder_name = if $show_full_paths {
      $folder
    } else {
      $folder | path parse | get stem
    }

    let branch_path = [[path]; [$folder_name]] | merge [[branch]; [$current_branch]]

    $result = $result | append $branch_path
  }

  $result | where path != null
}
alias gblf = git branches list-folder

def "git stash list" [

] {
  ^git stash list --pretty='%gd %s' | parse '{index} {message}' | upsert index { str trim } | upsert message { str trim }
}
alias gsl = git stash list

# A lazy shortcut to create a branch from another one
def "git branch create" [
  --trunk (-t): string = "" # The branch from which the new one will be derived from
  name: string
] {
  mut params = [ "-b" $name ]

  if ($trunk | str trim | is-not-empty) {
    $params = $params | append $trunk
  }

  ^git checkout ...$params
}
alias gbn = git branch create

# Stash some changes with a message
def "git stash message" [
  name: string
] {
  ^git stash push -Sm $name
}
alias gsm = git stash message

# Search for the message in the stash and pop it
def "git stash message pop" [
  name: string
] {
  let stash = ( git stash list | where $it.message == $name )

  gum style --bold "Stash found:"
  gum style --border="rounded" $stash.name

  git stash pop $stash.name
}
alias gsmp = git stash message pop

def "git default-branch get" [] {
  basename (^git rev-parse --abbrev-ref origin/HEAD)
}
alias gdbg = git default-branch get

def "git default-branch update" [] {
  ^git remote set-head origin -a
}
alias gdbu = git default-branch update


def "git switch default-branch" [
  --update (-u)
] {
  if ($update) {
    git default-branch update
  }

  ^git switch (git default-branch get)
}
alias gsd = git switch default-branch
