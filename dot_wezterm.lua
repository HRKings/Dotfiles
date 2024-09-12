-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font_with_fallback {
  'Iosevka Nerd Font Mono',
  'FiraCode Nerd Font Mono',
}
config.font_size = 16.0
config.window_background_opacity = 0.75

config.initial_cols = 140
config.initial_rows = 30

config.enable_tab_bar = false

-- and finally, return the configuration to wezterm
return config
