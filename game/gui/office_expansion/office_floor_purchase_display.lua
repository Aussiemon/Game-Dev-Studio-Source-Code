local officeFloorPurchaseDisplay = {}

officeFloorPurchaseDisplay.iconOffset = 2
officeFloorPurchaseDisplay.baseOffset = 2
officeFloorPurchaseDisplay.iconSize = 32
officeFloorPurchaseDisplay.skinPanelFillColor = color(0, 0, 0, 200)
officeFloorPurchaseDisplay.skinPanelHoverColor = game.UI_COLORS.GREEN:duplicate()
officeFloorPurchaseDisplay.skinPanelHoverColor.a = 200
officeFloorPurchaseDisplay.skinTextFillColor = color(255, 255, 255, 255)
officeFloorPurchaseDisplay.skinTextHoverColor = color(255, 255, 255, 255)
officeFloorPurchaseDisplay.textShadowFillColor = color(0, 0, 0, 255)
officeFloorPurchaseDisplay.textShadowHoverColor = color(0, 0, 0, 255)
officeFloorPurchaseDisplay.OFFICE_DISPLAY = true
officeFloorPurchaseDisplay._scaleHor = false
officeFloorPurchaseDisplay._scaleVert = false
officeFloorPurchaseDisplay.shouldLimitToScreenspace = false
officeFloorPurchaseDisplay.CATCHABLE_EVENTS = {
	officeBuilding.EVENTS.PURCHASED_FLOOR,
	studio.expansion.EVENTS.LEAVE_EXPANSION_MODE,
	studio.EVENTS.FUNDS_CHANGED,
	studio.EVENTS.FUNDS_SET,
	studio.expansion.EVENTS.EXPANDED_OFFICE
}
officeFloorPurchaseDisplay.canHover = true
officeFloorPurchaseDisplay.mouseOverColor = game.UI_COLORS.GREEN:duplicate()
officeFloorPurchaseDisplay.mouseOverColor.a = 200
officeFloorPurchaseDisplay.regularBackgroundColor = color(0, 0, 0, 200)
officeFloorPurchaseDisplay.backgroundColor = officeFloorPurchaseDisplay.regularBackgroundColor

function officeFloorPurchaseDisplay:init()
	self.confirmClick = false
end

function officeFloorPurchaseDisplay:bringUp()
	self:setDepth(100)
end

function officeFloorPurchaseDisplay:think()
	officeFloorPurchaseDisplay.baseClass.think(self)
	self:setPos(camera:getLocalMousePosition(self.floorX - self.w * 0.5, self.floorY))
end

function officeFloorPurchaseDisplay:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT and not frameController:preventsMouseOver() and studio:getFunds() >= self.office:getFloorPurchaseCost(self.office:getPurchasedFloors() + 1) then
		if not self.confirmClick then
			self.confirmClick = true
			
			self:setupText()
		else
			self.office:purchaseFloor()
			camera:setViewFloor(self.office:getPurchasedFloors())
			
			self.confirmClick = false
			
			if self.office:canPurchaseFloor() then
				self:setupText()
			else
				self:kill()
			end
		end
	end
end

function officeFloorPurchaseDisplay:onKill()
	self.office:setOfficeFloorPurchaseDisplay(nil)
end

function officeFloorPurchaseDisplay:onMouseEntered()
	self:setBackgroundColor(self.mouseOverColor)
	self:queueSpriteUpdate()
end

function officeFloorPurchaseDisplay:onMouseLeft()
	self:setBackgroundColor(self.regularBackgroundColor)
	self:queueSpriteUpdate()
	
	self.confirmClick = false
	
	self:setupText()
end

function officeFloorPurchaseDisplay:setOffice(office)
	self.office = office
	
	self:setupPosition()
	self:setupText()
end

function officeFloorPurchaseDisplay:setupPosition()
	self.floorX, self.floorY = self.office:getFloorUpgradeCoords()
	self.floorY = self.floorY + _S(40)
end

function officeFloorPurchaseDisplay:handleEvent(event, obj)
	if event == officeBuilding.EVENTS.PURCHASED_FLOOR then
		if obj == self.office and not obj:canPurchaseFloor() then
			self:kill()
		end
	elseif event == studio.EVENTS.FUNDS_CHANGED or event == studio.EVENTS.FUNDS_SET then
		self:setupText()
	elseif event == studio.expansion.EVENTS.EXPANDED_OFFICE then
		self:setupPosition()
	else
		self:kill()
	end
end

function officeFloorPurchaseDisplay:setupText()
	self:removeAllText()
	self:addText(_T("OFFICE_PURCHASE_FLOOR", "+1 Building floor"), "bh_world22", nil, 4, 300, "level_up", 22, 22)
	
	local cost = self.office:getFloorPurchaseCost(self.office:getPurchasedFloors() + 1)
	
	self:addText(_format("$COST", "COST", string.comma(cost)), "bh_world20", cost <= studio:getFunds() and game.UI_COLORS.LIGHT_BLUE or game.UI_COLORS.RED, 0, 300, "wad_of_cash_minus", 22, 22)
	
	if self.confirmClick then
		self:addSpaceToNextText(10)
		self:addText(_T("OFFICE_PURCHASE_FLOOR_CONFIRM", "Click to confirm"), "bh_world22", nil, 0, 300, "exclamation_point", 22, 22)
	end
end

gui.register("OfficeFloorPurchaseDisplay", officeFloorPurchaseDisplay, "GenericDescbox")
