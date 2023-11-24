local bookBoostList = {}

function bookBoostList:init()
	self.boostElementsBySkillID = {}
	
	self:fillBoostDisplay()
	self:setTitle(_T("BOOK_BOOSTS_TITLE", "Boosts"))
	self:setBaseWidth(bookController.BOOST_ELEMENT_WIDTH)
end

function bookBoostList:handleEvent(event, bookID)
	local bookshelfBase = objects.getClassData("bookshelf_object_base")
	
	if event == bookController.EVENTS.BOOK_PLACED or event == bookController.EVENTS.BOOK_REMOVED then
		self:updateBoostDisplay(bookID)
	elseif event == bookshelfBase.EVENTS.POST_CLEARED then
		self:removeInvalidDisplays()
	elseif event == bookshelfBase.EVENTS.FILLED then
		self:fillBoostDisplay()
	end
end

function bookBoostList:fillBoostDisplay()
	self.office = bookController:getCurrentBookshelfObject():getOffice()
	
	local boosts = bookController:getSkillExperienceBoosts(self.office)
	
	for key, skillData in ipairs(skills.registered) do
		if boosts[skillData.id] > 1 and not self.boostElementsBySkillID[skillData.id] then
			self:createBoostDisplay(skillData.id)
		end
	end
end

function bookBoostList:removeInvalidDisplays()
	local index = 1
	
	for i = 1, #self.children do
		local child = self.children[index]
		local skillID = child:getSkillID()
		local boost = bookController:getSkillExperienceBoost(skillID, self.office)
		
		if boost <= 1 then
			self:removeBoostDisplay(child)
		else
			index = index + 1
		end
	end
end

function bookBoostList:updateBoostDisplay(bookID)
	local skillBoost = bookController:getBookData(bookID).skillBoost
	
	if skillBoost then
		local skillID = skillBoost.id
		local boost = bookController:getSkillExperienceBoost(skillID, self.office)
		
		if boost > 1 then
			self:attemptCreateBoostDisplay(skillID)
		else
			local element = self.boostElementsBySkillID[skillID]
			
			if element then
				self:removeBoostDisplay(element)
			end
		end
	end
end

function bookBoostList:removeBoostDisplay(element)
	self:removeChild(element)
	element:kill()
	
	self.boostElementsBySkillID[element:getSkillID()] = nil
	
	self:queueLayoutUpdate()
end

function bookBoostList:attemptCreateBoostDisplay(skillID)
	local element = self.boostElementsBySkillID[skillID]
	
	if not element then
		self:createBoostDisplay(skillID)
	else
		element:updateDisplay()
	end
end

function bookBoostList:createBoostDisplay(skillID)
	local display = gui.create("BookBoostDisplay", self)
	
	display:setSize(bookController.BOOST_ELEMENT_WIDTH, bookController.BOOST_ELEMENT_HEIGHT)
	display:setSkillID(skillID)
	
	self.boostElementsBySkillID[skillID] = display
end

gui.register("BookBoostTitledList", bookBoostList, "TitledList")
