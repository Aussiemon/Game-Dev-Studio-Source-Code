local rentScroll = {}

rentScroll.SERVER_RACK_CLASS = "server_rack"

function rentScroll:init()
	self.elementsByLevel = {}
	self.elementByLevel = {}
	self.levelOrder = {}
end

local function sortByLevel(a, b)
	return a < b
end

function rentScroll:buildLevelCounters()
	local class = rentScroll.SERVER_RACK_CLASS
	local latestLevel = objects.getClassData(rentScroll.SERVER_RACK_CLASS):getLatestProgression()
	local outdated = false
	
	for key, office in ipairs(studio:getOwnedBuildings()) do
		local objects = office:getObjectsByClass(class)
		
		if objects then
			for key, object in ipairs(objects) do
				local level = object:getProgression()
				
				if not self.elementsByLevel[level] then
					self.elementsByLevel[level] = {}
					self.levelOrder[#self.levelOrder + 1] = level
				end
				
				if level < latestLevel then
					outdated = true
				end
				
				table.insert(self.elementsByLevel[level], object)
			end
		end
	end
	
	table.sort(self.levelOrder, sortByLevel)
	
	local elementList = self.elementsByLevel
	
	if outdated then
		self.outdatedCategory = gui.create("Category")
		
		self.outdatedCategory:setFont("bh24")
		self.outdatedCategory:setText(_T("OUTDATED_SERVER_RACKS", "Outdated server racks"))
		self.outdatedCategory:assumeScrollbar(self)
		self:addItem(self.outdatedCategory)
	end
	
	self.serversCategory = gui.create("Category")
	
	self.serversCategory:setFont("bh24")
	self.serversCategory:setText(_T("SERVER_RACKS", "Server racks"))
	self.serversCategory:assumeScrollbar(self)
	self:addItem(self.serversCategory)
	
	self.outdatedElementCount = 0
	
	for key, level in ipairs(self.levelOrder) do
		local objectList = elementList[level]
		local objectCount = #objectList
		local element = gui.create("ServerUpgradeElement")
		
		element:setSize(200, 70)
		element:setObjectList(objectList)
		element:createUpgradeButton(latestLevel <= level)
		
		if level < latestLevel then
			self.outdatedCategory:addItem(element, true)
			
			self.outdatedElementCount = self.outdatedElementCount + 1
		else
			self.serversCategory:addItem(element, true)
		end
		
		self.elementByLevel[level] = element
	end
end

function rentScroll:handleEvent(event, object, prevLevel)
	local uiObject = self.elementByLevel[prevLevel]
	local newLevel = object:getProgression()
	local otherElement = self.elementByLevel[newLevel]
	
	if #uiObject:getObjectList() == 0 then
		uiObject:killUpgradeButton()
		
		self.elementByLevel[prevLevel] = nil
		self.outdatedElementCount = self.outdatedElementCount - 1
		
		if not otherElement then
			self.elementByLevel[newLevel] = uiObject
			
			uiObject:setObjectList({
				object
			})
			self.serversCategory:addItem(uiObject, true)
		else
			uiObject:kill()
			otherElement:addToObjectList(object)
		end
	elseif otherElement then
		otherElement:addToObjectList(object)
	else
		local element = gui.create("ServerUpgradeElement")
		
		element:setSize(200, 70)
		element:setObjectList({
			object
		})
		element:createUpgradeButton(false)
		self.serversCategory:addItem(element, true)
		
		self.elementByLevel[newLevel] = element
	end
	
	if self.outdatedElementCount == 0 then
		self.outdatedCategory:kill()
		
		self.outdatedCategory = nil
	end
end

gui.register("ServerRentingScrollbarPanel", rentScroll, "ScrollbarPanel")
