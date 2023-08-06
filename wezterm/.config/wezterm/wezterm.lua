local wezterm = require("wezterm")

local scheme_for_appearance = function(appearance)
	if appearance:find("Dark") then
		return "tokyonight_storm"
	else
		return "tokyonight_day"
	end
end

wezterm.on("window-config-reloaded", function(window)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

return {
	warn_about_missing_glyphs = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "NONE",
	check_for_updates = false,
	keys = {
		-- This will create a new split and run your default program inside it
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
	font_size = 8,
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
