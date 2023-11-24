local objectInfoDescbox = {}

objectInfoDescbox.backgroundColor = color(0, 0, 0, 150)
objectInfoDescbox._scaleIcons = false

function objectInfoDescbox:setObject(object)
	self:removeAllText()
	
	self.object = object
	
	self:updateDescbox()
end

function objectInfoDescbox:updateDescbox(clear)
	if not self.object then
		return 
	end
	
	if clear then
		self:removeAllText()
	end
	
	self.object:setupMouseOverDescbox(self, 300)
end

function objectInfoDescbox:canShow()
	return self.object ~= nil
end

function objectInfoDescbox:getObject()
	return self.object
end

function objectInfoDescbox:clear()
	self.object = nil
	self.alpha = 0
end

function objectInfoDescbox:think()
	objectInfoDescbox.baseClass.think(self)
	
	local object = self.object
	local oldX, oldY = self.x, self.y
	local x, y = objectSelector:adjustMouseOverPosition(object:getPos())
	
	if oldX ~= x or oldY ~= y then
		self:setPos(x, y)
	end
end

function objectInfoDescbox:kill()
	objectInfoDescbox.baseClass.kill(self)
	self:clear()
end

gui.register("ObjectInfoDescbox", objectInfoDescbox, "GenericDescbox")
