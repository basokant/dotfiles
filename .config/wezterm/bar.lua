local wezterm = require("wezterm")
local command_icons = require("utils/command-icons")

local M = {}

local tab_colors = {
	"#f38ba8",
	"#fab387",
	"#f9e2af",
	"#a6e3a1",
	"#89dceb",
	"#b4befe",
}

local basename = function(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function apply_right_status()
	wezterm.on("update-status", function(window, pane)
		local workspace = window:active_workspace()

		local cwd = pane:get_current_working_dir()
		cwd = cwd and basename(cwd.file_path) or ""

		local cmd = pane:get_foreground_process_name()
		cmd = cmd and basename(cmd) or ""
		local cmd_icon = command_icons[cmd] ~= nil and command_icons[cmd] or wezterm.nerdfonts.dev_terminal

		window:set_right_status(wezterm.format({
			{ Foreground = { Color = "#f38ba8" } },
			{ Text = wezterm.nerdfonts.cod_terminal_tmux .. " " .. workspace },
			"ResetAttributes",
			{ Text = " | " },
			{ Foreground = { Color = "#94e2d5" } },
			{ Text = wezterm.nerdfonts.md_folder .. " " .. cwd },
			"ResetAttributes",
			{ Text = " | " },
			{ Foreground = { Color = "#89b4fa" } },
			{ Text = cmd_icon .. " " .. cmd },
			"ResetAttributes",
			{ Text = "  " },
		}))
	end)
end

local function apply_left_status()
	wezterm.on("update-status", function(window, _)
		local leader = " "
		if window:leader_is_active() then
			leader = " "
		end
		window:set_left_status(wezterm.format({
			{ Foreground = { Color = "#b7bdf8" } },
			{ Text = " " .. leader .. " " },
		}))
	end)
end

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return tab_info.tab_index + 1 .. "." .. title
	end
	return tab_info.tab_index + 1 .. "." .. tab_info.active_pane.title
end

local function apply_tab_format()
	wezterm.on("format-tab-title", function(tab, _, _, conf, _, max_width)
		local colours = conf.resolved_palette.tab_bar

		local i = tab.tab_index % 6
		local active_bg = tab_colors[i + 1]
		local active_fg = colours.background
		local bg = colours.inactive_tab.bg_color
		local fg = colours.inactive_tab.fg_color

		local title = tab_title(tab)
		title = wezterm.truncate_right(title, max_width - 2)

		if tab.is_active then
			bg = active_bg
			fg = active_fg
		end

		return {
			{ Background = { Color = bg } },
			{ Foreground = { Color = fg } },
			{ Text = " " .. title .. " " },
		}
	end)
end

M.setup = function(config)
	-- Tab bar colour changes
	config.colors.tab_bar = {
		background = "#181825",
		inactive_tab = {
			fg_color = "#a6adc8",
			bg_color = "#181825",
		},
		new_tab = {
			bg_color = "#1e1e2e",
			fg_color = "#b7bdf8",
		},
		new_tab_hover = {
			bg_color = "#b7bdf8",
			fg_color = "#1e1e2e",
		},
	}

	config.tab_bar_at_bottom = true

	apply_left_status()
	apply_right_status()
	apply_tab_format()
end

return M
