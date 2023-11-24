local editSetupScroll = {}

function editSetupScroll:setEdition(edit)
	self.edition = edit
	
	self:updateElements()
	events:fire(gameEditions.EVENTS.SETUP_ELEMENT_SELECTED, edit)
end

function editSetupScroll:getEdition()
	return self.edition
end

function editSetupScroll:updateElements()
	local edit = self.edition
	
	if not self.partElements then
		self:createElements()
	else
		for key, elem in ipairs(self.partElements) do
			elem:setCanClick(true)
			elem:setEdition(edit)
			elem:queueSpriteUpdate()
		end
	end
end

function editSetupScroll:disableElements()
	for key, elem in ipairs(self.partElements) do
		elem:setCanClick(false)
	end
end

function editSetupScroll:createElements()
	local elemW = self.rawW - self:getScrollerSize()
	local edit = self.edition
	
	self.partElements = {}
	
	for key, data in ipairs(gameEditions.registeredParts) do
		local elem = gui.create("GameEditionPartSelection")
		
		elem:setSize(elemW, 56)
		elem:setData(data)
		elem:setEdition(edit)
		self:addItem(elem)
		
		self.partElements[key] = elem
	end
end

gui.register("EditionSetupScroller", editSetupScroll, "ScrollbarPanel")
