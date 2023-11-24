local officeInfoButton = {}

officeInfoButton.CATCHABLE_EVENTS = {
	officeBuilding.EVENTS.FINISHED_NAMING
}

function officeInfoButton:init()
	self.descriptionBox = gui.create("GenericDescbox", self)
	
	self.descriptionBox:setShowRectSprites(false)
	self.descriptionBox:overwriteDepth(100)
	self.descriptionBox:setY(_S(2))
	self.descriptionBox:setFadeInSpeed(0)
end

function officeInfoButton:setOffice(office)
	self.office = office
	
	self:updateDescbox()
	self:setHeight(_US(self.descriptionBox:getHeight()))
end

function officeInfoButton:handleEvent(event, officeObject)
	if officeObject == self.office then
		self:updateDescbox()
	end
end

function officeInfoButton:updateDescbox()
	local wrapWidth = 600
	
	self.descriptionBox:removeAllText()
	
	local textLineWidth = self.w - _S(20)
	local textLineHeight = _S(28)
	local textLineHeightMedium = _S(26)
	
	self.descriptionBox:addTextLine(textLineWidth, gui.genericMainGradientColor, textLineHeight, "weak_gradient_horizontal")
	self.descriptionBox:addText(self.office:getName(), "bh24", nil, 7, wrapWidth, {
		{
			width = 26,
			icon = "generic_backdrop",
			x = 2,
			height = 26
		},
		{
			width = 20,
			height = 20,
			y = 0,
			icon = "hud_property",
			x = 5
		}
	})
	
	if not self.office:isPlayerOwned() then
		self.descriptionBox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("BUILDING_COST", "Cost: $COST"), "COST", string.comma(self.office:getCost())), "pix20", game.UI_COLORS.IMPORTANT_1, 4, wrapWidth, {
			{
				width = 26,
				icon = "generic_backdrop",
				x = 2,
				height = 26
			},
			{
				width = 20,
				height = 20,
				y = 0,
				icon = "wad_of_cash",
				x = 5
			}
		})
		self.descriptionBox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("BUILDING_SIZE_IN_TILES", "Size in tiles: TILES"), "TILES", string.comma(self.office:getSizeInTiles())), "pix20", game.UI_COLORS.IMPORTANT_2, 4, wrapWidth, {
			{
				width = 26,
				icon = "generic_backdrop",
				x = 2,
				height = 26
			},
			{
				width = 20,
				height = 20,
				y = 0,
				icon = "booth_small",
				x = 5
			}
		})
		self.descriptionBox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("BUILDING_MAXIMUM_FLOORS", "Max floors: FLOORS"), "FLOORS", self.office:getFloorCount()), "bh20", game.UI_COLORS.IMPORTANT_2, 0, wrapWidth, {
			{
				width = 26,
				icon = "icon_floors",
				x = 2,
				height = 26
			}
		})
	else
		self.descriptionBox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("MONTHLY_EXPENSES", "Monthly expenses: $EXPENSES"), "EXPENSES", string.comma(self.office:getMonthlyCostAmount())), "pix22", game.UI_COLORS.IMPORTANT_2, 4, wrapWidth, {
			{
				width = 26,
				icon = "generic_backdrop",
				x = 2,
				height = 26
			},
			{
				width = 20,
				height = 20,
				y = 0,
				icon = "wad_of_cash_minus",
				x = 5
			}
		})
		self.descriptionBox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(self.office:getFloorsText(), "bh20", game.UI_COLORS.IMPORTANT_2, 4, wrapWidth, {
			{
				width = 26,
				icon = "icon_floors",
				x = 2,
				height = 26
			}
		})
		self.descriptionBox:addTextLine(textLineWidth, gui.genericGradientColor, textLineHeight, "weak_gradient_horizontal")
		self.descriptionBox:addText(_format(_T("EMPLOYEES_WITHIN", "Employees within: EMPLOYEES"), "EMPLOYEES", #self.office:getEmployees()), "pix22", game.UI_COLORS.IMPORTANT_2, 0, wrapWidth, {
			{
				width = 26,
				icon = "generic_backdrop",
				x = 2,
				height = 26
			},
			{
				width = 20,
				height = 20,
				y = 0,
				icon = "employees",
				x = 5
			}
		})
		
		for key, affectorData in ipairs(studio.driveAffectors.registered) do
			if not affectorData:isEnoughOf(self.office) then
				local text = affectorData:getNotEnoughText()
				
				if text then
					if key ~= 1 then
						self.descriptionBox:addSpaceToNextText(3)
					end
					
					self.descriptionBox:addTextLine(textLineWidth, game.UI_COLORS.LIGHT_RED, textLineHeightMedium, "weak_gradient_horizontal")
					self.descriptionBox:addText(text, "bh22", game.UI_COLORS.LIGHT_RED, 0, wrapWidth, "exclamation_point_red", 24, 24)
				end
			end
		end
	end
end

function officeInfoButton:fillInteractionComboBox(combobox)
	self.office:fillInteractionComboBox(combobox)
end

function officeInfoButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if interactionController:attemptHide(self) then
			return 
		end
		
		local comboBox = gui.create("ComboBox")
		
		comboBox:setPos(x - _S(20), y - _S(10))
		
		comboBox.baseButton = self
		
		comboBox:setDepth(150)
		comboBox:setAutoCloseTime(0.5)
		interactionController:setInteractionObject(self, nil, nil, true)
	end
end

function officeInfoButton:draw(w, h)
end

gui.register("OfficeInfoButton", officeInfoButton, "Button")
