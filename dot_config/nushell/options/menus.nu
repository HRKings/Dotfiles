$env.config.menus = [
  # Configuration for default nushell menus
  # Note the lack of source parameter
  {
    name: completion_menu
    only_buffer_difference: false
    marker: "| "
    type: {
      layout: columnar
      columns: 1
    }
    style: {
      text: $env.catppuccin_colors.text
      selected_text: { attr: r }
      description_text: $env.catppuccin_colors.overlay2
      match_text: { attr: u }
      selected_match_text: { attr: ur }
    }
  }
  {
    name: ide_completion_menu
    only_buffer_difference: false
    marker: "| "
    type: {
      layout: ide
      min_completion_width: 0,
      max_completion_width: 100,
      max_completion_height: 20, # will be limited by the available lines in the terminal
      padding: 0,
      border: true,
      cursor_offset: 0,
      description_mode: "prefer_right"
      min_description_width: 0
      max_description_width: 120
      max_description_height: 50
      description_offset: 1
      # If true, the cursor pos will be corrected, so the suggestions match up with the typed text
      #
      # C:\> str
      #      str join
      #      str trim
      #      str split
      correct_cursor_pos: false
    }
    style: {
      text: $env.config.color_config.foreground
      selected_text: { attr: r }
      description_text: $env.config.color_config.hints
      match_text: { attr: u }
      selected_match_text: { attr: ur }
    }
  }
  {
    name: help_menu
    only_buffer_difference: true
    marker: "? "
    type: {
      layout: description
      columns: 4
      col_width: 20     # Optional value. If missing all the screen width is used to calculate column width
      col_padding: 2
      selection_rows: 4
      description_rows: 10
    }
    style: {
      text: green
      selected_text: green_reverse
      description_text: yellow
    }
  }
]
