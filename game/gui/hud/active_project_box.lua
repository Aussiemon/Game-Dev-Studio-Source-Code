local activeProjectBox = {}

activeProjectBox.SAVED_EVENT_DATA = {}
activeProjectBox.SCROLLBAR_ID = "active_project_box_scrollbar"
activeProjectBox.ADD_ELEMENT_EVENTS = {
	[project.EVENTS.BEGIN_WORK] = true,
	[project.EVENTS.LOADED_PROJECT] = true,
	[project.EVENTS.TEAM_ASSIGNED] = true
}

function activeProjectBox:init()
	self.alpha = 0.4
	self.fadeTime = 0
	
	events:addReceiver(self)
end

function activeProjectBox:initScrollbar()
	self.prevCount = math.huge
	self.scrollBar = gui.create("ActiveProjectScrollbar", self)
	
	self.scrollBar:setID(activeProjectBox.SCROLLBAR_ID)
	self.scrollBar:setAdjustElementPosition(true)
	self.scrollBar:setPadding(4, 4)
	self.scrollBar:setSpacing(4)
	self.scrollBar:setPanelOutlineColor(activeProjectBox.scrollbarColor:unpack())
	self.scrollBar:addDepth(5)
	self.scrollBar:setProjectBox(self)
	self:verifyVisibility()
end

function activeProjectBox:verifyVisibility()
	local items = self.scrollBar:getItems()
	local itemCount = #items
	
	if itemCount > 0 and self.prevCount == 0 then
		self:enableRendering()
	elseif itemCount == 0 and self.prevCount > 0 then
		self:disableRendering()
	end
	
	self.prevCount = itemCount
end

function activeProjectBox:canShow()
	return not game.hudHidden
end

function activeProjectBox:onKill()
	events:removeReceiver(self)
end

function activeProjectBox:hasProjectDisplay(projectObj)
	for key, element in ipairs(self.scrollBar:getItems()) do
		if element:getTargetObject() == projectObj then
			return true
		end
	end
	
	return false
end

function activeProjectBox:getScroller()
	return self.scrollBar
end

function activeProjectBox:handleEvent(event, obj)
	if activeProjectBox.ADD_ELEMENT_EVENTS[event] and obj:hasAtLeastOneTask() and obj:getOwner():isPlayer() then
		self:addElement(obj, event)
	end
end

function activeProjectBox:attemptAddProjectElements()
end

function activeProjectBox:postResolutionChange()
	for key, data in ipairs(self.SAVED_EVENT_DATA) do
		self:addElement(nil, nil, data)
		
		self.SAVED_EVENT_DATA[key] = nil
	end
end

function activeProjectBox:addElement(targetObject, event, elementData, elementClass)
	if elementData then
		targetObject = elementData.targetObject
	end
	
	if self:hasProjectDisplay(targetObject) then
		return 
	end
	
	local element
	
	if elementData then
		element = gui.create(elementData.class)
		
		element:loadData(elementData)
		
		targetObject = elementData.targetObject
	else
		if not elementClass then
			local projType = targetObject:getProjectType()
			
			if projType == "engine_project" then
				elementClass = "ActiveEngineProjectElement"
			elseif projType == "game_project" and not targetObject:getReleaseDate() then
				elementClass = "ActiveGameProjectElement"
			elseif projType == patchProject.PROJECT_TYPE then
				elementClass = "ActivePatchProjectElement"
			end
		end
		
		if not elementClass then
			return 
		end
		
		element = gui.create(elementClass)
	end
	
	if not element then
		return 
	end
	
	local scroll = self.scrollBar
	
	element:setEventBox(self)
	element:setFont(activeProjectBox.font)
	element:setWidth(_US(scroll:getWidth()) - 8)
	element:setTargetObject(targetObject)
	element:setElementBox(self)
	element:addDepth(1)
	scroll:addItem(element)
	
	if scroll:requiresScroller(element) then
		self:readjustElementSize(_US(scroll:getWidth()) - 8 - scroll:getScrollerSize())
	else
		self:readjustElementSize(_US(scroll:getWidth()) - 8)
	end
	
	scroll:buildActiveObjectList()
	scroll:performLayout()
	scroll:scrollToBottom()
	
	local curItems = scroll:getItems()
	
	if #curItems > activeProjectBox.MAX_DISPLAYED_EVENTS then
		scroll:removeItem(curItems[#curItems])
	end
	
	self:verifyVisibility()
	
	self.fadeTime = curTime + activeProjectBox.TIME_TO_FADE_AFTER_EVENT
	
	return element
end

function activeProjectBox:draw(w, h)
	love.graphics.setColor(0, 0, 0, 100 * self.alpha)
	love.graphics.rectangle("fill", 0, 0, w, h)
end

gui.register("ActiveProjectBox", activeProjectBox, "EventBox")
