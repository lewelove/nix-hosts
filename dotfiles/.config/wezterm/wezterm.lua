local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('CommitMono Nerd Font', { weight = 400 })
config.font_size = 10

config.check_for_updates = false

config.freetype_interpreter_version = 40

config.scrollback_lines = 3500

config.window_background_opacity = 0.92

config.freetype_load_target = 'Light'

enable_wayland = false

config.window_padding = {
  left = 16,
  right = 16,
  top = 16,
  bottom = 0,
}

config.colors = {
  foreground = '#CCCCCC',
  background = '#111111',

  cursor_bg = '#CCCCCC',
  cursor_fg = '#111111',
  cursor_border = '#CCCCCC',

  ansi = {
    '#333333',
    '#EA4335',
    '#34A853',
    '#FBBC04',
    '#4285F4',
    '#A142F4',
    '#4285F4',
    '#CCCCCC',
  },
  brights = {
    '#555555',
    '#EA4335',
    '#34A853',
    '#FBBC04',
    '#4285F4',
    '#A142F4',
    '#4285F4',
    '#CCCCCC',
  },
}

config.front_end = "WebGpu"

return config
