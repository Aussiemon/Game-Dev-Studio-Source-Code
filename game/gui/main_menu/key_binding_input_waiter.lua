local keyBindingWaiter = {}

keyBindingWaiter._scaleHor = false
keyBindingWaiter._scaleVert = false
keyBindingWaiter.canPropagateKeyPress = false

function keyBindingWaiter:setCommand(command)
	self.command = command
	self.baseText = string.easyformatbykeys(_T("BASE_KEY_BIND_TEXT", "Press ESCAPE to cancel.\nPress BACKSPACE to clear binding.\n\nWaiting for input to bind ACTION..."), "ACTION", keyBinding:getCommandName(self.command))
end

function keyBindingWaiter:init()
	self.fontObject = fonts.get("pix24")
	
	self:bringUp()
	
	self.invalidKeyAlpha = 0
	self.invalidKeyDisplay = 0
	
	self:select()
end

function keyBindingWaiter:onKeyPress(key)
	if key == "escape" then
		self:kill()
	elseif key == "backspace" then
		keyBinding:clearCommand(self.command)
		self:kill()
		game.saveUserPreferences()
	elseif keyBinding:attemptBind(key, self.command) then
		self:kill()
		game.saveUserPreferences()
	else
		self:displayInvalidKey(key)
	end
	
	return true
end

function keyBindingWaiter:displayInvalidKey(key)
	self.invalidKeyAlpha = 255
	self.invalidKeyDisplay = 3
	self.invalidKeyText = string.easyformatbykeys(_T("INVALID_KEY_TO_BIND", "Can not bind action to 'KEY'"), "KEY", keyBinding:getKeyDisplay(key))
end

function keyBindingWaiter:draw(w, h)
	love.graphics.setColor(0, 0, 0, 150)
	love.graphics.rectangle("fill", 0, 0, w, h)
	
	local textHeight = self.fontObject:getTextHeight(self.baseText)
	local textWidth = self.fontObject:getWidth(self.baseText)
	
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.baseText, w * 0.5 - textWidth * 0.5, h * 0.5 - textHeight * 0.5, 255, 255, 255, 255, 0, 0, 0, 255)
	
	if self.invalidKeyDisplay > 0 then
		self.invalidKeyDisplay = self.invalidKeyDisplay - frameTime
	else
		self.invalidKeyAlpha = math.approach(self.invalidKeyAlpha, 0, frameTime * 255 / 1.5)
	end
	
	if self.invalidKeyAlpha > 0 then
		local r, g, b = game.UI_COLORS.RED:unpack()
		
		love.graphics.printST(self.invalidKeyText, w * 0.5 - self.fontObject:getWidth(self.invalidKeyText) * 0.5, h * 0.5 + textHeight * 0.5 + self.fontObject:getTextHeight(self.invalidKeyText), r, g, b, self.invalidKeyAlpha, 0, 0, 0, self.invalidKeyAlpha)
	end
end

gui.register("KeyBindingInputWaiter", keyBindingWaiter)
