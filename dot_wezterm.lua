-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font_with_fallback {
  'Iosevka Nerd Font',
  'FiraCode Nerd Font',
}
config.font_size = 16.0
config.window_background_opacity = 0.95

config.initial_cols = 140
config.initial_rows = 30

config.enable_tab_bar = true

config.default_prog = { '/usr/bin/nu' }

-- Keybinds
-- config.disable_default_key_bindings = true
config.keys = {
  { key = 'L', mods = 'CTRL|ALT|SHIFT', action = wezterm.action.ShowDebugOverlay },
}
-- and finally, return the configuration to wezterm
return config
