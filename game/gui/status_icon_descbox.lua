local statusIconDesc = {}

statusIconDesc.backgroundColor = color(0, 0, 0, 150)
statusIconDesc._scaleIcons = false

function statusIconDesc:setStatusIconData(data)
	self:removeAllText()
	
	self.data = data
	
	self.data.data:setupDescbox(self.data, self)
end

function statusIconDesc:setEmployee(emp)
	self.employee = emp
end

function statusIconDesc:getEmployee()
	return self.employee
end

function statusIconDesc:clear()
	self.employee = nil
	self.alpha = 0
end

function statusIconDesc:think()
	statusIconDesc.baseClass.think(self)
	
	local data = self.data
	local oldX, oldY = self.x, self.y
	local newX, newY = (data.x + data.quadW + 4 - camera.x) * camera.scaleX, (data.y - camera.y) * camera.scaleY
	
	if oldX ~= newX or oldY ~= newY then
		self:setPos(newX, newY)
	end
end

function statusIconDesc:kill()
	statusIconDesc.baseClass.kill(self)
	self:clear()
end

gui.register("StatusIconDescbox", statusIconDesc, "GenericDescbox")
