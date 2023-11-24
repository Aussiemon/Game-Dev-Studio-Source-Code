local scroll = {}

scroll.CATCHABLE_EVENTS = {
	gameProject.EVENTS.EDITION_ADDED
}

function scroll:handleEvent(event, proj, edition)
	if event == gameProject.EVENTS.EDITION_ADDED then
		self:createEditionElement(edition)
	end
end

function scroll:removeEditionElement(elem)
	local key = self:getItem(elem)
	
	elem:kill()
	
	local newElem = self.items[key]
	
	if newElem then
		newElem:selectForAdjustment()
	else
		self.items[#self.items]:selectForAdjustment()
	end
end

function scroll:setSetupScroller(setup)
	self.setupScroller = setup
end

function scroll:getSetupScroller()
	return self.setupScroller
end

function scroll:createGameEditions(gameProj)
	self.project = gameProj
	
	for key, edit in ipairs(self.project:getEditions()) do
		self:createEditionElement(edit)
	end
end

function scroll:createEditionElement(edition)
	local elem = gui.create("GameEditionDisplay")
	
	elem:setWidth(self.w - _US(self:getScrollerSize()))
	elem:setEdition(edition)
	elem:setScroller(self)
	self:addItem(elem)
end

gui.register("GameEditionScroller", scroll, "ScrollbarPanel")
