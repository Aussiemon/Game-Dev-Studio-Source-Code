resolutionHandler = {}
resolutionHandler.resolutionList = {}
resolutionHandler.minimumHeight = 600
resolutionHandler.curW = 0
resolutionHandler.curH = 0
resolutionHandler.realW = 0
resolutionHandler.realH = 0
resolutionHandler.fullscreen = false
resolutionHandler.previousScreenModeFlags = {}
resolutionHandler.resolutionRelation = 1
resolutionHandler.SCREEN_MODES = {
	FULLSCREEN = 2,
	WINDOWED = 1,
	BORDERLESS = 4,
	VSYNC = 8
}
resolutionHandler.SCREEN_MODES_COMBOS = {
	WINDOWED = resolutionHandler.SCREEN_MODES.WINDOWED,
	FULLSCREEN = resolutionHandler.SCREEN_MODES.FULLSCREEN,
	WINDOWED_BORDERLESS = resolutionHandler.SCREEN_MODES.WINDOWED + resolutionHandler.SCREEN_MODES.BORDERLESS
}
resolutionHandler.screenModeFlags = {}
resolutionHandler.screenModeNumber = resolutionHandler.SCREEN_MODES_COMBOS.WINDOWED

function resolutionHandler:pullScreenModes(bitNumber)
	bitNumber = bitNumber or self.screenModeNumber
	
	local flags = {}
	
	if self:hasMode(bitNumber, resolutionHandler.SCREEN_MODES.FULLSCREEN) then
		flags.fullscreen = true
	else
		flags.fullscreen = false
	end
	
	if self:hasMode(bitNumber, resolutionHandler.SCREEN_MODES.BORDERLESS) then
		flags.borderless = true
	end
	
	if self.vsync then
		flags.vsync = true
	else
		flags.vsync = false
	end
	
	flags.display = self.display
	
	return flags
end

function resolutionHandler:hasMode(bitNumber, modeNumber)
	return bit.band(bitNumber, modeNumber) == modeNumber
end

function resolutionHandler:buildLists()
	table.clearArray(self.resolutionList)
	
	local w, h = love.window.getDesktopDimensions()
	
	self.mainW = w
	self.mainH = h
	
	for key, mode in ipairs(love.window.getFullscreenModes(self.display or 1)) do
		if mode.height >= resolutionHandler.minimumHeight then
			self.resolutionList[key] = {
				text = self:getResolutionText(mode.width, mode.height),
				width = mode.width,
				height = mode.height
			}
		end
	end
end

function resolutionHandler:getDisplayText(number)
	local dispName = love.window.getDisplayName(number)
	local w, h = love.window.getDesktopDimensions(number)
	
	return _format("NUMBER. DISPLAY (WIDTHxHEIGHT)", "NUMBER", number, "DISPLAY", dispName, "WIDTH", w, "HEIGHT", h)
end

function resolutionHandler:setDisplay(disp, skipApply)
	if disp == self.display then
		return false
	end
	
	self.display = disp
	
	resolutionHandler:buildLists()
	
	local dispMode = self.resolutionList[1]
	
	if self.curW > dispMode.width or self.curH > dispMode.height then
		self:setDesiredResolution(dispMode.width, dispMode.height)
	end
	
	if self.screenModeFlags then
		self.screenModeFlags.display = disp
	end
	
	if not skipApply then
		self:applyScreenMode()
	end
	
	return true
end

function resolutionHandler:getDisplay()
	return self.display or 1
end

function resolutionHandler:setOnScreenModeChanged(callback)
	self.onScreenModeChanged = callback
end

function resolutionHandler:setOnResolutionChanged(callback)
	self.onResolutionChanged = callback
end

function resolutionHandler:setPreResolutionChanged(callback)
	self.preResolutionChanged = callback
end

function resolutionHandler:setVsync(state)
	local oldState = self.vsync
	
	self.vsync = state
	
	return self:setScreenMode()
end

function resolutionHandler:getVsync()
	return self.vsync
end

function resolutionHandler:getIsFullscreen()
	return love.window.getFullscreen()
end

function resolutionHandler:buildFlagTable(flagString)
	local list = {}
	
	for key, flagString in ipairs(flagTable) do
		local separated = string.explode(flagString, "=")
		local flag = separated[1]
		local flagValue = separated[2]
		
		flagValue = tonumber(flagValue) == 1 and true or false
		list[flag] = flagValue
	end
	
	return list
end

function resolutionHandler:areFlagsTheSame(newFlags, oldFlags)
	local different = false
	
	for key, value in pairs(newFlags) do
		if value ~= oldFlags[key] then
			return false
		end
	end
	
	for key, value in pairs(oldFlags) do
		if value ~= newFlags[key] then
			return false
		end
	end
	
	return true
end

function resolutionHandler:canSetScreenMode(w, h, newFlags, oldFlags)
	local sameRes, sameFlags = false, false
	
	if self.curW == 0 or self.curH == 0 then
		self.curW = w
		self.curH = h
		self.realW = scrW
		self.realH = scrH
		self.initialSet = true
	end
	
	if self.curW == w and self.curH == h then
		sameRes = true
	end
	
	if self.screenModeFlags and self:areFlagsTheSame(newFlags, oldFlags) then
		sameFlags = true
	end
	
	return not sameRes or not sameFlags
end

function resolutionHandler:setScreenMode(flags)
	flags = flags or self.screenModeNumber
	
	if self.vsync and not self:hasMode(flags, resolutionHandler.SCREEN_MODES.VSYNC) then
		flags = flags + resolutionHandler.SCREEN_MODES.VSYNC
	end
	
	local newFlags = self:pullScreenModes(flags)
	
	if not self:canSetScreenMode(self.curW, self.curH, newFlags, self.screenModeFlags) then
		return false
	end
	
	self.previousScreenModeFlags = self.screenModeFlags
	self.screenModeFlags = newFlags
	self.previousScreenModeNumber = self.screenModeNumber
	self.screenModeNumber = flags
	self.lastW = self.curW
	self.lastH = self.curH
	
	return true
end

function resolutionHandler:getScreenModeNumber()
	return self.screenModeNumber
end

function resolutionHandler:setDesiredResolution(w, h)
	if not self:canSetScreenMode(w, h, self.screenModeFlags, self.screenModeFlags) then
		return false
	end
	
	self.lastW = self.curW
	self.lastH = self.curH
	self.curW = w
	self.curH = h
	self.previousScreenModeNumber = self.screenModeNumber
	
	return true
end

function resolutionHandler:getDesiredResolution()
	if self.curW == 0 or self.curH == 0 then
		self.curW = scrW
		self.curH = scrH
		self.realW = scrW
		self.realH = scrH
	end
	
	return self.curW, self.curH
end

function resolutionHandler:getPreviousResolution()
	return self.lastW, self.lastH
end

function resolutionHandler:getRealScreenResolution()
	return self.realW, self.realH
end

function resolutionHandler:applyScreenMode()
	gui.preResolutionChanged()
	
	local diffRes = false
	
	if not self.initialSet then
		diffRes = self.lastW ~= self.curW or self.lastH ~= self.curH
	else
		diffRes = true
		self.initialSet = false
	end
	
	local diffScreen = not self:areFlagsTheSame(self.screenModeFlags, self.previousScreenModeFlags)
	
	if self.preResolutionChanged then
		self.preResolutionChanged()
	end
	
	love.window.setMode(self.curW, self.curH, self.screenModeFlags)
	
	self.realW, self.realH = love.graphics.getWidth(), love.graphics.getHeight()
	self.resolutionRelation = self.realW / self.realH
	
	fonts.recreateFonts()
	
	if self.onResolutionChanged and diffRes then
		self.onResolutionChanged(self.curW, self.curH)
	end
	
	if self.onScreenModeChanged and diffScreen then
		self.onScreenModeChanged()
	end
	
	self.vsync = select(3, love.window.getMode()).vsync
	
	gui.postResolutionChanged()
end

function resolutionHandler:getResolutionList()
	return self.resolutionList
end

function resolutionHandler:getResolutionText(w, h)
	local resolutionText = w .. "x" .. h
	local finalText = ""
	
	if self:isNativeResolution(w, h) then
		finalText = string.easyformatbykeys(_T("NATIVE_RESOLUTION", "RESOLUTION (Native)"), "RESOLUTION", resolutionText)
	else
		finalText = resolutionText
	end
	
	return finalText
end

function resolutionHandler:getNativeResolution()
	return self.mainW, self.mainH
end

function resolutionHandler:isNativeResolution(w, h)
	return w == self.mainW and h == self.mainH
end
