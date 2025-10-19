$env.config.show_banner = false

$env.config.datetime_format = {
  normal: '%Y-%m-%d %H:%M:%S'
  table: '%Y-%m-%d %H:%M:%S'
}

$env.config.explore.try = {
  reactive: true
}

$env.config.history = {
  max_size: 2_147_483_647
  sync_on_enter: true
  file_format: "sqlite"
  isolation: false
}

$env.config.completions = {
  case_sensitive: false
  quick: true
  partial: true
  algorithm: "fuzzy"
  sort: "smart"
  use_ls_colors: true
}

$env.config.cursor_shape = {
  vi_insert: line
  vi_normal: block
}

$env.config.edit_mode = "vi"

$env.config.use_kitty_protocol = true
$env.config.highlight_resolved_externals = true

$env.config.hooks = {
  # Run before the prompt is shown
  pre_prompt: [{||
    # Save the prompt status
    let last_command_duration = $env.CMD_DURATION_MS
    let last_command_exit = $env.LAST_EXIT_CODE

    # Build the initial terminal title
    if (not ('TERMINAL_TITLE' in $env)) {
      # Get current context
      let current_dir = ( if ( $"(pwd)" == $env.HOME ) { "~" } else { $"󰇘/(pwd | path parse | get stem)" } )
      let current_branch = ( git branch --show-current | complete | get stdout )

      # Build the terminal title
      let final_title = ( [ $current_dir, $current_branch ] | where not ($it | str trim | is-empty) | str join ' @ ' )
      $env.TERMINAL_TITLE = $"(ansi title)($final_title)(ansi st)"
    }

    # Set the terminal title
    print --no-newline ( $env.TERMINAL_TITLE )

    # Restore the correct prompt status
    $env.CMD_DURATION_MS = $last_command_duration
    $env.LAST_EXIT_CODE = $last_command_exit
  }]
  # Run before the repl input is run
  pre_execution: [{||
    const max_command_length = 32

    # Get the current command
    let current_command = (commandline)
    let command_to_use = if ($current_command | str starts-with $env.ATUIN_KEYBINDING_TOKEN) { (^atuin history last --cmd-only) } else { $current_command }
    let truncated_symbol = if (( $command_to_use | str length ) >= $max_command_length) { '󰩫' } else { '' }
    let command_string = $"`($command_to_use | str substring 0..32)($truncated_symbol)` "

    # Get current context
    let current_dir = ( if ( $"(pwd)" == $env.HOME ) { "~" } else { $"󰇘/(pwd | path parse | get stem)" } )
    let current_branch = ( git branch --show-current | complete | get stdout )

    # Build and set the terminal title
    let final_title = ( [ $command_string, $current_dir, $current_branch ] | where not ($it | str trim | is-empty) | str join ' · ' )
    $env.TERMINAL_TITLE = $"(ansi title)($final_title)(ansi st)"
  }]
  env_change: {
    PWD: [{|before, after| null }] # run if the PWD environment is different since the last repl input
  }
  # Run to display the output of a pipeline
  display_output: "if (term size).columns >= 100 { table -e } else { table }"
  # Return an error message when a command is not found
  command_not_found: { null }
}

$env.config.table.missing_value_symbol = "-- ∅ --"
