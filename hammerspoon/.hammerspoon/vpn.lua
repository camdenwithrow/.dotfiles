local alert = require("alert")

local module = {}

function module.status()
	local script = [[set _connections to ""
		tell application "Viscosity"
			set _count to count of connections
			repeat with _conn from 1 to _count by 1
				set _name to name of connection _conn
				set _state to state of connection _conn
				if _state is "Connected" then
					set _stateIcon to "✅"
				else if _state is "Disconnected" then
					set _stateIcon to "❌"
				else if _state is "Connecting" then
					set _stateIcon to "⏳"
				else if _state is "Authenticating" then
					set _stateIcon to "🔒"
				end if
				if _conn is 1 then
					set _connections to _connections & _name & ": " & _stateIcon & "\n"
				else
					set _connections to _connections & _name & ": " & _stateIcon
				end if
			end repeat
			return _connections
		end tell]]
	local _, val = hs.osascript.applescript(script)
	alert.show(val)
end

function module.connectAll()
	local script = [[tell application "Viscosity" to connectAll]]
	hs.osascript.applescript(script)
end

function module.disconnectAll()
	local script = [[tell application "Viscosity" to disconnectAll]]
	hs.osascript.applescript(script)
end

-- function module.toggleConnectDev()
-- 	local script = [[tell application "Viscosity" to connect "dev"]]
-- 	hs.osascript.applescript(script)
-- end
--
-- function module.toggleConnectTest() end

return module
