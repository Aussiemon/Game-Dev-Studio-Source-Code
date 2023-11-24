local roleScroll = {}

function roleScroll:init()
	self.itemsByEmployeeRole = {}
	self.hiddenEmployeeItems = {}
	
	for key, roleData in ipairs(attributes.profiler.roles) do
		self.itemsByEmployeeRole[roleData.id] = {}
	end
end

function roleScroll:addEmployeeItem(element, skipInsertion)
	table.insert(self.itemsByEmployeeRole[element:getEmployee():getRole()], element)
	
	element._EMPLOYEE_ITEM = true
	element._IN_LIST = true
	
	if not skipInsertion then
		self:addItem(element)
	end
end

function roleScroll:accountEmployeeItem(element)
	table.insert(self.itemsByEmployeeRole[element:getEmployee():getRole()], element)
	
	element._EMPLOYEE_ITEM = true
end

function roleScroll:addItem(item, position)
	roleScroll.baseClass.addItem(self, item, position)
	
	if item._EMPLOYEE_ITEM and not item._IN_LIST then
		table.insert(self.itemsByEmployeeRole[item:getEmployee():getRole()], item)
		
		item._IN_LIST = true
	end
end

function roleScroll:_removeItem(item, index)
	local result = roleScroll.baseClass._removeItem(self, item, index)
	
	if item._EMPLOYEE_ITEM and not self.disabledItems[item] then
		table.removeObject(self.itemsByEmployeeRole[item:getEmployee():getRole()], item)
		
		item._IN_LIST = false
	end
	
	return result
end

function roleScroll:getEmployeesItemsOfRole(role)
	return self.itemsByEmployeeRole[role]
end

function roleScroll:enableItem(item)
	if not self.hiddenEmployeeItems[item] then
		return roleScroll.baseClass.enableItem(self, item)
	end
	
	return false
end

function roleScroll:hideEmployeeRole(role)
	for key, item in ipairs(self.itemsByEmployeeRole[role]) do
		self:disableItem(item)
		
		self.hiddenEmployeeItems[item] = true
	end
end

function roleScroll:showEmployeeRole(role)
	for key, item in ipairs(self.itemsByEmployeeRole[role]) do
		self.hiddenEmployeeItems[item] = nil
		
		self:enableItem(item)
	end
	
	self:queueEverything()
end

function roleScroll:setRoleFilterList(list)
	self.roleList = list
end

function roleScroll:kill()
	roleScroll.baseClass.kill(self)
	self.roleList:kill()
end

function roleScroll:hide()
	roleScroll.baseClass.hide(self)
	self.roleList:hide()
end

function roleScroll:show()
	roleScroll.baseClass.show(self)
	self.roleList:show()
end

gui.register("RoleScrollbarPanel", roleScroll, "ScrollbarPanel")
