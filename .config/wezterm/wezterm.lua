local wezterm = require("wezterm")

local bar = require("bar")
local k = require("keymaps")
local workspaces = require("workspaces")

local config = wezterm.config_builder()

wezterm.on("gui-startup", function(_)
	workspaces.setup()
end)

-- Colours
config.color_scheme = "Catppuccin Mocha"
config.colors = {}

-- Font
config.font = wezterm.font({
	family = "JetBrainsMono Nerd Font",
})
config.font_size = 15.0
config.line_height = 1.1

-- Window
config.window_padding = {
	left = "0cell",
	right = "0cell",
	top = "0.5cell",
	bottom = "0cell",
}
config.window_close_confirmation = "AlwaysPrompt"
config.dpi = 144

-- Tabs
config.scrollback_lines = 3500

-- Tab bar
config.use_fancy_tab_bar = false
bar.setup(config)

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.key_tables = k.key_tables
config.keys = k.keys

return config
