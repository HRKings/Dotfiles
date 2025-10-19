$env.config.keybindings = [
  {
    name: debug_repaint
    modifier: control_alt
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: executehostcommand
        cmd: "$env.REDRAW = true"
      }
      { send: repaint }
    ]
  }
  # {
  #   name: redraw_on_space_press
  #   modifier: none
  #   keycode: space
  #   mode: [emacs, vi_normal, vi_insert]
  #   event: [
  #     {
  #       edit: insertchar
  #       value: ' '
  #     }
  #     {
  #       send: executehostcommand
  #       cmd: $redraw_command
  #     }
  #     { send: repaint }
  #   ]
  # }
  # {
  #   name: redraw_on_backspace_press
  #   modifier: none
  #   keycode: backspace
  #   mode: [emacs, vi_normal, vi_insert]
  #   event: [
  #     {
  #       edit: backspace
  #     }
  #     {
  #       send: executehostcommand
  #       cmd: $redraw_command
  #     }
  #     { send: repaint }
  #   ]
  # }
  # {
  #   name: redraw_on_ctrl_backspace_press
  #   modifier: control
  #   keycode: char_w
  #   mode: [emacs, vi_normal, vi_insert]
  #   event: [
  #     {
  #       edit: backspaceword
  #     }
  #     {
  #       send: executehostcommand
  #       cmd: $redraw_command
  #     }
  #     { send: repaint }
  #   ]
  # }
  # {
  #   name: change_vim_mode_insert
  #   modifier: control
  #   keycode: char_b
  #   mode: [ vi_insert ]
  #   event: [
  #     {
  #       send: executehostcommand
  #       cmd: "$env.STARSHIP_KEYMAP = 'vicmd'"
  #     }
  #     { send: repaint }
  #     { send: ViChangeMode mode: normal }
  #   ]
  # }
  {
    name: skim_external_commands
    modifier: control
    keycode: char_s
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: executehostcommand
      cmd: $"($env.atuin_keybinding_token)
          commandline edit --replace \(
            $env.EXECUTABLES_IN_PATH | sk --height='~' --layout=reverse | to text
          \)"
    }
  }
  {
    name: skim_dir
    modifier: control
    keycode: char_f
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: executehostcommand
      cmd: $"($env.atuin_keybinding_token)
        commandline edit --insert \(
          ls **/*
          | where type == dir
          | sk --layout=reverse --height='~' --format={get name}
          --preview={eza -la --icons --group-directories-first --color=always $in.name}
          | default {name:''}
          | get name
        \)"
    }
  }
  {
    name: navigate_with_yazi
    modifier: control_shift
    keycode: char_f
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: executehostcommand
      cmd: $"($env.atuin_keybinding_token)
        ycd"
    }
  }
  {
    name: completion_menu
    modifier: control
    keycode: space
    mode: [emacs vi_normal vi_insert]
    event: {
      until: [
        { send: menu name: completion_menu }
        { send: menunext }
        { edit: complete }
      ]
    }
  }
  {
    name: completion_previous_menu
    modifier: shift
    keycode: backtab
    mode: [emacs, vi_normal, vi_insert]
    event: { send: menuprevious }
  }
  {
    name: ide_completion_menu
    modifier: none
    keycode: tab
    mode: [emacs vi_normal vi_insert]
    event: {
      until: [
        { send: menu name: ide_completion_menu }
        { send: menunext }
        { edit: complete }
      ]
    }
  }
]

# Map various keys that trigger the change to insert mode
# for key in [ char_i, char_a, char_r, char_c ] {
#   $env.config.keybindings ++= [
#     {
#       name: $"change_vim_mode_normal_($key)"
#       modifier: none
#       keycode: $key
#       mode: [ vi_normal ]
#       event: [
#         {
#           send: executehostcommand
#           cmd: "$env.STARSHIP_KEYMAP = 'viins'"
#         }
#         { send: repaint }
#         { send: ViChangeMode mode: insert }
#       ]
#     }
#   ]
# }
