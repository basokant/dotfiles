local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

local function setup_default()
	print("setting up default workspace")

	local name = "default"
	local dir = wezterm.home_dir .. "/Documents/workspace"

	local editor_tab, pane, window = mux.spawn_window({
		workspace = name,
		cwd = dir,
	})
	editor_tab:set_title("editor")
	pane:send_text("sp\n")

	local terminal_tab, _, _ = window:spawn_tab({
		cwd = dir,
	})
	terminal_tab:set_title("terminal")

	window:gui_window():maximize()

	return name
end

local function setup_dotfiles()
	print("setting up dotfiles workspace")

	local name = "dotfiles"
	local dir = wezterm.home_dir .. "/dotfiles"

	local editor_tab, pane, window = mux.spawn_window({
		workspace = name,
		cwd = dir,
	})
	editor_tab:set_title("editor")
	pane:send_text("nvim\n")

	local terminal_tab, _, _ = window:spawn_tab({
		cwd = dir,
	})
	terminal_tab:set_title("terminal")

	return name
end

M.setup = function()
	-- setup all workspaces
	local default = setup_default()
	local _ = setup_dotfiles()

	mux.set_active_workspace(default)
end

return M
