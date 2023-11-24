local keyBindingOption = {}

function keyBindingOption:setCommand(command)
	self.command = command
	
	self:updateKeyText()
end

function keyBindingOption:updateKeyText()
	local key = keyBinding:getCommandKey(self.command)
	
	if not key then
		self:setText(_T("NOT_BOUND", "Not bound"))
	else
		self:setText(keyBinding:getKeyDisplay(key))
	end
end

function keyBindingOption:onClick(key, x, y)
	local waiter = gui.create("KeyBindingInputWaiter")
	
	waiter:setCommand(self.command)
	waiter:setSize(scrW, scrH)
	
	return keyBindingOption.baseClass.onClick(self, key, x, y)
end

function keyBindingOption:handleEvent(event, newBind)
	if event == keyBinding.EVENTS.KEY_BOUND or event == keyBinding.EVENTS.KEY_UNBOUND then
		self:updateKeyText()
	end
end

gui.register("KeyBindingOption", keyBindingOption, "Button")
