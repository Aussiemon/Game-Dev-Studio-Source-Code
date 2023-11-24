local EngineUpdateTasklist = {}

EngineUpdateTasklist.CATCHABLE_EVENTS = {
	studio.EVENTS.PURCHASED_PLATFORM_LICENSE
}

function EngineUpdateTasklist:setBeginProject(begin)
	self.beginProject = begin
end

function EngineUpdateTasklist:getProject()
	return self.beginProject:getProject()
end

function EngineUpdateTasklist:setSelectTeam(tm)
	self.selectTeam = tm
end

function EngineUpdateTasklist:setDesiredTeam(teamObj)
	local project = self.beginProject:getProject()
	
	if project then
		project:setDesiredTeam(teamObj)
	else
		self.selectTeam:setDefaultText()
	end
end

function EngineUpdateTasklist:handleEvent(event, platformID)
	local project = self.beginProject:getProject()
	
	if project then
		self:updateList(project)
	end
end

function EngineUpdateTasklist:updateList(obj)
	obj = obj or self.beginProject:getProject()
	
	if not obj then
		return 
	end
	
	self.beginProject:setProject(obj)
	obj:clearDesiredFeatures()
	
	if self.selectTeam.team then
		obj:setDesiredTeam(self.selectTeam.team)
	else
		obj:setDesiredTeam()
	end
	
	self:removeItems()
	
	for key, categoryName in ipairs(engine.DEVELOPMENT_CATEGORIES) do
		local categoryData = taskTypes:getTaskCategory(categoryName)
		local missingFeatures = obj:findMissingAvailableFeatures(categoryName)
		
		if #missingFeatures > 0 then
			local categoryTitle = projectsMenu:createEngineTaskCategory(categoryName, self)
			
			self:addItem(categoryTitle)
			
			for key, taskType in ipairs(missingFeatures) do
				local taskSelection = gui.create("TaskTypeSelection")
				
				taskSelection:setProject(obj)
				taskSelection:setFeatureID(taskType.id)
				taskSelection:setFont(fonts.get("pix20"))
				taskSelection:setText(taskType.display)
				taskSelection:setSize(360, 20)
				taskSelection:setScissorParent(self)
				categoryTitle:addItem(taskSelection)
			end
		end
	end
end

gui.register("EngineUpdateTasklist", EngineUpdateTasklist, "ScrollbarPanel")
