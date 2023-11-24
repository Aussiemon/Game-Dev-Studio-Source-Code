local buffer = {}

function buffer:setComboBoxOptions(options)
	self.comboBoxOptions = options
end

function buffer:getComboBoxOptions()
	return self.comboBoxOptions
end

function buffer:addComboBoxOption(...)
	self.comboBoxOptions = self.comboBoxOptions or {}
	
	for iter = 1, select("#", ...) do
		local cur = select(iter, ...)
		
		self.comboBoxOptions[cur] = true
	end
end

function buffer:hasComboBoxOption(option)
	if not self.comboBoxOptions then
		return false
	end
	
	return self.comboBoxOptions[option]
end

function buffer:clearComboBoxOptions()
	table.clear(self.comboBoxOptions)
end

gui.register("ComboBoxOptionBuffer", buffer, "Button")
