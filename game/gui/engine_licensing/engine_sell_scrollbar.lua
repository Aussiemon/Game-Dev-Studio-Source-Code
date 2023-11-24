local sellScrollbar = {}

sellScrollbar.CATCHABLE_EVENTS = {
	studio.EVENTS.STARTED_SELLING_ENGINE
}

function sellScrollbar:handleEvent(event)
	self:setupSoldEngine()
end

function sellScrollbar:setEnginesCategory(cat)
	self.enginesCategory = cat
end

function sellScrollbar:setupSoldEngine()
	if not self.soldEngineCategory then
		local catTitle = gui.create("Category")
		
		catTitle:setHeight(25)
		catTitle:setFont(fonts.get("pix24"))
		catTitle:setText(_T("ON_SALE_ENGINE", "On-sale engine"))
		catTitle:assumeScrollbar(self)
		self:addItem(catTitle, 1)
		
		self.soldEngineCategory = catTitle
	end
	
	local items = self.soldEngineCategory:getItems()
	local soldEngine = studio:getSoldEngine()
	
	if items then
		local currentDisplayedEngine = items[1]
		
		if currentDisplayedEngine then
			local curEngine = currentDisplayedEngine:getEngine()
			
			if curEngine ~= soldEngine then
				self.soldEngineCategory:removeItem(currentDisplayedEngine)
				self.enginesCategory:addItem(currentDisplayedEngine, true)
			else
				return 
			end
		end
	end
	
	local itemClass = "EngineSellingSelection"
	
	for key, item in ipairs(self.items) do
		if item.class == itemClass and item:getEngine() == soldEngine then
			self.soldEngineCategory:addItem(item, true)
			
			break
		end
	end
end

gui.register("EngineSellScrollbarPanel", sellScrollbar, "ScrollbarPanel")
