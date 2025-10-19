# Load formats plugin for the `ini` file (the plugin path is specified for the VSCode linter to stop complaining)
plugin use --plugin-config $nu.plugin-path formats

# Select an AWS profile from the registered one on the .aws config
def --env "aws set-profile" [] {
  let profiles = (open ~/.aws/config | from ini | transpose | rename section options | where section =~ profile | update section { split row ' ' | get 1 })

  let selected = ($profiles | sk --format={get section} --preview={get options} | default ($profiles | get 0))

  $env.AWS_DEFAULT_PROFILE = $selected.section

  print $"Changed default AWS profile to: ($env.AWS_DEFAULT_PROFILE)"
}
