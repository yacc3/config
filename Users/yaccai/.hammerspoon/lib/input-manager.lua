--INPUTMANAGER--
--TODO eventually will read a config file and set all inputs here instead of in each module
local InputManager = {
    CMD          = {"cmd"},
    CMD_ALT      = {"cmd", "alt"},
    CMD_ALT_CTRL = {"cmd", "alt", "ctrl"},
    CMD_ALT_SHIFT = {"cmd", "alt", "shift"}
}

hs.hotkey.bind(InputManager.CMD, "l", function()
	hs.caffeinate.lockScreen()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, 't', hs.toggleConsole)


return InputManager
