local a = require("actions")
local watcher = require("watcher")
local vpn = require("vpn")
local apps = require("apps")

CMD_CTRL = { "cmd", "ctrl" }
a.modifiers = CMD_CTRL
a.space = a.PERSONAL

hs.application.enableSpotlightForNameSearches(true)

watcher.startAppWatcher()
-- watcher.startKeyWatcher()

local keyBindings = {
	[a.COMMON] = {
		{ "W", apps.ARC },
		{ "E", apps.ITERM },
		{ "M", apps.SPOTIFY },
		{ "C", apps.CHROME },
		{ "N", apps.NOTES },
		{ "I", apps.NOTION },
		{ "Tab", a.launchLastOpened },
		{ "S", a.launchSplitFrame(apps.ITERM, apps.ARC) },
		{ "R", a.reload, { modifiers = { "cmd", "ctrl", "alt", "shift" } } },
		{ "U", a.scrollHalfUp, { modifiers = { "ctrl" }, apps = { apps.ARC, apps.CHROME } } },
	},
	[a.PERSONAL] = {
		{ "J", apps.LINEAR },
		{ "T", apps.TICKTICK },
		{ "O", apps.MAIL },
		{ "R", a.goToRootDomain },
		{ "U", a.type("🙏") },
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
