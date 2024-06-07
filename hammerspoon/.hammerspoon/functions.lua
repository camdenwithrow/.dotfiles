local function openAndFocus(app)
	hs.application.launchOrFocus(app)
	if hs.application.get(app) then
		hs.application.get(app):activate()
	end
end

function Launch(app)
	return function()
		openAndFocus(app)
	end
end

function SwitchSpace()
	if Space == PERSONAL then
		Space = WORK
	else
		Space = PERSONAL
	end
	hs.alert.show("Switching to " .. Space)
end

function BySpace(bySpaceFuncs)
	return function()
		for key, val in pairs(bySpaceFuncs) do
			if key == Space then
				val()
			end
		end
	end
end

function KeyStroke(key)
	return function()
		hs.eventtap.keyStrokes(key)
	end
end

local lastFocusedApp = nil
local currentFocusedApp = nil
function StartAppWatcher()
	if AppWatcher then
		AppWatcher:stop()
	end

	AppWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
		if eventType == hs.application.watcher.activated then
			lastFocusedApp = currentFocusedApp
			currentFocusedApp = appObject
		end
	end)

	AppWatcher:start()
end

function LaunchLastOpened()
	if lastFocusedApp then
		openAndFocus(lastFocusedApp:name())
	else
		hs.alert.show("No previous application")
	end
end

function LaunchSplitFrame(leftAppName, rightAppName)
	return function()
		local function setWindow(window, direction)
			hs.window.animationDuration = 0
			local f = window:frame()
			local screen = window:screen()
			local max = screen:frame()

			if direction == "left" then
				f.x = max.x
				f.y = max.y
				f.w = max.w / 2
				f.h = max.h
				window:setFrame(f)
			elseif direction == "right" then
				f.x = max.x + (max.w / 2)
				f.y = max.y
				f.w = max.w / 2
				f.h = max.h
				window:setFrame(f)
			end
		end

		hs.application.launchOrFocus(leftAppName)
		local leftApp = hs.appfinder.appFromName(leftAppName)
		if leftApp then
			local leftAppWindow = leftApp:mainWindow()
			if leftAppWindow then
				setWindow(leftAppWindow, "left")
			else
				hs.alert.show(leftAppName .. " window not found")
			end
		end

		hs.application.launchOrFocus(rightAppName)
		local rightApp = hs.appfinder.appFromName(rightAppName)
		if rightApp then
			local rightAppWindow = rightApp:mainWindow()
			if rightAppWindow then
				setWindow(rightAppWindow, "right")
			else
				hs.alert.show(rightAppName .. " window not found")
			end
		end
	end
end

-- BROWSER JS INJECTION
-- Playback speed JS
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
	local applescriptCode
	if appName == "Safari" then
		applescriptCode = [[tell application "Safari"
			do JavaScript ]] .. js .. [[ in document 1
		        end tell]]
	elseif appName == "Google Chrome" or appName == "Brave Browser" or appName == "Arc" then
		applescriptCode = [[tell application "]]
			.. appName
			.. [["
			execute front window's active tab javascript "]]
			.. js
			.. [["
			end tell]]
	end

	-- Execute the AppleScript
	return hs.osascript.applescript(applescriptCode)
end

function CyclePlaybackRateInBrowser()
	local appName = getBrowserWindow()
	-- Define the JavaScript to be injected
	local js = [[document.querySelector('video').playbackRate = 
				document.querySelector('video').playbackRate === 1 ? 2 : 
				document.querySelector('video').playbackRate === 2 ? 1.5 : 1;
			]]
	-- AppleScript to execute JavaScript in different browsers
	local _, result = injectJs(appName, js)
	hs.alert(result)
end

function GoToRootDomainInBrowser()
	local appName = getBrowserWindow()
	local js =
		"window.location.href = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '');"
	local _, result = injectJs(appName, js)
	-- print(result)
end
