local attr = {}

attr.pinGap = 2
attr.pinWidth = 3
attr.pinHeight = 10
attr.buttonSize = 200

function attr:init()
	attr.font = fonts.get("pix20")
	
	self:setFont(attr.font)
end

function attr:setFont(font)
	self.font = font
	self.fontHeight = self.font:getHeight()
end

function attr:setEmployee(employee)
	self.employee = employee
end

function attr:getEmployee()
	return self.employee
end

function attr:setAttribute(attr)
	self.attribute = attr
end

function attr:getAttribute()
	return self.attribute
end

function attr:setSize(x, y)
	attr.baseClass.setSize(self, x, y)
	
	self.pinHeight = y - 8
end

function attr:createUpgradeButton()
	local w, h = self:getRawSize()
	
	self.upgradeButton = gui.create("AttributeUpgradeButton", self)
	
	self.upgradeButton:setSize(200, h - 2)
	self.upgradeButton:setPos(_S(w - 200 - 1), _S(1))
	self.upgradeButton:setFont(fonts.get("pix20"))
	self.upgradeButton:setBaseButton(self)
end

function attr:draw(w, h)
	love.graphics.setColor(80, 80, 80, 255)
	love.graphics.rectangle("fill", 0, 0, w, h)
	
	local x, y = 0, 0
	local attributeData = attributes.registeredByID[self.attribute]
	local curAttribute = self.employee:getAttributes()[self.attribute]
	local baseY = y
	
	love.graphics.setFont(self.font)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(attributeData.display, x + 5, baseY)
	
	local size = self.font:getWidth(curAttribute)
	
	love.graphics.print(curAttribute, x + 140 - size, baseY)
	love.graphics.setColor(50, 50, 50, 255)
	love.graphics.rectangle("fill", 144, (h - self.pinHeight) / 2, (attr.pinWidth + attr.pinGap) * 10, self.pinHeight)
	love.graphics.setColor(175, 230, 175, 255)
	
	local pinY = (h - self.pinHeight + 2) / 2
	
	for i = 1, curAttribute do
		local iter = i - 1
		local pinX = x + 145 + (attr.pinGap + attr.pinWidth) * iter
		
		love.graphics.rectangle("fill", pinX, pinY, attr.pinWidth, self.pinHeight - 2)
	end
end

gui.register("AttributeDisplay", attr)
