local researchScroll = {}

researchScroll.inProgress = nil
researchScroll.featuresInResearch = nil
researchScroll.researchFinishedCategoryColor = color(160, 200, 120, 255)
researchScroll.researchFinishedCategoryColorHover = color(190, 230, 150, 255)

function researchScroll:init()
	self.featuresInResearch = {}
	self.researchCategories = {}
	self.engineResearchCategories = {}
	self.gameResearchCategories = {}
	self.researchTaskData = task:getData("research_task")
end

function researchScroll:buildInResearchFeatureList()
	for key, employee in ipairs(studio:getEmployees()) do
		local task = employee:getTask()
		
		if task and task.mtindex == self.researchTaskData.mtindex then
			self.featuresInResearch[task:getTaskType()] = task
		end
	end
	
	return self.featuresInResearch
end

function researchScroll:createEngineTechResearchables()
end

function researchScroll:addResearchedFeaturesToCategory(researchableList, categoryObject)
	local inserted = false
	
	for key, category in ipairs(researchableList) do
		local categoryTasks = taskTypes:getResearchedCategoryFeatures(category)
		
		if #categoryTasks > 0 then
			inserted = true
			
			local categoryData = taskTypes:getTaskCategory(category)
			local categoryTitle = gui.create("Category")
			
			categoryTitle:setSize(360, 23)
			categoryTitle:setFont(fonts.get("pix24"))
			categoryTitle:setText(categoryData.title)
			categoryTitle:assumeScrollbar(self)
			categoryTitle:setPanelFillColor(researchScroll.researchFinishedCategoryColor:unpack())
			categoryTitle:setPanelHoverColor(researchScroll.researchFinishedCategoryColorHover:unpack())
			
			if categoryData.icon then
				categoryTitle:setIcon(categoryData.icon)
			end
			
			categoryObject:addItem(categoryTitle)
			
			for key, data in ipairs(categoryTasks) do
				local element = gui.create("TaskTypeResearchSelection")
				
				element:setHeight(22)
				element:setFont(fonts.get("pix20"))
				element:setFeatureID(data.id)
				categoryTitle:addItem(element)
			end
		end
	end
	
	return inserted
end

function researchScroll:setAssignee(assignee)
	self.assignee = assignee
end

function researchScroll:addResearchableToCategory(researchableList, categoryObject, employee)
	local inserted = false
	local isGameTech = gameProject.DEVELOPMENT_CATEGORIES == researchableList
	local storeList = self.gameResearchCategories or self.engineResearchCategories
	
	for key, category in ipairs(researchableList) do
		local categoryTasks = taskTypes:getResearchableCategoryFeatures(category)
		local curIndex = 1
		
		for i = 1, #categoryTasks do
			local taskData = categoryTasks[curIndex]
			
			if self.featuresInResearch[taskData.id] then
				table.remove(categoryTasks, curIndex)
			else
				curIndex = curIndex + 1
			end
		end
		
		if #categoryTasks > 0 then
			inserted = true
			
			local categoryData = taskTypes:getTaskCategory(category)
			
			for key, data in ipairs(categoryTasks) do
				local element = gui.create("TaskTypeResearchSelection")
				
				element:setHeight(22)
				element:setFont(fonts.get("pix20"))
				element:setTaskID(data.taskID)
				element:setFeatureID(data.id)
				element:setCurrentAssignee(employee)
				self:addToResearchableCategory(element)
			end
		end
	end
	
	return inserted
end

function researchScroll:createInResearchFeatures()
	self:buildInResearchFeatureList()
	
	for featureID, taskObj in pairs(self.featuresInResearch) do
		local element = gui.create("TaskTypeResearchSelection")
		
		element:setHeight(22)
		element:setFont(fonts.get("pix20"))
		element:setFeatureID(featureID)
		element:setTask(taskObj)
		self:moveToInProgress(element)
	end
end

function researchScroll:createResearchableEngineTech()
	local engineTechCat = gui.create("Category")
	
	engineTechCat:setHeight(28)
	engineTechCat:setFont(fonts.get("pix28"))
	engineTechCat:setText(_T("ENGINE_TECH", "Engine tech"))
	engineTechCat:assumeScrollbar(self)
	self:addItem(engineTechCat)
	
	self.engineTechCategory = engineTechCat
	
	self:addResearchableToCategory(engine.DEVELOPMENT_CATEGORIES, engineTechCat, self.assignee)
end

function researchScroll:createResearchableGameTech(categories)
	if not self.gameTechCategory then
		local gameTechCat = gui.create("Category")
		
		gameTechCat:setHeight(28)
		gameTechCat:setFont(fonts.get("pix28"))
		gameTechCat:setText(_T("GAME_TECH", "Game tech"))
		gameTechCat:assumeScrollbar(self)
		self:addItem(gameTechCat)
		
		self.gameTechCategory = gameTechCat
	end
	
	self:addResearchableToCategory(categories, gameTechCat, self.assignee)
end

function researchScroll:createResearchedEngineTech()
	local researchedEngineTech = gui.create("Category")
	
	researchedEngineTech:setHeight(28)
	researchedEngineTech:setFont(fonts.get("pix28"))
	researchedEngineTech:setText(_T("RESEARCHED_ENGINE_TECH", "Researched engine tech"))
	researchedEngineTech:assumeScrollbar(self)
	researchedEngineTech:setPanelFillColor(researchScroll.researchFinishedCategoryColor:unpack())
	researchedEngineTech:setPanelHoverColor(researchScroll.researchFinishedCategoryColorHover:unpack())
	self:addItem(researchedEngineTech)
	self:addResearchedFeaturesToCategory(engine.DEVELOPMENT_CATEGORIES, researchedEngineTech)
end

function researchScroll:createResearchedGameTech()
	local researchedGameTech = gui.create("Category")
	
	researchedGameTech:setHeight(28)
	researchedGameTech:setFont(fonts.get("pix28"))
	researchedGameTech:setText(_T("RESEARCHED_GAME_TECH", "Researched game tech"))
	researchedGameTech:assumeScrollbar(self)
	researchedGameTech:setPanelFillColor(researchScroll.researchFinishedCategoryColor:unpack())
	researchedGameTech:setPanelHoverColor(researchScroll.researchFinishedCategoryColorHover:unpack())
	self:addItem(researchedGameTech)
	self:addResearchedFeaturesToCategory(gameProject.DEVELOPMENT_CATEGORIES, researchedGameTech)
end

function researchScroll:moveToInProgress(element)
	if not self.inProgress then
		local inProgressCat = gui.create("Category")
		
		inProgressCat:setHeight(26)
		inProgressCat:setFont(fonts.get("pix28"))
		inProgressCat:setText(_T("IN_PROGRESS", "In progress"))
		inProgressCat:assumeScrollbar(self)
		self:addItem(inProgressCat, 1)
		
		self.inProgress = inProgressCat
	end
	
	self.inProgress:addItem(element, true)
	
	local elementCategory = element:getCategory()
	local category = self.researchCategories[elementCategory]
	
	if category and #category:getItems() == 0 then
		if category.curCategoryTitle then
			category.curCategoryTitle:removeItem(category)
		end
		
		self:removeItem(category)
		category:kill()
		
		category = nil
		self.researchCategories[elementCategory] = nil
	end
	
	for key, element in ipairs(self.inProgress:getItems()) do
		if element:getTask():isCancelled() then
			element:cancelResearch()
		end
	end
end

function researchScroll:removeFromInProgress(element)
	self.inProgress:removeItem(element)
	
	if #self.inProgress:getItems() == 0 then
		self:removeItem(self.inProgress)
		self.inProgress:kill()
		
		self.inProgress = nil
	end
	
	self:addToResearchableCategory(element, true, true)
end

function researchScroll:addToResearchableCategory(element, elementInFrontOfCategory, categoryInFrontOfMain)
	local category = element:getCategory()
	local targetCategory = self.researchCategories[category]
	
	if not targetCategory then
		local categoryData = taskTypes:getTaskCategory(category)
		local categoryTitle = gui.create("Category")
		
		categoryTitle:setFont(fonts.get("pix24"))
		categoryTitle:setText(categoryData.title)
		categoryTitle:setSize(360, 23)
		categoryTitle:assumeScrollbar(self)
		
		if categoryData.icon then
			categoryTitle:setIcon(categoryData.icon)
		end
		
		local mainCategory = element:isGameFeature() and self.gameTechCategory or self.engineTechCategory
		
		mainCategory:addItem(categoryTitle, categoryInFrontOfMain)
		
		self.researchCategories[category] = categoryTitle
		targetCategory = categoryTitle
	end
	
	targetCategory:addItem(element, elementInFrontOfCategory)
end

gui.register("ResearchScrollbarPanel", researchScroll, "ScrollbarPanel")
