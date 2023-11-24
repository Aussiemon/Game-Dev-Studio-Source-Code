local activityParticipant = {}

activityParticipant.skinPanelFillColor = color(86, 104, 135, 255)
activityParticipant.skinPanelHoverColor = color(163, 176, 198, 255)
activityParticipant.skinTextFillColor = color(220, 220, 220, 255)
activityParticipant.skinTextHoverColor = color(255, 255, 255, 255)

function activityParticipant:init()
	activityParticipant.font = fonts.get("pix20")
end

function activityParticipant:setFont(font)
	self.font = font
end

function activityParticipant:setEmployee(employee)
	self.employee = employee
	self.name = self.employee:getFullName(true)
end

function activityParticipant:onMouseEntered()
	self:queueSpriteUpdate()
end

function activityParticipant:onMouseLeft()
	self:queueSpriteUpdate()
end

function activityParticipant:updateSprites()
	local color = self:getStateColor()
	
	self:setNextSpriteColor(gui.genericOutlineColor:unpack())
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
	
	self:setNextSpriteColor(color:unpack())
	
	self.foreSprite = self:allocateSprite(self.foreSprite, "vertical_gradient_75", _S(1), _S(1), 0, self.rawW - 2, self.rawH - 2, 0, 0, -0.1)
end

function activityParticipant:draw(w, h)
	local panelColor, textColor = self:getStateColor()
	
	love.graphics.setFont(self.font)
	love.graphics.printST(self.name, 5, 0, textColor.r, textColor.g, textColor.b, textColor.a, 0, 0, 0, 255)
end

gui.register("ActivityParticipantDisplay", activityParticipant)
