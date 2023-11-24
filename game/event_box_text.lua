eventBoxText = {}
eventBoxText.registered = {}
eventBoxText.registeredByID = {}

local defaultEventBoxTextFuncs = {}

defaultEventBoxTextFuncs.mtindex = {
	__index = defaultEventBoxTextFuncs
}

function defaultEventBoxTextFuncs:getText(data)
	return self.text
end

function defaultEventBoxTextFuncs:fillInteractionComboBox(combobox, uiElement)
end

function defaultEventBoxTextFuncs:save(data)
	local savedData = self:saveData(data)
	
	return {
		id = self.id,
		data = savedData
	}
end

function defaultEventBoxTextFuncs:saveData(data)
	return data
end

function defaultEventBoxTextFuncs:load(targetElement, data)
	targetElement:setTextID(data.id)
	targetElement:setData(self:loadData(targetElement, data.data))
end

function defaultEventBoxTextFuncs:loadData(targetElement, data)
	return data
end

function eventBoxText:registerNew(data, inherit)
	table.insert(eventBoxText.registered, data)
	
	eventBoxText.registeredByID[data.id] = data
	
	if inherit then
		local class = eventBoxText.registeredByID[inherit]
		
		data.baseClass = class
		
		setmetatable(data, class.mtindex)
	else
		data.baseClass = defaultEventBoxTextFuncs
		
		setmetatable(data, defaultEventBoxTextFuncs.mtindex)
	end
	
	data.mtindex = {
		__index = data
	}
end
