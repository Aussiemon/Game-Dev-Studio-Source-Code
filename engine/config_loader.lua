configLoader = {}
configLoader.curText = {}
configLoader.associatedSaving = {}
configLoader.associatedLoading = {}
configLoader.loadCallback = nil

function configLoader:writeFile(file, initialText, postLimitText, settingLibraries, settingLimits)
	local totalSettings = 0
	
	for key, value in pairs(settingLibraries) do
		for key2, value2 in ipairs(value) do
			totalSettings = totalSettings + 1
		end
	end
	
	table.clear(self.curText)
	
	local gl = _G
	
	if initialText then
		if type(initialText) == "table" then
			self:addText(unpack(initialText))
		else
			self:addText(initialText)
		end
	end
	
	for k, v in pairs(settingLibraries) do
		for k2, v2 in ipairs(v) do
			local l = settingLimits and settingLimits[v2]
			
			if l then
				self:addText(final, "// ", k, ".", v2, " <", l.min, " - ", l.max, ">\n")
			else
				self:addText(final, "// ", k, ".", v2, "<undefined>\n")
			end
		end
		
		self:addText("\n")
	end
	
	if postLimitText then
		if type(postLimitText) == "table" then
			self:addText(unpack(postLimitText))
		else
			self:addText(postLimitText)
		end
	end
	
	local cur = 0
	
	for k, v in pairs(settingLibraries) do
		for k2, v2 in ipairs(v) do
			cur = cur + 1
			
			local writeValue
			
			if gl[k] then
				writeValue = gl[k][v2]
			end
			
			writeValue = configLoader:attemptSaveCallback(k, v2) or writeValue
			
			if cur < totalSettings then
				self:addText(final, k, ".", v2, "=", writeValue, "\n")
			else
				self:addText(final, k, ".", v2, "=", writeValue)
			end
		end
	end
	
	love.filesystem.write(file, table.concat(self.curText, ""))
end

function configLoader:setLoadCallback(func)
	self.loadCallback = func
end

function configLoader:isReading()
	return self.reading
end

function configLoader:readFile(file, settingLimits)
	self.reading = true
	
	local data = love.filesystem.read(file)
	
	if not data then
		return false
	end
	
	local gl = _G
	
	data = string.gsub(data, "//.-\n", "")
	
	local sep = string.explode(data, "\n")
	local finalData = {}
	
	for k, v in pairs(sep) do
		v = string.explode(v, "=")
		
		local final = string.explode(v[1], "%.")
		local main, sub = final[1], final[2]
		
		if main and sub then
			finalData[main] = finalData[main] or {}
			finalData[main][sub] = v[2]
			
			if gl[main] and gl[main][sub] then
				local result = tonumber(v[2])
				
				if result then
					if settingLimits and settingLimits[sub] then
						local limit = settingLimits[sub]
						
						gl[main][sub] = math.clamp(result, limit.min, limit.max)
					else
						gl[main][sub] = result
					end
				end
			end
			
			self:attemptLoadCallback(main, sub, v[2])
		end
	end
	
	if self.loadCallback then
		self.loadCallback(finalData)
	end
	
	self.reading = false
	
	return true
end

function configLoader:associateSaving(partOne, partTwo, callback)
	configLoader.associatedSaving[partOne .. partTwo] = callback
end

function configLoader:associateLoading(partOne, partTwo, callback)
	configLoader.associatedLoading[partOne .. partTwo] = callback
end

function configLoader:attemptLoadCallback(partOne, partTwo, value)
	local target = partOne .. partTwo
	
	if configLoader.associatedLoading[target] then
		configLoader.associatedLoading[target](value)
	end
end

function configLoader:attemptSaveCallback(partOne, partTwo)
	local target = partOne .. partTwo
	
	if configLoader.associatedSaving[target] then
		return configLoader.associatedSaving[target]()
	end
	
	return nil
end

function configLoader:addText(...)
	for i = 1, select("#", ...) do
		self.curText[#self.curText + 1] = select(i, ...)
	end
end
