local watcher = require("watcher")
local alert = require("alert")
local module = {}

module.modifiers = { "cmd" }

module.PERSONAL = "personal"
module.WORK = "work"
module.COMMON = "common"

module.space = module.PERSONAL

local function _launch(appName)
	local app = hs.application.find(appName)
	if app ~= nil and app:isFrontmost() then
		local GRID_SIZE = 2
		hs.grid.setGrid(GRID_SIZE .. "x" .. GRID_SIZE)
		hs.grid.setMargins({ 0, 0 })
		hs.window.animationDuration = 0
		local fullScreen = { x = 0, y = 0, w = GRID_SIZE, h = GRID_SIZE }
		local window = hs.window.focusedWindow()
		if window then
			local screen = window:screen()
			hs.grid.set(window, fullScreen, screen)
		end
	else
		hs.application.launchOrFocus(appName)
	end
end

function module.launch(appName)
	return function()
		_launch(appName)
	end
end

function module.launchLastOpened()
	if watcher.lastFocusedApp then
		hs.application.launchOrFocusByBundleID(watcher.lastFocusedApp)
	else
		hs.alert.show("No previous application")
	end
end

local function _bySpace(bySpaceActions)
	for key, val in pairs(bySpaceActions) do
		if key == module.space then
			val()
		end
	end
end

function module.bySpace(bySpaceActions)
	return function()
		_bySpace(bySpaceActions)
	end
end

function module.workOnly(action)
	return module.bySpace({ [module.WORK] = action })
end

function module.personalOnly(action)
	return module.bySpace({ [module.PERSONAL] = action })
end

function module.launchSplitFrame(leftAppName, rightAppName)
	return function()
		module.inSplitScreen = { leftAppName, rightAppName }
		local GRID_SIZE = 2
		local HALF_GRID_SIZE = GRID_SIZE / 2
		hs.grid.setGrid(GRID_SIZE .. "x" .. GRID_SIZE)
		hs.grid.setMargins({ 0, 0 })
		hs.window.animationDuration = 0
		local screenLeft = {
			x = 0,
			y = 0,
			w = HALF_GRID_SIZE,
			h = GRID_SIZE,
		}
		local screenRight = {
			x = HALF_GRID_SIZE,
			y = 0,
			w = HALF_GRID_SIZE,
			h = GRID_SIZE,
		}
		_launch(leftAppName)
		local window = hs.window.focusedWindow()
		if window then
			local screen = window:screen()
			hs.grid.set(window, screenLeft, screen)
		end
		_launch(rightAppName)
		window = hs.window.focusedWindow()
		if window then
			local screen = window:screen()
			hs.grid.set(window, screenRight, screen)
		end
	end
end

function module.type(key)
	return function()
		hs.eventtap.keyStrokes(key)
	end
end

function module.quitAllExcept(...)
	local appsToPreserve = table.pack(...)
	return function()
		hs.alert.show("quiting")
		local appsToPreserveMap = {}
		for _, v in ipairs(appsToPreserve) do
			if type(v) ~= "string" then
				hs.showError("app not type string, instead: " .. v .. ": " .. type(v))
				return
			else
				appsToPreserveMap[v] = true
			end
		end

		local killedApps = {}
		for _, v in ipairs(hs.window.allWindows()) do
			local app = v:application()
			if killedApps[app:name()] ~= true and appsToPreserveMap[app:name()] ~= true then
				hs.alert.show("killing: " .. app:name())
				app:kill()
			end
		end
	end
end

local function getBrowserWindow()
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local appName = win:application():name()
	local supportedBrowsers = {
		["Safari"] = true,
		["Google Chrome"] = true,
		["Brave Browser"] = true,
		["Arc"] = true,
	}
	if not supportedBrowsers[appName] then
		return
	end
	return appName
end

local function injectJs(appName, js)
	local appleScript
	if appName == "Safari" then
		appleScript = [[tell application "Safari"
			do JavaScript ]] .. js .. [[ in document 1
		        end tell]]
	elseif appName == "Google Chrome" or appName == "Brave Browser" or appName == "Arc" then
		appleScript = [[tell application "]]
			.. appName
			.. [["
			execute front window's active tab javascript "]]
			.. js
			.. [["
			end tell]]
	end

	-- Execute the AppleScript
	return hs.osascript.applescript(appleScript)
end

function module.goToRootDomain()
	local appName = getBrowserWindow()
	local js =
		"window.location.href = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '');"
	injectJs(appName, js)
end

function module.scrollHalfUp()
	injectJs("Zen Browser", "window.scrollBy(0, window.screen.height/2);")
end

function module.scrollHalfDown()
	injectJs("Zen Browser", "window.scrollBy(0, -window.screen.height/2);")
end

function module.lightsOn()
	local script = [[tell application "Shortcuts Events" to run the shortcut named "Lights On"]]
	hs.osascript.appleScript(script)
end

function module.reload()
	hs.reload()
	alert.show("Hammerspoon Config Reloaded")
end

function module.watchAndReload()
	if ConfigFileWatcher then
		ConfigFileWatcher:stop()
	end
	ConfigFileWatcher = hs.pathwatcher.new(hs.configdir, module.reload)
	ConfigFileWatcher:start()
end

module.middleFuncs = {}
function module.use(middleFuc)
	table.insert(module.middleFuncs, middleFuc)
end

function module.bind(key, action, opts)
	local modifiers = module.modifiers

	if not opts then
		return hs.hotkey.bind(modifiers, key, action)
	end

	if opts.modifiers and type(opts.modifiers) == "table" then
		modifiers = opts.modifiers
	end

	if opts.space and type(opts.space) == "string" then
		action = module.bySpace({ [opts.space] = action })
	end

	if opts.apps and type(opts.apps) == "table" then
		for i, app in ipairs(opts.apps) do
			local appsMap = {}
			if app and type(app) == "string" then
				appsMap[app] = true
			end
			action = function()
				if appsMap[hs.window.focusedWindow():application():name()] then
					action()
				end
			end
		end
	end

	return hs.hotkey.bind(modifiers, key, action)
end

function module.bindAll(keyBindings)
	for space, actions in pairs(keyBindings) do
		for _, binding in ipairs(actions) do
			local opts
			if space ~= module.COMMON then
				opts = { space = space }
			end
			if binding.opts then
				for k, v in pairs(binding.opts) do
					opts[k] = v
				end
			end

			if type(binding[2]) == "string" then
				module.bind(binding[1], module.launch(binding[2]), opts)
			else
				module.bind(binding[1], binding[2], opts)
			end
		end
	end
end

return module
