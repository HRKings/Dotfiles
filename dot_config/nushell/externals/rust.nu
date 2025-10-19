def --wrapped "rustup toolchain list" [...rest] {
  if ( $rest | is-not-empty ) {
    ^rustup toolchain list --help
    return
  }

  ^rustup toolchain list | lines | each { parse --regex '^(?<name>.+?)-(?<arch>.+?)-(?<platform>.+?)(?:\s(?<info>.+))?$' } | flatten
}

def "nucomplete rustup toolchains" [] {
  ^rustup toolchain list | get name
}

def --wrapped "rustup component list" [
  --installed # List only installed components
  --toolchain: string@"nucomplete rustup toolchains" # Toolchain name, such as 'stable', 'nightly', or '1.8.0'. For more information see `rustup help toolchain`
  ...rest
] {
  if ( "-h" in $rest) or ( "--help" in $rest) {
    ^rustup component list --help
    return
  }

  mut args = $rest | default []

  if ( $installed ) {
    $args = ( $args | append "--installed" )
  }

  if ( $toolchain | is-not-empty ) {
    $args = ( $args | append "--toolchain" | append $toolchain )
  }

  ^rustup component list ...$args | lines | each { parse --regex '(?<name>.+?)-(?<arch>.+?)-(?<platform>.+)' } | flatten
}
