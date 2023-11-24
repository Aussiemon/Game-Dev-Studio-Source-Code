local workshopScrollbar = {}

workshopScrollbar.CATCHABLE_EVENTS = {
	workshop.EVENTS.MOD_QUERY_FINISHED,
	workshop.EVENTS.MOD_TAB_SWITCHED,
	workshop.EVENTS.FINAL_PAGE,
	workshop.EVENTS.MOD_QUERY_STARTED
}

function workshopScrollbar:init()
	self.page = 1
end

function workshopScrollbar:initPageButtons()
end

function workshopScrollbar:setPage(id)
	self.page = id
	
	if not self.itemList[id] then
		if self.catchQuery == workshop.MOD_QUERY_TYPES.PUBLISHED then
			workshop:queryCreatedMods(1)
		elseif self.catchQuery == workshop.MOD_QUERY_TYPES.SUBSCRIBED then
			workshop:querySubscribedMods(1)
		end
	end
end

function workshopScrollbar:setItemList(list)
	self.itemList = list
end

function workshopScrollbar:setTargetQuery(query)
	self.catchQuery = query
end

function workshopScrollbar:handleEvent(event, queriedPage, queryType, lastPage)
	if event == workshop.EVENTS.MOD_TAB_SWITCHED and queriedPage == self.catchQuery then
		self:populateList()
	elseif event == workshop.EVENTS.FINAL_PAGE then
		if queryType == self.catchQuery and not self.maxPage then
			self.maxPage = queriedPage
			
			if self.page == queriedPage then
				self:changePage(-1)
				
				self.itemList[queriedPage] = nil
			end
		end
		
		self:enableButtons()
	elseif event == workshop.EVENTS.MOD_QUERY_STARTED then
		self:disableButtons()
	else
		if queryType == self.catchQuery then
			self:populateList()
			
			if not self.maxPage and lastPage then
				self.maxPage = queriedPage
				
				self.pageControls:updatePageLabel()
			end
		end
		
		self:enableButtons()
	end
end

function workshopScrollbar:verifyButtons()
	if workshop:getModQueryType() == self.catchQuery then
		self:disableButtons()
	end
end

function workshopScrollbar:disableButtons()
	local nextB, prevB = self.pageControls:getButtons()
	
	nextB:setCanClick(false)
	nextB:queueSpriteUpdate()
end

function workshopScrollbar:enableButtons()
	local nextB, prevB = self.pageControls:getButtons()
	
	nextB:setCanClick(true)
	nextB:queueSpriteUpdate()
end

function workshopScrollbar:changePage(direction)
	local oldPage = self.page
	
	if not self.maxPage then
		self.page = math.max(1, self.page + direction)
		
		if self.page ~= oldPage then
			if not self.itemList[self.page] then
				local itemID = self.itemFillID
				
				self:cacheAllElements(itemID)
				
				if self.catchQuery == workshop.MOD_QUERY_TYPES.PUBLISHED then
					workshop:queryCreatedMods(self.page)
				elseif self.catchQuery == workshop.MOD_QUERY_TYPES.SUBSCRIBED then
					workshop:querySubscribedMods(self.page)
				end
			else
				self:populateList()
			end
			
			workshop:setCurrentPage(self.page)
			self.pageControls:updatePageLabel()
		end
	else
		self.page = math.max(1, math.min(#self.itemList, self.page + direction))
		
		if self.page ~= oldPage then
			self:populateList()
			workshop:setCurrentPage(self.page)
			self.pageControls:updatePageLabel()
		end
	end
end

function workshopScrollbar:getPage()
	return self.page
end

function workshopScrollbar:setFillElementID(id)
	self.itemFillID = id
end

function workshopScrollbar:setMaxPages(max)
	self.maxPage = max
end

function workshopScrollbar:createPageControls(parent)
	self.pageControls = gui.create("WorkshopPageControl", parent)
	
	self.pageControls:setScrollbar(self)
	
	return self.pageControls
end

function workshopScrollbar:getPageText()
	return _format(_T("WORKSHOP_MODLIST_PAGE_OF", "Page PAGE of MAX"), "PAGE", self.page, "MAX", self.maxPage or "?")
end

function workshopScrollbar:populateList()
	if self.page == self.lastPopulatedPage then
		return 
	end
	
	local modList = self.itemList[self.page]
	
	if modList and #modList > 0 then
		local itemID = self.itemFillID
		
		self:cacheAllElements(itemID)
		
		local w, h = self.rawW, self.rawH
		
		for key, data in pairs(modList) do
			local item = self:getFromCache(itemID) or gui.create(itemID)
			
			item:setSize(w - 20, 60)
			item:setData(data)
			self:addItem(item)
		end
		
		self.lastPopulatedPage = self.page
	end
end

gui.register("WorkshopScrollbarPanel", workshopScrollbar, "ScrollbarPanel")
