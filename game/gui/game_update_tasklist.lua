local gameUpdateTasklist = {}

gameUpdateTasklist.UPDATE_LIST_ON_EVENT = {
	[gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED] = true,
	[gameProject.EVENTS.SET_PREQUEL] = true
}

function gameUpdateTasklist:init()
	gameUpdateTasklist.baseClass.init(self)
end

function gameUpdateTasklist:kill()
	gameUpdateTasklist.baseClass.kill(self)
end

function gameUpdateTasklist:setProject(proj)
	self.project = proj
end

function gameUpdateTasklist:handleEvent(event, data)
	if gameUpdateTasklist.UPDATE_LIST_ON_EVENT[event] and data == self.project then
		self:updateList()
	end
end

local implementedOptionCategories = {}

function gameUpdateTasklist:filterTasks(list)
	local devType = self.project:getGameType()
	local curIndex = 1
	
	for i = 1, #list do
		local taskData = list[curIndex]
		local devTypes = taskData.developmentType
		
		if devTypes and not devTypes[devType] then
			table.remove(list, curIndex)
		else
			curIndex = curIndex + 1
		end
	end
	
	table.clear(implementedOptionCategories)
end

function gameUpdateTasklist:createGametaskCategory(categoryName, projectObject, categoryTitlesByTaskCategory)
	local categoryTitle = projectsMenu:createGameTaskCategory(categoryName, projectObject)
	
	categoryTitlesByTaskCategory[categoryName] = categoryTitle
	
	self:addItem(categoryTitle)
	
	return categoryTitle
end

function gameUpdateTasklist:createCategoryTasks(categoryList, categoryTitlesByTaskCategory)
	local atLeastOne = false
	
	for key, categoryName in ipairs(categoryList) do
		local categoryTasks = taskTypes:getAvailableCategoryTasks(categoryName, self.project)
		
		self:filterTasks(categoryTasks)
		
		if #categoryTasks > 0 then
			local categoryData = taskTypes:getTaskCategory(categoryName)
			local categoryTitle = self:createGametaskCategory(categoryName, self.project, categoryTitlesByTaskCategory)
			
			for key, taskType in ipairs(categoryTasks) do
				local uiElement = projectsMenu:createTaskTypeElement(taskType, nil, "GameTaskTypeSelection")
				
				categoryTitle:addItem(uiElement)
			end
			
			atLeastOne = true
		end
	end
	
	return atLeastOne
end

function gameUpdateTasklist:updateList()
	self:removeItems()
	self.project:clearDesiredFeatures()
	
	local categoryTitlesByTaskCategory = {}
	local atLeastOne = self:createCategoryTasks(self.project:getTaskCategoryList(), categoryTitlesByTaskCategory)
	
	if not atLeastOne then
		local categoryTitle = gui.create("Category")
		
		categoryTitle:setSize(360, 25)
		categoryTitle:setFont(fonts.get("pix28"))
		categoryTitle:setText(_T("NO_TASKS_TO_ADD", "No available options"))
		categoryTitle:assumeScrollbar(self)
		self:addItem(categoryTitle)
	end
	
	local engineObj = self.project:getEngine()
	
	if engineObj then
		local prevGame = self.project:getSequelTo()
		local gameType = self.project:getGameType()
		
		for featureID, state in pairs(self.project:getEngineRevisionFeatures()) do
			if state then
				local taskTypeData = taskTypes.registeredByID[featureID]
				
				if taskTypeData.implementation and (not prevGame or prevGame and not prevGame:hasFeature(taskTypeData.implementation)) then
					local implementData = taskTypes.registeredByID[taskTypeData.implementation]
					
					if implementData.developmentType == gameType then
						local categoryTitle = categoryTitlesByTaskCategory[implementData.category]
						
						categoryTitle = categoryTitle or self:createGametaskCategory(implementData.category, self.project, categoryTitlesByTaskCategory)
						
						local element = projectsMenu:createTaskTypeElement(implementData, nil, "GameTaskTypeSelection")
						
						categoryTitle:addItem(element, true, true)
					end
				end
			end
		end
	end
end

gui.register("GameUpdateTasklist", gameUpdateTasklist, "ScrollbarPanel")
