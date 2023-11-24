local roleSearchButton = {}

function roleSearchButton.selectRoleCallback(option)
	option.mainElement:setRole(option.roleID)
end

function roleSearchButton:setSearchData(data)
	self.searchData = data
end

function roleSearchButton:setRole(id)
	self.selectedRole = id
	self.searchData.role = id
	
	self:updateText()
	self:queueSpriteUpdate()
	events:fire(employeeCirculation.EVENTS.ADJUSTED_SEARCH_PARAMETER, self.searchData)
end

function roleSearchButton:updateText()
	if self.selectedRole then
		self:setText(attributes.profiler.rolesByID[self.selectedRole].display)
	else
		self:setText(_T("SELECT_ROLE", "Select role"))
	end
end

function roleSearchButton:updateTextPosition()
	self.textX = self.h + _S(3)
end

function roleSearchButton:onClick(x, y, key)
	if interactionController:attemptHide(self) then
		return 
	end
	
	local localX, localY = self:getPos(true)
	
	interactionController:setInteractionObject(self, localX, localY + self.h, true)
	
	local comboBox = interactionController:getComboBox()
	
	comboBox:setWidth(self.w)
	comboBox:scaleToWidestOption(true)
end

function roleSearchButton:updateSprites()
	roleSearchButton.baseClass.updateSprites(self)
	
	if self.selectedRole then
		self.roleSprite = self:allocateSprite(self.roleSprite, attributes.profiler.rolesByID[self.selectedRole].roleIcon, _S(3), _S(3), 0, self.rawH - 6, self.rawH - 6, 0, 0, -0.1)
	else
		self.roleSprite = self:allocateSprite(self.roleSprite, "question_mark", _S(3), _S(3), 0, self.rawH - 6, self.rawH - 6, 0, 0, -0.1)
	end
end

function roleSearchButton:fillInteractionComboBox(combobox)
	for key, roleData in ipairs(attributes.profiler.roles) do
		if not roleData.invisible and not employeeCirculation:isSearchingForRole(roleData.id) then
			local option = combobox:addOption(0, 0, 0, 24, roleData.display, fonts.get("pix20"), self.selectRoleCallback)
			
			option.roleID = roleData.id
			option.mainElement = self
		end
	end
end

gui.register("RoleSearchSelectionButton", roleSearchButton, "Button")

roleSearchButton.alignment = roleSearchButton.RIGHT
