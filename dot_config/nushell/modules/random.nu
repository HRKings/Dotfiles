# Source the utilities used in this script
source ./utilities.nu

# Generate a random value using OpenSSL
def "random ssl" [
	--hex (-h)
	--base64 (-b)
	quantity: int
] {
	if ( $hex and $base64 ) {
		let span_start = ( [ (metadata $hex).span.start, (metadata $base64).span.start ] | math max )
		let span_end = ( [ (metadata $hex).span.end, (metadata $base64).span.end ] | math max )

		error make {
			msg: "Please choose only one encoding",
			label: {
					text: "Second encoding provided here",
					span: {
						start: $span_start,
						end: $span_end
					}
			}
		}
	}

	if ( $quantity <= 0 ) {
		error make {
			msg: "Please provide a valid quantity",
			label: {
					text: "Quantity here",
					span: (metadata $quantity).span
			}
		}
	}

	let params = []
		| append-if $hex [ '-hex' ]
		| append-if $base64 [ '-base64' ]

	let openssl_output = ( ^openssl rand ...$params $quantity )

	if ( $hex or $base64 ) {
		return $openssl_output
	}

	$openssl_output | into binary
}

# Generate a random value using `/dev/urandom`
def "random urandom" [
	--hex (-h)
	--base64 (-b)
	--base32
	--base32hex
	quantity: int
] {
	if ( [ $hex, $base64, $base32, $base32hex ] | has-multiple-trues ) {
		error make -u {
			msg: "Please choose only one encoding",
		}
	}

	if ( $quantity <= 0 ) {
		error make {
			msg: "Please provide a valid quantity",
			label: {
					text: "Quantity here",
					span: (metadata $quantity).span
			}
		}
	}

	let urandom_output = ( ^head -c $quantity /dev/urandom | into binary )

	if ( $hex ) {
		return ( $urandom_output | encode hex )
	}

	if ( $base64 ) {
		return ( $urandom_output | encode base64 )
	}

	if ( $base32 ) {
		return ( $urandom_output | encode base32 )
	}

	if ( $base32hex ) {
		return ( $urandom_output | encode base32hex )
	}

	$urandom_output
}

# Select a random item from an input list
def "random choose" [
  --force-list-if-single (-f) # Force a list to be returned even if only item is chosen
  --ignore-empty (-i)         # If true, an empty list will be returned if the input is empty, if false, an error will be returned
  quantity: int = 1           # The quantity of items to select, if more than one item is chosen, a list will be returned
]: [ list -> list, list -> any ] {
    mut result = []

    if ($ignore_empty and ($in | is-empty)) {
      return $result
    } else if (not $ignore_empty and ($in | is-empty)) {
      error make -u { msg: "The input list is empty" }
    }

    let input = $in
    let max_index = (($input | length) - 1)

    for item in 1..$quantity {
      let random_index = (random int 0..$max_index)
      $result = $result | append ($input | get $random_index)
    }

    if (not $force_list_if_single and ($result | length) == 1) {
      return ($result | get 0)
    }

    $result
  }

# Generate random data using fake-rs
def --wrapped "random data" [
  --repeat (-r) : int = 1
  --locale (-l) : string = EN
  --raw (-r) # Print the output from the command as is
  ...$rest
] {
  if ( "help" in $rest) {
    ^fake help
    return
  } else if ( "--version" in $rest) or ( "-V" in $rest) {
    ^fake --version
    return
  }

  let command_output = (^fake
    --repeat=($repeat)
    --locale=($locale)
    ...$rest
  )

  if ($raw) or ("--help" in $rest) or ("-h" in $rest) {
    return $command_output
  }

  let results = ($command_output | lines | skip 1)

  if ($repeat == 1) {
    return ($results | get 0)
  }

  $results
}
