local invisRoleFilter = {}

invisRoleFilter._propagateScalingState = false

function invisRoleFilter:createElements(elemSize)
	for key, role in ipairs(attributes.profiler.roles) do
		local elem = gui.create("CircleRoleFilter", self)
		
		elem:setScaler(self.scaler)
		elem:setSize(elemSize, elemSize)
		elem:setRole(role.id)
	end
end

function invisRoleFilter:updateLayout()
	local elemSpacing = _S(5)
	local y = elemSpacing
	local maxW = 0
	local xOff = _S(3)
	
	for key, child in ipairs(self.children) do
		child:setPos(xOff, y)
		
		maxW = math.max(child.w, maxW)
		y = y + elemSpacing + child.h
	end
	
	self:setSize(maxW + xOff * 2 + _S(30), y)
end

function invisRoleFilter:think()
end

function invisRoleFilter:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 100)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.3)
end

function invisRoleFilter:draw(w, h)
end

gui.register("InvisibleRoleFilter", invisRoleFilter, "RoleFiltererList")
