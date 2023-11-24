local eventBox = {}

eventBox.SAVED_EVENT_DATA = {}
eventBox.MAX_DISPLAYED_EVENTS = 40
eventBox.TIME_TO_FADE_AFTER_EVENT = 6
eventBox.MAX_ALPHA = 1
eventBox.MIN_ALPHA = 0.8
eventBox.IMPORTANCE = {
	REVIEW = 5,
	CRITICAL = 4,
	LOW = 1,
	PLATFORM_ADVERT = 6,
	HIGH = 3,
	GAME_AWARDS = 7,
	MEDIUM = 2
}
eventBox.IMPORTANCE_COLORS = {
	[eventBox.IMPORTANCE.LOW] = {
		panel = color(140, 169, 204, 255)
	},
	[eventBox.IMPORTANCE.MEDIUM] = {
		panel = color(166, 204, 140, 255)
	},
	[eventBox.IMPORTANCE.HIGH] = {
		panel = color(216, 196, 130, 255)
	},
	[eventBox.IMPORTANCE.CRITICAL] = {
		panel = color(255, 124, 68, 255)
	},
	[eventBox.IMPORTANCE.REVIEW] = {
		panel = color(216, 188, 136, 255)
	},
	[eventBox.IMPORTANCE.PLATFORM_ADVERT] = {
		panel = color(216, 169, 153, 255)
	},
	[eventBox.IMPORTANCE.GAME_AWARDS] = {
		panel = color(158, 208, 229, 255)
	}
}
eventBox.scrollbarColor = color(0, 0, 0, 0)

function eventBox:init()
	eventBox.font = "bh19"
	eventBox.fontObject = fonts.get(eventBox.font)
	
	self:initScrollbar()
	
	self.alpha = 0.4
	self.fadeTime = 0
end

function eventBox:initScrollbar()
	self.scrollBar = gui.create("ScrollbarPanel", self)
	
	self.scrollBar:setAdjustElementPosition(true)
	self.scrollBar:setPadding(4, 4)
	self.scrollBar:setSpacing(4)
	self.scrollBar:setPanelOutlineColor(eventBox.scrollbarColor:unpack())
end

function eventBox:preResolutionChange()
	table.clearArray(self.SAVED_EVENT_DATA)
	
	for key, element in ipairs(self.scrollBar:getCanvas():getChildren()) do
		local saved = element:saveData()
		
		table.insert(self.SAVED_EVENT_DATA, saved)
	end
end

function eventBox:getElements()
	return self.scrollBar:getItems()
end

function eventBox:postResolutionChange()
	for key, data in ipairs(self.SAVED_EVENT_DATA) do
		self:addEvent(nil, nil, nil, nil, data)
		
		self.SAVED_EVENT_DATA[key] = nil
	end
end

function eventBox:think()
	self.realMouseOver = (self:isMouseOver() or self.scrollBar:isMouseOver() or self.scrollBar:isMouseOverChildren()) and not camera:getTouchPosition()
	
	if self.realMouseOver then
		self.alpha = math.approach(self.alpha, eventBox.MAX_ALPHA, frameTime * 5)
		
		self:setCanHover(true)
		
		self.fadeTime = 0
	elseif curTime < self.fadeTime then
		self.alpha = math.approach(self.alpha, eventBox.MAX_ALPHA, frameTime * 5)
		
		self:setCanHover(true)
	else
		self.alpha = math.approach(self.alpha, eventBox.MIN_ALPHA, frameTime * 5)
		
		self:setCanHover(false)
	end
	
	eventBox.scrollbarColor.a = self.alpha
	
	self.scrollBar:setPanelOutlineColor(eventBox.scrollbarColor:unpack())
end

function eventBox:setSize(w, h)
	gui.setSize(self, w, h)
	self.scrollBar:setPos(1, 1)
	self.scrollBar:setSize(w - 2, h - 2)
	self.scrollBar:performLayout()
end

function eventBox:readjustElementSize(newSize)
	for key, item in ipairs(self.scrollBar:getItems()) do
		item:setWidth(newSize)
		item:scaleToText()
	end
end

function eventBox:addEvent(importance, textID, data, elementType, savedData)
	local color
	
	if importance then
		importance = math.min(math.max(importance, 1), #eventBox.IMPORTANCE_COLORS)
		color = eventBox.IMPORTANCE_COLORS[importance]
	end
	
	if savedData then
		elementType = savedData.class
	else
		elementType = elementType or "EventBoxElement"
	end
	
	local element = gui.create(elementType, nil, color and color.panel, color and color.text, color and color.shadow)
	
	element:setWidth(self.elementSize or self.scrollBar.rawW - 8)
	
	if savedData then
		element:loadData(savedData)
	else
		element:setFont(eventBox.font)
		element:setTextID(textID)
		element:setData(data)
		element:setImportance(importance)
	end
	
	element:setEventBox(self)
	element:addDepth(1)
	
	local curItems = self.scrollBar:getItems()
	
	if #curItems >= eventBox.MAX_DISPLAYED_EVENTS then
		local item = curItems[1]
		
		self.scrollBar:removeItem(item)
		item:kill()
	end
	
	self.scrollBar:addItem(element)
	
	local requiredScroller = self.requiresScroller
	
	self.requiresScroller = self.scrollBar:requiresScroller(element)
	
	if self.requiresScroller ~= requiredScroller then
		if self.requiresScroller then
			self.elementSize = self.scrollBar.rawW - 8 - self.scrollBar:getScrollerSize()
			
			self:readjustElementSize(self.elementSize)
		else
			self.elementSize = self.scrollBar.rawW - 8
			
			self:readjustElementSize(self.elementSize)
		end
	else
		element:setWidth(self.elementSize)
	end
	
	self.scrollBar:buildActiveObjectList()
	self.scrollBar:performLayout()
	self.scrollBar:scrollToBottom()
	
	self.fadeTime = curTime + eventBox.TIME_TO_FADE_AFTER_EVENT
	
	return element
end

function eventBox:onKill()
	if self.scrollPanel then
		self.scrollPanel:removeItem(self, self)
	end
end

function eventBox:updateSprites()
	self:setNextSpriteColor(game.UI_COLORS.NEW_HUD_OUTER:unpack())
	
	self.bgSpriteUnder = self:allocateHollowRoundedRectangle(self.bgSpriteUnder, -_S(1), -_S(1), self.rawW + 2, self.rawH + 2, 2, -0.5)
end

function eventBox:draw(w, h)
	love.graphics.setColor(0, 0, 0, 150 * self.alpha)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

gui.register("EventBox", eventBox)
