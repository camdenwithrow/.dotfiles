dofile(hs.configdir .. "/functions.lua")

CMD_CTRL_ALT = { "cmd", "ctrl", "alt" }
CMD_CTRL = { "cmd", "ctrl" }
CMD_ALT = { "cmd", "alt" }

PERSONAL = "personal"
WORK = "work"

Space = PERSONAL

StartAppWatcher()

local hotkeys = {
	{ CMD_CTRL_ALT, "8", SwitchSpace },
	{ CMD_CTRL, "W", Launch("Arc") },
	{ CMD_CTRL, "E", Launch("iTerm") },
	{ CMD_CTRL, "M", Launch("Spotify") },
	{ CMD_CTRL, "C", Launch("Google Chrome") },
	{ CMD_CTRL, "N", Launch("Notion") },
	{ CMD_CTRL, "O", BySpace({ personal = Launch("Mail"), work = Launch("Microsoft Outlook") }) },
	{ CMD_CTRL, "I", BySpace({ work = "Visual Studio Code" }) },
	{ CMD_CTRL, "Tab", LaunchLastOpened },
	{ CMD_CTRL, "S", LaunchSplitFrame("iTerm", "Arc") },
	{ CMD_CTRL, "Y", CyclePlaybackRateInBrowser },
	{ CMD_CTRL, "R", GoToRootDomainInBrowser },
	{ CMD_CTRL, "U", BySpace({ work = KeyStroke("👍") }) },
}

local reservedKeys = {}
for _, value in ipairs(hotkeys) do
	local modifiers, hotkey, func = value[1], value[2], value[3]
	if reservedKeys[hotkey] then
		error("\n\n----------ERROR: hotkey already in use----------\n")
	end
	reservedKeys[hotkey] = true

	hs.hotkey.bind(modifiers, hotkey, func)
end

-- Auto reload config
function ReloadConfig(files)
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", ReloadConfig):start()
hs.alert.show("Config loaded")
