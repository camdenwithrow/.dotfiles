local a = require("actions")
local apps = require("apps")
local watcher = require("watcher")
local vpn = require("vpn")

a.modifiers = { "cmd", "ctrl" }
a.space = a.PERSONAL
local defaultBrowser = apps.ZEN
local defaultTerminal = apps.WEZTERM

hs.application.enableSpotlightForNameSearches(true)

watcher.startAppWatcher()
-- watcher.startKeyWatcher()

local keyBindings = {
	[a.COMMON] = {
		{ "W", defaultBrowser },
		{ "E", defaultTerminal },
		{ "M", apps.SPOTIFY },
		{ "C", apps.CHROME },
		{ "N", apps.NOTES },
		{ "I", apps.NOTION },
		{ "Tab", a.launchLastOpened },
		{ "S", a.launchSplitFrame(defaultTerminal, defaultBrowser) },
	},
	[a.PERSONAL] = {
		-- { "J", apps.LINEAR },
		{ "T", apps.TICKTICK },
		{ "O", apps.MAIL },
		{ "R", a.goToRootDomain },
	},
	[a.WORK] = {
		{ "Z", apps.ZOOM },
		{ "O", apps.OUTLOOK },
		{ "V", vpn.status },
		{ "U", a.type("👍") },
	},
}

a.bindAll(keyBindings)
a.watchAndReload()
