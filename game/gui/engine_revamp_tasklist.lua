require("game/gui/engine_update_tasklist")

local EngineRevampTasklist = {}

function EngineRevampTasklist:setEngineStats(stats)
	self.engineStatDisplay = stats
end

EngineRevampTasklist.handleEvent = false

function EngineRevampTasklist:updateList(obj)
	obj = obj or self.beginProject:getProject()
	
	if not obj then
		return 
	end
	
	self.beginProject:setProject(obj)
	self.engineStatDisplay:setEngine(obj)
	
	if self.selectTeam.team then
		obj:setDesiredTeam(self.selectTeam.team)
	else
		obj:setDesiredTeam()
	end
	
	local currentFeatures = obj:getFeatures()
	
	self:removeItems()
	
	for key, categoryName in ipairs(engine.DEVELOPMENT_CATEGORIES) do
		if taskTypes:canDisplayCategory(categoryName) then
			local categoryData = taskTypes:getTaskCategory(categoryName)
			local count = 0
			
			for key, taskType in ipairs(categoryData.taskTypes) do
				if currentFeatures[taskType.id] then
					count = count + 1
				end
			end
			
			if count > 0 then
				local categoryTitle = projectsMenu:createEngineTaskCategory(categoryName, self)
				
				self:addItem(categoryTitle)
				
				for keyType, taskType in ipairs(categoryData.taskTypes) do
					if currentFeatures[taskType.id] then
						local taskSelection = gui.create("TaskTypeSelection")
						
						taskSelection:setProject(obj)
						taskSelection:setFeatureID(taskType.id)
						taskSelection:setFont(fonts.get("pix20"))
						taskSelection:setText(taskType.display)
						taskSelection:setSize(150, 20)
						taskSelection:setNotSelectable(true)
						taskSelection:setScissorParent(self)
						categoryTitle:addItem(taskSelection)
					end
				end
			end
		end
	end
end

gui.register("EngineRevampTasklist", EngineRevampTasklist, "EngineUpdateTasklist")
