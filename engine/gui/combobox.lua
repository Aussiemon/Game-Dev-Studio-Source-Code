local COMBOBOX = {}

COMBOBOX.autoClose = true
COMBOBOX.optionButtonType = "ComboBoxOption"
COMBOBOX.screenspacePadding = 10
COMBOBOX._scaleVert = false
COMBOBOX._scaleHor = false

function COMBOBOX:init(x, y)
	self.mouseHasLeft = false
	self.options = {}
	self.totalX, self.totalY = 0, 0
	
	self:bringUp(-1000)
end

function COMBOBOX:setOptionButtonType(type)
	self.optionButtonType = type
end

function COMBOBOX:getOptionButtonType()
	return self.optionButtonType
end

function COMBOBOX:setAutoCloseTime(time)
	self.autoCloseTime = time
end

function COMBOBOX:setInteractionObject(obj)
	self.interactionObject = obj
end

function COMBOBOX:onSelected(text, object)
end

function COMBOBOX:getOptionElements()
	return self.options
end

function COMBOBOX:clearOptions()
	for key, object in pairs(self.options) do
		object:kill()
		
		self.options[key] = nil
	end
	
	self.totalY = 0
end

function COMBOBOX:kill()
	for key, option in pairs(self.options) do
		option:kill()
	end
	
	self.baseClass.kill(self)
end

function COMBOBOX:resetCloseTime()
	self.timeToClose = nil
end

function COMBOBOX:think()
	if self.autoClose and self.mouseHasLeft then
		local canClose = false
		
		if self.autoCloseTime then
			if not self.timeToClose then
				self.timeToClose = curTime + self.autoCloseTime
			end
			
			if self.timeToClose and curTime > self.timeToClose then
				canClose = true
			end
		else
			canClose = true
		end
		
		if canClose then
			self:close()
		end
	end
	
	if self.interactionObject and self.interactionObject.GUI then
		if not self.interactionObject:isValid() then
			self:kill()
		elseif not self.interactionObject:canDraw() then
			self:kill()
		end
	end
end

function COMBOBOX:setHoverLink(link)
	local prevLink = self.hoverLink
	
	self.hoverLink = link
	
	if not prevLink then
		link:setHoverLink(self)
	end
end

function COMBOBOX:setHasMouseLeft(state, stop)
	self.mouseHasLeft = state
	
	local link = self.hoverLink
	
	if link and not stop then
		link:setHasMouseLeft(state, true)
	end
	
	if not state then
		self:resetCloseTime()
	end
end

function COMBOBOX:setAutoClose(state)
	self.autoClose = state
end

function COMBOBOX:addOption(x, y, w, h, text, font, func, icon)
	w, h = math.round(w), math.round(h)
	w = _S(w)
	h = _S(h)
	
	local option = gui.create(self.optionButtonType, self)
	
	option:setPos(x, self.totalY + y)
	option:setSize(w, h)
	option:setIcon(icon)
	
	if func then
		option.onClicked = func
	end
	
	option.tree = self
	
	if font then
		if type(font) == "string" then
			font = fonts.get(font)
		end
		
		option:setFont(font)
	end
	
	option:setText(text)
	
	self.totalY = self.totalY + option:getHeight()
	
	table.insert(self.options, option)
	
	if #self.options % 2 == 0 then
		option.skinPanelFillColor = option.skinPanelAlternativeFillColor
	end
	
	self:scaleToWidestOption()
	self:limitToScreenspace(_S(self.screenspacePadding))
	
	return option
end

function COMBOBOX:scaleToWidestOption(useOwnSizeAsBase)
	local largest = 0
	
	if useOwnSizeAsBase then
		largest = self.w
	end
	
	for key, option in ipairs(self.options) do
		largest = math.max(largest, option.rawW)
	end
	
	for key, option in ipairs(self.options) do
		option:setWidth(largest)
	end
	
	self:setSize(largest, self.totalY)
end

function COMBOBOX:close()
	for k, v in pairs(self.options) do
		v:kill()
	end
	
	self:kill()
end

function COMBOBOX:draw(w, h)
	love.graphics.setColor(0, 0, 0, 100)
	love.graphics.rectangle("line", -1, -1, w + 2, h + 2)
end

gui.register("ComboBox", COMBOBOX)
