local roleFiltererList = {}

function roleFiltererList:setScroller(scrollerObject)
	self.scroller = scrollerObject
end

function roleFiltererList:getScroller()
	return self.scroller
end

function roleFiltererList:shouldHideRoles(roleID)
	for key, child in ipairs(self.children) do
		if child:getRole() ~= roleID and child:isRoleDisplayed() then
			return true
		end
	end
	
	return false
end

function roleFiltererList:showEmployeesOfRole(roleID)
	self.scroller:showEmployeeRole(roleID)
	
	for key, child in ipairs(self.children) do
		local childRole = child:getRole()
		
		if childRole == roleID then
			if not child:isRoleDisplayed() then
				child:changeRoleState(true)
			end
		elseif child:isRoleDisplayed() then
			self.scroller:hideEmployeeRole(childRole)
			child:changeRoleState(false)
		end
	end
end

function roleFiltererList:hideEmployeesOfRole(roleID)
	self.scroller:hideEmployeeRole(roleID)
	
	for key, child in ipairs(self.children) do
		local childRole = child:getRole()
		
		if childRole == roleID then
			if child:isRoleDisplayed() then
				child:changeRoleState(false)
			end
		elseif not child:isRoleDisplayed() then
			self.scroller:showEmployeeRole(childRole)
			child:changeRoleState(true)
		end
	end
end

function roleFiltererList:showEmployeeRole(roleID)
	self.scroller:showEmployeeRole(roleID)
end

function roleFiltererList:hideEmployeeRole(roleID)
	self.scroller:hideEmployeeRole(roleID)
end

gui.register("RoleFiltererList", roleFiltererList, "TitledList")
