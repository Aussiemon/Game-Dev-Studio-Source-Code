local newEngineTaskslist = {}

newEngineTaskslist.CATCHABLE_EVENTS = {
	studio.EVENTS.PURCHASED_PLATFORM_LICENSE
}

function newEngineTaskslist:handleEvent(event)
	self:updateList()
end

function newEngineTaskslist:setEngine(engine)
	self.engine = engine
end

function newEngineTaskslist:updateList()
	local obj = self.engine
	
	self:removeItems()
	
	for key, categoryName in ipairs(engine.DEVELOPMENT_CATEGORIES) do
		local categoryData = taskTypes:getTaskCategory(categoryName)
		local categoryTasks = taskTypes:getAvailableCategoryTasks(categoryName, obj)
		
		if #categoryTasks > 0 then
			local categoryTitle = projectsMenu:createEngineTaskCategory(categoryName, self)
			
			self:addItem(categoryTitle)
			
			for keyType, taskType in ipairs(categoryTasks) do
				local taskSelection = gui.create("TaskTypeSelection")
				
				taskSelection:setProject(obj)
				taskSelection:setFeatureID(taskType.id)
				taskSelection:setFont(fonts.get("pix20"))
				taskSelection:setText(taskType.display)
				taskSelection:setSize(150, 20)
				categoryTitle:addItem(taskSelection)
			end
		end
	end
end

gui.register("NewEngineTasklist", newEngineTaskslist, "ScrollbarPanel")
