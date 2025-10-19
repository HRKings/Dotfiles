# Execute the append operation only if the condition is true
def append-if [
  condition: bool
  value: any
]: any -> list<any> {
  let _in = $in
  $_in | if ( $condition ) { append $value } else { $_in }
}

def "contains column" [
  column: cell-path
  input?
] {
  let _in = $in
  let input = ($input | default $_in )

  not ($input | get -o $column | is-empty)
}

# Given a list of booleans, return if there is more than one true value
def has-multiple-trues []: list<bool> -> bool {
  let _in = $in
  ($_in | where $it | length) > 1
}

# Check if a string is blank (not null and cannot contain only space characters)
def "str is-blank" [
  input?: string
]: [ string -> bool, nothing -> bool ] {
  let _in = $in
  let input = ($input | default $_in | default '')

  $input | str trim | is-empty
}

# Hash a value using the blake3 hash algorithm.
def "hash blake3" [
  --binary (-b)       # Output binary instead of hexadecimal representation
  ...rest: cell-path  # Optionally blake3 hash data by cell path
]: [
  string -> any,
  binary -> any,
  table -> table,
  record -> record,
] {
  let _in = $in
  if ( $_in | is-empty ) {
    print (help hash blake3)
    return
  }

  if ( $rest | is-not-empty ) {
    mut result = $_in

    for cell_path: cell-path in $rest {
      $result = $result | update $cell_path {
        $_in | get $cell_path | if ($binary) { ^b3sum --raw | into binary } else { ^b3sum --no-names }
      }
    }

    return $result
  }

  if ($binary) {
    return ($_in | ^b3sum --raw | into binary)
  }

  $_in | ^b3sum --no-names
}

# Verify is a date is older than a specified duration
def is-older-than [
  time: duration
]: [ datetime -> bool ] {
  let _in = $in
  let diff = ((date now) - $_in)

  $diff > $time
}

def "file modified-at" [
  path?: string
]: [ any -> datetime ] {
  let _in = $in
  let path = ($path | default $_in)

  if ( not ( $path | path exists ) ) {
    error make {
      msg: "The path cannot be found"
      label: {
					text: "The provided path",
					span: {
						start: (metadata $path).span.start,
						end: (metadata $path).span.end
					}
			}
    }
  }

  ls $path | get modified | get 0
}

# A wrapper around the default http nushell command with support for caching, which means that a request will be done only once in a specified time frame
# WARNING: This always imply --raw on `http` to make sure we can always save the output to cache
def --wrapped http-cached [
  --expiry (-e): duration = 10min # How long the cached value should be valid for
  method: string
  ...params                       # Default params for the http command (including the HTTP method)
] {
  if ( ("--help" in $params) or ("-h" in $params) ) {
    nu -c $"help http ($method)"
    return
  }

  # Save the cache as `.nuon` to save the structured full response
  let file_extension = if ( ("--full" in $params) or ("-f" in $params) ) { ".nuon" } else { '' }

  let params_string = ($params | str join ' ')

  let hash = ( [$method, $params_string] | str join ' ' | hash blake3 )

  let cache_path = ( ["/tmp/", $"nushell_http-($hash)($file_extension)"] | path join )

  if ( not ($cache_path | path exists) or ( file modified-at $cache_path | is-older-than $expiry )) {
    ^nu -c $"http ($method) --raw ($params_string) | save -f ($cache_path)"
  }

  open $cache_path
}

# Sanitizes a filename, transliterating, removing special charactes, spaces and more, providing the cleanest path possible
def "sanitize filename" [
  --uconv (-u) # Uses `uconv -x ASCII`, which is slower, but is less error prone
  --relax (-r) # Drops the `-c` from `iconv -c`, which throws errors on characters it cannot convert, if combined with `--uconv` it will change the transliteration from ASCII to Latin-ASCII
  input?: oneof<string, list<string>>
]: [ string -> string, list<string> -> list<string> ] {
  let _in = $in
  let input = ($input | default $_in)
  let input_type = ($input | describe)

  let detox_input = ($input | to text | ^detox --inline)

  if ($relax and $uconv) {
    return ($detox_input | ^uconv -f UTF-8 -t UTF-8 -x Latin-ASCII)
  } else if ($relax) {
    return ($detox_input | ^iconv -f UTF-8 -t ASCII//TRANSLIT)
  } else if ($uconv) {
    return ($detox_input | ^uconv -f UTF-8 -t UTF-8 -x ASCII)
  }

  let result = ($detox_input | ^iconv -c -f UTF-8 -t ASCII//TRANSLIT)

  if ($input_type == 'list<string>') {
    return ($result | lines)
  }

  $result
}

# Set ANSI coloring for one string input and then reset it afterwards
def "ansi once" [
  format
  text?: string
] {
  let _in = $in
  let input = ($text | default $_in)

  print $"(ansi $format)($input)(ansi reset)"
}

# Take a filename as an input and print it with the new extension
# useful for renaming or converting files
def "change extension" [
  new_extension: string
  input?: path
] {
  let _in = $in
  let input = ($input | default $_in)

  $"($input | path parse | get stem).($new_extension)"
}
