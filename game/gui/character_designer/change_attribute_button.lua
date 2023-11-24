local changeAttribute = {}

changeAttribute.mouseOverColor = color(255, 255, 255, 255)
changeAttribute.mouseNotOverColor = color(140, 140, 140, 255)

function changeAttribute:setDirection(dir)
	self.direction = dir
end

function changeAttribute:onClick(x, y, key)
	local parent = self:getParent()
	local employee = parent:getEmployee()
	local attribute = parent:getAttributeID()
	
	characterDesigner:changeAttribute(attribute, self.direction)
end

function changeAttribute:onMouseEntered()
	self:queueSpriteUpdate()
end

function changeAttribute:onMouseLeft()
	self:queueSpriteUpdate()
end

function changeAttribute:updateSprites()
	local clr = self:isMouseOver() and self.mouseOverColor or self.mouseNotOverColor
	local x, sizeX, quad
	
	if self.direction < 0 then
		x = self.w
		sizeX = -self.rawW
		quad = "decrease"
	else
		x = 0
		sizeX = self.rawW
		quad = "increase"
	end
	
	self:setNextSpriteColor(clr:unpack())
	
	self.iconSprite = self:allocateSprite(self.iconSprite, quad, x, 0, 0, sizeX, self.rawH, 0, 0, 0.1)
end

gui.register("ChangeAttributeButton", changeAttribute)
