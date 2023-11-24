local selectEngine = {}

function selectEngine:setEngine(engine)
	self.engine = engine
	
	self:setText(engine:getName())
end

function selectEngine:onClick()
	self:createEngineSelectionMenu()
	self:getBasePanel():kill()
end

function selectEngine:onMouseEntered()
	self.descBoxObject:setEngine(self.engine)
end

function selectEngine:onMouseLeft()
	self.descBoxObject:setEngine(nil)
end

function selectEngine:draw(w, h)
	local pcol, tcol = self:getStateColor()
	
	love.graphics.setColor(pcol.r, pcol.g, pcol.b, pcol.a)
	love.graphics.rectangle("fill", 0, 0, w, h)
	love.graphics.setFont(self.fontObject)
	love.graphics.printST(self.text, (w - self.textWidth) * 0.5, (h - self.textHeight) / 2, tcol.r, tcol.g, tcol.b, tcol.a, 0, 0, 0, 255)
end

function selectEngine:createEngineSelectionMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 640)
	frame:setFont(fonts.get("pix20"))
	frame:setTitle("Select features to add")
	frame:center()
	
	local scrollFrame = gui.create("ScrollbarPanel", frame)
	
	scrollFrame:setPos(5, 29)
	scrollFrame:setSize(390, 572)
	scrollFrame:setAdjustElementPosition(true)
	scrollFrame:setPadding(2, 2)
	scrollFrame:setSpacing(2)
	
	for key, categoryName in ipairs(engine.DEVELOPMENT_CATEGORIES) do
		local categoryData = taskTypes:getTaskCategory(categoryName)
		local missingFeatures = self.engine:findMissingAvailableFeatures(categoryData)
		
		if #missingFeatures > 0 then
			local categoryTitle = gui.create("Category")
			
			categoryTitle:setFont(fonts.get("pix28"))
			categoryTitle:setText(categoryData.title)
			categoryTitle:setSize(360, 25)
			scrollFrame:addItem(categoryTitle)
			
			for key, taskType in ipairs(missingFeatures) do
				local taskSelection = gui.create("TaskTypeSelection")
				
				taskSelection:setProject(self.engine)
				taskSelection:setFeatureID(taskType.id)
				taskSelection:setFont(fonts.get("pix20"))
				taskSelection:setText(taskType.display)
				taskSelection:setSize(360, 20)
				scrollFrame:addItem(taskSelection)
			end
		end
	end
	
	local begin = gui.create("BeginProjectButton", frame)
	
	begin:setSize(200, 28)
	begin:setFont(fonts.get("pix28"))
	begin:setText("Update game engine")
	begin:setDevelopmentType(engine.DEVELOPMENT_TYPE.NEW)
	begin:setProject(self.engine)
	begin:setY(606)
	begin:centerX()
end

gui.register("SelectEngineToUpdateButton", selectEngine, "Button")
