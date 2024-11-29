local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

config.window_padding = {
	top = 30,
	bottom = 0,
	left = 15,
	right = 15,
}

config.font = wezterm.font("JetBrains Mono")
config.font_size = 16
config.harfbuzz_features = { "calt=0" }

config.color_scheme = "Github Dark"
config.colors = {
	background = "21272e",
	cursor_bg = "afb9c5",
	cursor_border = "afb9c5",
}

return config
