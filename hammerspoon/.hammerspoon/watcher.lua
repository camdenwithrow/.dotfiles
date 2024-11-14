local module = {}

AppWatcher = nil
KeyWatcher = nil

module.lastFocusedApp = ""
module.currentFocusedApp = ""
function module.startAppWatcher()
	if AppWatcher then
		AppWatcher:stop()
	end
	AppWatcher = hs.application.watcher.new(function(_, eventType, appObject)
		if eventType == hs.application.watcher.activated then
			module.lastFocusedApp = module.currentFocusedApp
			module.currentFocusedApp = appObject:bundleID()
		end
	end)
	AppWatcher:start()
end

module.lastKeyPressed = {}
module.currentKeyPressed = {}
module.currentKeyModifiers = {}
function module.startKeyWatcher()
	if KeyWatcher then
		KeyWatcher:stop()
	end
	KeyWatcher = hs.eventtap.new(
		{ hs.eventtap.event.types.keyDown },
		function(event) --watch the keyDown event, trigger the function every time there is a keydown
			module.lastKeyPressed = module.currentKeyPressed
			module.currentKeyPressed = { keyCode = event:getKeyCode(), time = hs.timer.secondsSinceEpoch() }
			module.currentKeyModifiers = event:getFlags()
		end
	)
	KeyWatcher:start()
end

return module
