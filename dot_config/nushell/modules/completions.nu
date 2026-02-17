# Carapace
def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

let carapace_completer = {|spans|
  $env.CARAPACE_BRIDGES = 'fish,zsh,bash,inshellisense'

	^carapace $spans.0 nushell ...$spans | from json
}

# Fish
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

# Zoxide (z)
let zoxide_completer = {|spans|
	$spans | skip 1 | ^zoxide query -l ...$in | lines | where { |x| $x != $env.PWD }
}

# This completer will use carapace by default
let external_completer = {|spans|
	let expanded_alias = scope aliases
		| where name == $spans.0
		| get -o 0.expansion
    | default ''
    | str trim -l -c '^' # Remove the leading '^' if we are calling an external command

	let spans = if ($expanded_alias != null and ($expanded_alias | is-not-empty)) {
		$spans
			| skip 1
			| prepend ($expanded_alias | split row ' ' | take 1)
	} else {
		$spans
	}

	match $spans.0 {
		# carapace completions are incorrect for nu
		nu => $fish_completer
		# fish completes commits and branch names in a nicer way
		git => $fish_completer
		# use zoxide completions for zoxide commands
		__zoxide_z | __zoxide_zi => $zoxide_completer
    # Marimo does not have any nushell compatible completions
    marimo => $fish_completer
    nvim | neovide => $fish_completer
    # Fallback to carapace if by default
		_ => $carapace_completer
	} | do $in $spans
}

$env.config = $env.config? | default {} | upsert completions {
	external: {
			enable: true
			completer: $external_completer
	}
}
