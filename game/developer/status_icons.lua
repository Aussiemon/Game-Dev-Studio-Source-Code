statusIcons = {}
statusIcons.registered = {}
statusIcons.registeredByID = {}

local defaultStatusIconFuncs = {}

defaultStatusIconFuncs.mtindex = {
	__index = defaultStatusIconFuncs
}

function defaultStatusIconFuncs:setupText(employee)
	return self.text
end

function defaultStatusIconFuncs:onMouseLeft(data)
	statusIcons.descbox:hide()
	statusIcons.descbox:clear()
end

function defaultStatusIconFuncs:onMouseEntered(data, employee)
	if not statusIcons.descbox or not statusIcons.descbox:isValid() then
		statusIcons.descbox = gui.create("StatusIconDescbox")
	else
		statusIcons.descbox:show()
	end
	
	statusIcons.descbox:setEmployee(employee)
	statusIcons.descbox:setStatusIconData(data)
end

function defaultStatusIconFuncs:handleClick(x, y, key)
end

function defaultStatusIconFuncs:setupDescbox(data, descBox)
	statusIcons.descbox:addText(self:setupText(statusIcons.descbox:getEmployee()), "bh_world22", nil, 0, 300)
end

function defaultStatusIconFuncs:drawMouseOver(data)
end

function statusIcons.register(data, inherit)
	table.insert(statusIcons.registered, data)
	
	statusIcons.registeredByID[data.id] = data
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		local base = statusIcons.registeredByID[inherit]
		
		data.baseClass = base
		
		setmetatable(data, base.mtindex)
	else
		data.baseClass = defaultStatusIconFuncs
		
		setmetatable(data, defaultStatusIconFuncs.mtindex)
	end
end

function statusIcons:getData(id)
	return self.registeredByID[id]
end

statusIcons.register({
	id = "level_up",
	quad = quadLoader:getQuad("level_up"),
	text = _T("STATUS_ICON_LEVEL_UP", "POINTS unspent attribute points"),
	textSingular = _T("STATUS_ICON_LEVEL_UP_SINGULAR", "1 unspent attribute point"),
	setupText = function(self, employee)
		local pts = employee:getAttributePoints()
		
		if pts > 1 then
			return _format(self.text, "POINTS", pts)
		else
			return self.textSingular
		end
	end,
	handleClick = function(self, x, y, key)
		if key == gui.mouseKeys.LEFT then
			local employee = statusIcons.descbox:getEmployee()
			
			if employee then
				employee:createEmployeeMenu()
			end
		end
	end
})
statusIcons.register({
	id = "no_task",
	quad = quadLoader:getQuad("no_task"),
	text = _T("STATUS_ICON_NO_TASK", "Idling (no task)")
})

local crowdedRoom = {
	id = "crowded_room",
	quad = quadLoader:getQuad("crowded_room"),
	text = _T("STATUS_ICON_CROWDED_ROOM", "Crowded room")
}

function crowdedRoom:setupDescbox(data, descBox)
	crowdedRoom.baseClass.setupDescbox(self, data, descBox)
	
	local employee = descBox:getEmployee()
	local drop = math.round((employee:getBaseOverallEfficiency() - descBox:getEmployee():getOverallEfficiency()) * 100, 1)
	
	descBox:addSpaceToNextText(6)
	descBox:addText(_format(_T("CROWDED_ROOM_DEBUFF_DESC", "DEC% lower work efficiency"), "DEC", drop), "bh_world20", game.UI_COLORS.RED, 0, 300, "decrease_red", 24, 24)
end

statusIcons.register(crowdedRoom)

local noBooks = {
	id = "no_books",
	quad = quadLoader:getQuad("crowded_room"),
	text = _T("STATUS_ICON_NO_BOOKS", "No books in room")
}

function noBooks:setupDescbox(data, descBox)
	noBooks.baseClass.setupDescbox(self, data, descBox)
	
	local employee = descBox:getEmployee()
	local traitData = traits:getData("bookworm")
	
	descBox:addSpaceToNextText(6)
	descBox:addText(_format(_T("NO_BOOKS_DEBUFF_DESC", "DEC% faster Drive drop"), "DEC", math.round((traitData.driveLossMultiplier - 1) * 100, 1)), "bh_world20", game.UI_COLORS.RED, 0, 300, "decrease_red", 24, 24)
end

statusIcons.register(noBooks)
