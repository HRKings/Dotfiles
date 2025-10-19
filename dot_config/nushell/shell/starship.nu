# this file is both a valid
# - overlay which can be loaded with `overlay use starship.nu`
# - module which can be used with `use starship.nu`
# - script which can be used with `source starship.nu`
export-env { $env.STARSHIP_SHELL = "nu"; load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        ^/usr/bin/starship prompt --continuation
    )

    # Initialize the default vi mode
    STARSHIP_KEYMAP: 'insert'

    PROMPT_COMMAND: {||
        (
            ^/usr/bin/starship prompt
                --cmd-duration ( if ($env.CMD_DURATION_MS == '0823') { '0' } else { $env.CMD_DURATION_MS } ) # Override initial duration. Source: https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687
                $"--status=($env.LAST_EXIT_CODE)"
                --jobs=(job list | length)
                --terminal-width (term size).columns
                --keymap=($env.STARSHIP_KEYMAP)
        )
    }

    config: ($env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
        (
            ^/usr/bin/starship prompt
                --right
                --cmd-duration ( if ($env.CMD_DURATION_MS == '0823') { '0' } else { $env.CMD_DURATION_MS } ) # Override initial duration. Source: https://github.com/nushell/nushell/discussions/6402#discussioncomment-3466687
                $"--status=($env.LAST_EXIT_CODE)"
                --jobs=(job list | length)
                --terminal-width (term size).columns
        )
    }
}}
