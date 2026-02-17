# Import utilities used in this file
source ./utilities.nu

# Get the machine's public IP by querying OpenDNS --------------------------
def getpubip [
  --useipv4 (-4)
  --useipv6 (-6)
] {
  if ($useipv4 and $useipv6) {
    error make -u {msg: "Please choose only one IP protocol version" }
  }

  if ($useipv4) {
    return (^dig -4 +short myip.opendns.com @resolver1.opendns.com)
  }

  if ($useipv6) {
    return (^dig -6 +short myip.opendns.com @resolver1.opendns.com)
  }

  ^dog -1 myip.opendns.com @resolver1.opendns.com
}

# ------------------------------------------------------------------------------------------------------------------------

# Run the provided command every specified duration
def monitor [
  --duration (-d): duration = 1sec
  ...args
] {
  let args = $args | into string
  let cmd = $args | str join ' '

  loop {
      let last_run = (date now)
      let till = $last_run + $duration

      let out = ^unbuffer nu --config $nu.config-path --env-config $nu.env-path --commands $cmd | complete

      if $out.exit_code == 0 {
        clear
        print $"Running every ($duration) on '(^hostname)': `($cmd)`"

        print $out.stdout

        print $"Last run: ($last_run)"
        sleep ($till - (date now))
      } else {
        print $out.stdout $out.stderr
        break
      }
  }
}

# Run the provided command every specified duration using the current instance of nushell
def monitor-internal [
  --duration (-d): duration = 1sec
  command: closure
] {

  loop {
    clear
    print $"Running every ($duration) on '(^hostname)': (explain $command | get cmd_name)"

    let last_run = (date now)
    let till = $last_run + $duration

    do $command | print

    print ""
    print $"Last run: ($last_run)"
    sleep ($till - (date now))
  }
}

# --------------------------------------------------------------------------------

# Download m3u8 playlist using FFMPEG
def "ffmpeg download m3u8" [
  input_url: string
  --filename (-f): string
] {
  mut filename = $filename
  if ($filename | is-empty) {
    $filename = ( $input_url | split column '/' | get column7 | get 0 )
  }

  if ( $filename | path exists ) {
    error make -u { msg: $"($filename) already exists" }
  }

  ^ffmpeg -y -loglevel verbose -i $input_url -c copy $filename
}

# --------------------------------------------------------------------------------

def "cpu powerdraw" [
  sample_duration: duration
  device: string
] {
  let device = $"/sys/class/powercap/intel-rapl:($device)/energy_uj"
  # let watthour_per_microjoules = 2.77778e-10
  # let micro_per_joule = 1e-6

  let last_run = (date now)
  let till = $last_run + $sample_duration

  let joules_start = (^sudo cat $device | into int)
  sleep ($till - (date now))
  let joules_end = (^sudo cat $device | into int)

  let delta: int = ($joules_end - $joules_start)

  $delta / (($sample_duration | into int) / (1sec | into int)) / 1000000
}


# --------------------------------------------------------------------------------

# Hashes an input and then prints the value and the hash of it, useful for generating secrets
#
# Obs.: It just actually runs the first closure and pass it to the second, printing the output of both, so use carefully
# A method for lazy people
def "hash print" [
  input: closure
  hash: closure
] {
  let input_output = do $input
  let hashed = $input_output | do $hash

  print $"Input: ($input_output)"
  print $"Hashed: ($hashed)"
}

# --------------------------------------------------------------------------------

# Execute some command inside a bash shell for full POSIX compliance
def "posix run" [
  input?: string
] {
  let _in = $in
  let input = ($input | default $_in )

  ^bash -c $input
}
