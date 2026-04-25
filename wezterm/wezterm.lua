local wezterm = require 'wezterm'

return {
  adjust_window_size_when_changing_font_size = false,
  color_scheme = 'Catppuccin Mocha',
  color_schemes = {
    ['Catppuccin Mocha'] = {
      foreground = '#cdd6f4',
      background = '#1e1e2e',
      cursor_border = '#cba6f7',
      cursor_bg = '#cba6f7',
      cursor_fg = '#1e1e2e',
      selection_bg = '#585b70',
      selection_fg = '#cdd6f4',
      ansi = {
        '#45475a', -- black
        '#f38ba8', -- red
        '#a6e3a1', -- green
        '#f9e2af', -- yellow
        '#89b4fa', -- blue
        '#cba6f7', -- mauve
        '#94e2d5', -- teal
        '#bac2de', -- white
      },
      brights = {
        '#585b70', -- bright black
        '#f38ba8', -- bright red
        '#a6e3a1', -- bright green
        '#f9e2af', -- bright yellow
        '#89b4fa', -- bright blue
        '#cba6f7', -- bright mauve
        '#94e2d5', -- bright teal
        '#cdd6f4', -- bright white
      },
    },
  },
  enable_tab_bar = false,
  font_size = 16.0,
  font = wezterm.font('JetBrains Mono Nerd Font'),
  window_background_opacity = 1.0,
  window_decorations = 'RESIZE',
  default_prog = { '/home/valdemaster/.local/bin/nu' },
  keys = {
    {
      key = 'q',
      mods = 'CTRL',
      action = wezterm.action.ToggleFullScreen,
    },
    {
      key = '\'',
      mods = 'CTRL',
      action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
    },
  },
  mouse_bindings = {
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
  },
}
