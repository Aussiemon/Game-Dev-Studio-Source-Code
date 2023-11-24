local statsOverview = {}

function statsOverview:setEmployee(employee)
	self:removeAllText()
	
	self.employee = employee
	
	local attributeLevels = employee:getAttributes()
	local wrapWidth = 300
	
	for key, attrData in ipairs(attributes.registered) do
		self:addText(_format(_T("ATTRIBUTE_LEVEL", "ATTRIBUTE Lv. LEVEL"), "ATTRIBUTE", attrData.display, "LEVEL", attributeLevels[attrData.id]), "bh20", nil, 0, wrapWidth, {
			{
				width = 24,
				height = 24,
				y = 0,
				icon = "profession_backdrop",
				x = 0
			},
			{
				width = 22,
				height = 22,
				y = 1,
				x = 1,
				icon = attrData.icon
			}
		})
	end
	
	local interestList = employee:getInterests()
	local showThoroughInfo = employee:canShowThoroughInfo()
	
	if #interestList > 0 then
		self:addSpaceToNextText(5)
		
		if showThoroughInfo then
			self:addText(_T("EMPLOYEE_INTERESTS", "Interests"), "bh22", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, wrapWidth)
			
			for key, interestID in ipairs(interestList) do
				local data = interests.registeredByID[interestID]
				
				self:addText(data.display, "pix20", nil, 0, wrapWidth, data:getIconConfig(22, 20))
			end
		else
			local text = #interestList == 1 and _T("EMPLOYEE_ONE_INTEREST") or _format(_T("EMPLOYEE_MULTIPLE_INTERESTS", "INTERESTS Interests"), "INTERESTS", #interestList)
			
			self:addText(text, "pix20", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 0, wrapWidth)
		end
	end
	
	local traits = employee:getTraits()
	
	if #traits > 0 then
		self:addSpaceToNextText(5)
		
		local text = #traits == 1 and _T("EMPLOYEE_ONE_TRAIT", "1 Trait") or _format(_T("EMPLOYEE_MULTIPLE_TRAITS", "TRAITS Traits"), "TRAITS", #traits)
		
		self:addText(text, "pix20", game.UI_COLORS.CATEGORY_SEPARATOR_COLOR, 5, wrapWidth)
	end
	
	self:queueSpriteUpdate()
	self:show()
end

function statsOverview:canShow()
	return self.employee ~= nil
end

function statsOverview:removeEmployee()
	self.employee = nil
	
	self:removeAllText()
	self:hide()
end

gui.register("EmployeeStatsOverview", statsOverview, "GenericDescbox")
