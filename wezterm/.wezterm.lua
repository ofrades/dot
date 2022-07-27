local wezterm = require("wezterm")

local config = {
  enable_tab_bar = false,
  color_scheme = "nord",
  enable_wayland = false,
  default_cursor_style = "BlinkingBlock",
  check_for_updates = false,
  colors = {
    background = "#2b2d35",
  },
  window_padding = {
    left = 2,
    right = 0,
    top = 2,
    bottom = 0,
  },
  font_size = 10.0,
  font = wezterm.font("FiraCode Nerd Font"),
  leader = { key = "a", mods = "CTRL" },
  keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
    { key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    {
      key = "\\",
      mods = "LEADER",
      action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
    { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
    { key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
    { key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
    { key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
    { key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
    { key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
    { key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
    { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

    { key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
    { key = "v", mods = "SHIFT|CTRL", action = "Paste" },
    { key = "c", mods = "SHIFT|CTRL", action = "Copy" },
  },
}

return config
