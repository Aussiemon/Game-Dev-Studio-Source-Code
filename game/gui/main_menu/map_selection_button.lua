local mapSelectButton = {}

function mapSelectButton:setGametypeData(data)
	self.gametypeData = data
end

function mapSelectButton:setMapConfig(list)
	self.mapConfig = list
end

function mapSelectButton:onSelectOptionCallback()
	self.tree.baseButton:setSelectedMap(self.configKey)
end

function mapSelectButton:fillInteractionComboBox(comboBox)
	comboBox.baseButton = self
	
	for key, data in ipairs(self.mapConfig) do
		local option = comboBox:addOption(0, 0, self.rawW, 18, data.name, fonts.get("pix20"), mapSelectButton.onSelectOptionCallback)
		
		option.configKey = key
	end
	
	local x, y = self:getPos(true)
	
	comboBox:setPos(x, y + self.h)
end

function mapSelectButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		interactionController:startInteraction(self, 0, 0)
	end
end

function mapSelectButton:setSelectedMap(mapID)
	self.gametypeData:setSelectedMap(mapID)
	self:updateText()
end

function mapSelectButton:updateText()
	local mapConfigIndex = self.gametypeData:getSelectedMap()
	
	if mapConfigIndex then
		self:setText(_format(_T("SELECTED_MAP", "Map: MAP"), "MAP", self.gametypeData:getMapConfigs()[mapConfigIndex].name))
	else
		self:setText(_T("SELECT_MAP", "Select map"))
	end
end

gui.register("MapSelectionButton", mapSelectButton, "Button")
