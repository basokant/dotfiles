local wezterm = require("wezterm")

local function setup()
	wezterm.on("user-var-changed", function(window, pane, name, value)
		local overrides = window:get_config_overrides() or {}
		if name == "ZEN_MODE" then
			local incremental = value:find("+")
			local number_value = tonumber(value)
			if incremental ~= nil then
				while number_value > 0 do
					window:perform_action(wezterm.action.IncreaseFontSize, pane)
					number_value = number_value - 1
				end
			elseif number_value < 0 then
				window:perform_action(wezterm.action.ResetFontSize, pane)
				overrides.font_size = nil
			else
				overrides.font_size = number_value
			end
		end
		window:set_config_overrides(overrides)
	end)
end

return {
	setup = setup,
}
