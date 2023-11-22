local wezterm = require("wezterm")

local function font(opts)
	return wezterm.font_with_fallback({
		opts,
		"Symbols Nerd Font Mono",
	})
end

return {
	color_scheme = "Gruvbox dark, hard (base16)",
	font_size = 10,
	font = font("FiraCode Nerd Font"),
	font_rules = {
		{
			italic = true,
			intensity = "Normal",
			font = font({
				family = "Maple Mono",
				style = "Italic",
			}),
		},
		{
			italic = true,
			intensity = "Half",
			font = font({
				family = "Maple Mono",
				weight = "DemiBold",
				style = "Italic",
			}),
		},
		{
			italic = true,
			intensity = "Bold",
			font = font({
				family = "Maple Mono",
				weight = "Bold",
				style = "Italic",
			}),
		},
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	warn_about_missing_glyphs = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "NONE",
	default_prog = { "/home/linuxbrew/.linuxbrew/bin/fish", "-l" },
	check_for_updates = false,
	keys = {
		{
			key = "_",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "|",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "w",
			mods = "CTRL|SHIFT",
			action = wezterm.action.CloseCurrentPane({ confirm = false }),
		},
		{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "M", mods = "CTRL|SHIFT", action = wezterm.action.TogglePaneZoomState },
		{
			key = "h",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "CTRL|SHIFT",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		-- Show the launcher in fuzzy selection mode and have it list all workspaces
		-- and allow activating one.
		{
			key = "p",
			mods = "ALT",
			action = wezterm.action.ShowLauncherArgs({
				flags = "FUZZY|LAUNCH_MENU_ITEMS|WORKSPACES",
			}),
		},
	},
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	scrollback_lines = 10000,
	hyperlink_rules = {
		-- Linkify things that look like URLs and the host has a TLD name.
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},

		-- linkify email addresses
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
			format = "mailto:$0",
		},

		-- file:// URI
		-- Compiled-in default. Used if you don't specify any hyperlink_rules.
		{
			regex = [[\bfile://\S*\b]],
			format = "$0",
		},

		-- Linkify things that look like URLs with numeric addresses as hosts.
		-- E.g. http://127.0.0.1:8000 for a local development server,
		-- or http://192.168.1.1 for the web interface of many routers.
		{
			regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
			format = "$0",
		},
	},
}
