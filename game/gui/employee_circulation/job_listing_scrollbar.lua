local jobListScroller = {}

jobListScroller.CATCHABLE_eVENTS = {
	employeeCirculation.EVENTS.SEARCH_STARTED,
	employeeCirculation.EVENTS.SEARCH_CANCELLED
}

function jobListScroller:init()
	self.noListingsCategory = gui.create("Category")
	
	self.noListingsCategory:setFont("bh24")
	self.noListingsCategory:setText(_T("NO_ACTIVE_LISTINGS", "No active listings"))
	self.noListingsCategory:hide()
end

function jobListScroller:handleEvent(event, searchData)
	if event == employeeCirculation.EVENTS.SEARCH_STARTED then
		self:addItem(self:createJobListing(searchData))
		
		if #self.items > 0 then
			self:hideNoListingsTitle()
		end
	elseif event == employeeCirculation.EVENTS.SEARCH_CANCELLED then
		self:removeJobListing(searchData)
	end
end

function jobListScroller:onKill()
	self.noListingsCategory:kill()
end

function jobListScroller:createJobListing(searchData)
	local listing = gui.create("JobListingDisplay")
	
	listing:setWidth(self.rawW)
	listing:setSearchData(searchData)
	
	return listing
end

function jobListScroller:removeJobListing(searchData)
	for key, item in ipairs(self.items) do
		if item:getSearchData() == searchData then
			self:removeItem(item, nil, key)
			item:kill()
			
			break
		end
	end
	
	if #self.items == 0 then
		self:showNoListingsTitle()
	end
end

function jobListScroller:hideNoListingsTitle()
	if not self.noListingsActive then
		return 
	end
	
	self.noListingsCategory:hide()
	self:removeItem(self.noListingsCategory)
	
	self.noListingsActive = false
end

function jobListScroller:showNoListingsTitle()
	self:addItem(self.noListingsCategory)
	self.noListingsCategory:show()
	
	self.noListingsActive = true
end

function jobListScroller:fillListings()
	local searches = employeeCirculation:getEmployeeSearches()
	
	if #searches == 0 then
		self:showNoListingsTitle()
	else
		for key, searchData in ipairs(searches) do
			self:addItem(self:createJobListing(searchData))
		end
	end
end

gui.register("JobListingScrollbar", jobListScroller, "ScrollbarPanel")
