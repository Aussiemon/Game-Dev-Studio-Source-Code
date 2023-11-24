menuCreator = {}
menuCreator.featuresInResearch = {}
menuCreator.researchCategories = {}

function menuCreator:buildInResearchFeatureList()
	for key, employee in ipairs(studio:getEmployees()) do
		local task = employee:getTask()
		
		if task and task.mtindex == researchTaskData.mtindex then
			self.featuresInResearch[task:getTaskType()] = task:getCompletion()
		end
	end
	
	return self.featuresInResearch
end

function menuCreator:getInResearchFeatureList()
	return self.featuresInResearch
end

function menuCreator:addResearchedFeaturesToCategory(researchableList, categoryObject)
	local inserted = false
	
	for key, category in ipairs(researchableList) do
		local categoryTasks = taskTypes:getResearchedCategoryFeatures(category)
		
		if #categoryTasks > 0 then
			inserted = true
			
			local categoryData = taskTypes:getTaskCategory(category)
			local categoryTitle = gui.create("Category")
			
			categoryTitle:setFont(fonts.get("pix24"))
			categoryTitle:setText(categoryData.title)
			categoryTitle:setSize(360, 23)
			categoryTitle:assumeScrollbar(self.researchScrollPanel)
			categoryTitle:setPanelFillColor(menuCreator.researchFinishedCategoryColor:unpack())
			categoryTitle:setPanelHoverColor(menuCreator.researchFinishedCategoryColorHover:unpack())
			
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

function menuCreator:addResearchableToCategory(researchableList, categoryObject, employee)
	local inserted = false
	
	for key, category in ipairs(researchableList) do
		local categoryTasks = taskTypes:getResearchableCategoryFeatures(category)
		local curIndex = 1
		
		for i = 1, #categoryTasks do
			local taskData = categoryTasks[curIndex]
			
			if self.featuresInResearch[taskData.id] then
				table.remove(categoryTasks, i)
			else
				curIndex = curIndex + 1
			end
		end
		
		if #categoryTasks > 0 then
			inserted = true
			
			local categoryData = taskTypes:getTaskCategory(category)
			local categoryTitle = gui.create("Category")
			
			categoryTitle:setFont(fonts.get("pix24"))
			categoryTitle:setText(categoryData.title)
			categoryTitle:setSize(360, 23)
			categoryTitle:assumeScrollbar(self.researchScrollPanel)
			
			if categoryData.icon then
				categoryTitle:setIcon(categoryData.icon)
			end
			
			categoryObject:addItem(categoryTitle)
			table.insert(self.researchCategories, categoryTitle)
			
			for key, data in ipairs(categoryTasks) do
				local element = gui.create("TaskTypeResearchSelection")
				
				element:setHeight(22)
				element:setFont(fonts.get("pix20"))
				element:setFeatureID(data.id)
				element:setEmployee(employee)
				categoryTitle:addItem(element)
			end
		end
	end
	
	return inserted
end

function menuCreator:clearResearchMenuInfo()
	table.clear(self.featuresInResearch)
	
	self.researchScrollPanel = nil
end

function menuCreator:createResearchMenu(parent, x, y, w, h, assignee)
	x = x or 0
	y = y or 0
	
	local researchScrollPanel = gui.create("ResearchScrollbarPanel", parent)
	
	researchScrollPanel:setSize(w, h - 30)
	researchScrollPanel:setPos(x, y)
	researchScrollPanel:setAdjustElementPosition(true)
	researchScrollPanel:setSpacing(3)
	researchScrollPanel:setPadding(3, 3)
	researchScrollPanel:setAssignee(assignee)
	researchScrollPanel:addDepth(50)
	
	self.researchScrollPanel = researchScrollPanel
	
	researchScrollPanel:createInResearchFeatures()
	researchScrollPanel:createResearchableEngineTech()
	researchScrollPanel:createResearchableGameTech(gameProject.DEVELOPMENT_CATEGORIES)
	researchScrollPanel:createResearchableGameTech({
		"invisible_research"
	})
	
	local researchAllButton = gui.create("ResearchAllTechButton", parent)
	
	researchAllButton:setPos(x, researchScrollPanel.localY + researchScrollPanel.h + _S(5))
	researchAllButton:setSize(200, 25)
	researchAllButton:setFont("bh24")
	researchAllButton:setText(_T("RESEARCH_ALL_TECH", "Research all"))
	
	return researchScrollPanel, inProgressCat
end
