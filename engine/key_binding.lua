keyBinding = {}
keyBinding.commandToKey = {}
keyBinding.assignedKeys = {}
keyBinding.commandNameCallback = {}
keyBinding.assignableKeys = {}
keyBinding.commandNames = {}
keyBinding.commandNameOrder = {}
keyBinding.keyNames = {}
keyBinding.LATIN_ALPHABET = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9"
}
keyBinding.CONTROL_KEYS = {
	"lalt",
	"ralt",
	"lctrl",
	"rctrl",
	"lshift",
	"rshift"
}
keyBinding.ARROW_KEYS = {
	LEFT = "left",
	RIGHT = "right"
}
keyBinding.EVENTS = {
	KEY_UNBOUND = "key_unbound",
	KEY_BOUND = "key_bound"
}

local bitser = require("engine/bitser")

function keyBinding:isShiftDown()
	return love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
end

function keyBinding:assignKey(key, commandName)
	self.assignedKeys[key] = commandName
	self.commandToKey[commandName] = key
	
	events:fire(keyBinding.EVENTS.KEY_BOUND, key, commandName)
end

function keyBinding:attemptBind(key, commandName)
	if not self.assignableKeys[key] then
		return false
	end
	
	local curCmdKey = self.commandToKey[commandName]
	
	if curCmdKey then
		self:clearKey(curCmdKey)
	end
	
	local prevBind = self.assignedKeys[key]
	
	if prevBind and prevBind ~= commandName then
		self:clearKey(key)
	end
	
	self:assignKey(key, commandName)
	
	return true
end

function keyBinding:disableKeys()
	self.disabled = true
end

function keyBinding:enableKeys()
	self.disabled = false
end

function keyBinding:getCommandKey(commandName)
	return self.commandToKey[commandName]
end

function keyBinding:addCommandName(commandName, name)
	if not self.commandNames[commandName] then
		table.insert(self.commandNameOrder, commandName)
	end
	
	self.commandNames[commandName] = name
end

function keyBinding:getCommandNameOrder()
	return self.commandNameOrder
end

function keyBinding:getCommandName(commandName)
	return self.commandNames[commandName]
end

function keyBinding:addKeyDisplay(key, display)
	self.keyNames[key] = display
end

function keyBinding:getKeyDisplay(key)
	return self.keyNames[key] or string.upper(key)
end

function keyBinding:getNiceCommandDisplay(commandName)
	local commandKey = self.commandToKey[commandName]
	
	if not commandKey then
		return _format(_T("KEY_BINDING_NOT_BOUND", "NOT BOUND (BINDING)"), "BINDING", self.commandNames[commandName])
	end
	
	return self:getKeyDisplay(commandKey)
end

function keyBinding:clearKey(key)
	local oldCommand = self.assignedKeys[key]
	
	self.assignedKeys[key] = nil
	self.commandToKey[oldCommand] = nil
	
	events:fire(keyBinding.EVENTS.KEY_UNBOUND, key, oldCommand)
end

function keyBinding:clearCommand(commandName)
	local cmdkey = self.commandToKey[commandName]
	
	if cmdkey then
		self:clearKey(cmdkey)
	end
end

function keyBinding:addAssignableKey(key)
	self.assignableKeys[key] = true
end

function keyBinding:addAssignableKeys(...)
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		
		self.assignableKeys[key] = true
	end
end

function keyBinding:removeAssignableKey(key)
	self.assignableKeys[key] = nil
end

function keyBinding:removeAssignableKeys(...)
	for i = 1, select("#", ...) do
		local key = select(i, ...)
		
		self.assignableKeys[key] = nil
	end
end

function keyBinding:allowLatinAlphabet()
	self:addAssignableKeys(unpack(keyBinding.LATIN_ALPHABET))
end

function keyBinding:allowControlKeys()
	self:addAssignableKeys(unpack(keyBinding.CONTROL_KEYS))
	self:addKeyDisplay("lalt", _T("LEFT_ALT", "Left alt"))
	self:addKeyDisplay("ralt", _T("RIGHT_ALT", "Right alt"))
	self:addKeyDisplay("lctrl", _T("LEFT_CONTROL", "Left control"))
	self:addKeyDisplay("rctrl", _T("RIGHT_CONTROL", "Right control"))
	self:addKeyDisplay("lshift", _T("LEFT_SHIFT", "Left shift"))
	self:addKeyDisplay("rshift", _T("RIGHT_SHIFT", "Right shift"))
end

function keyBinding:allowDefaultKeys()
	self:allowLatinAlphabet()
	self:allowControlKeys()
end

function keyBinding:clearKeys()
	table.clear(self.assignedKeys)
end

function keyBinding:assignCallbackToCommand(command, callback)
	self.commandNameCallback[command] = callback
end

function keyBinding:checkKey(key)
	if self.disabled then
		return 
	end
	
	local command = self.assignedKeys[key]
	
	if command then
		local callback = self.commandNameCallback[command]
		
		if callback then
			local result = callback(key)
			
			if result == false then
				return false
			elseif result == nil then
				return true
			end
			
			return true
		end
	end
	
	return nil
end

function keyBinding:save()
	return bitser.dumps(self.assignedKeys)
end

function keyBinding:load(keyBinds)
	self:clearKeys()
	
	for key, commandName in pairs(keyBinds) do
		self:assignKey(key, commandName)
	end
end
