local platformInfo = {}

function platformInfo:setProject(proj)
	self.project = proj
end

function platformInfo:setPlatform(platformObj)
	self.platform = platformObj
	
	self:updateDescbox()
end

function platformInfo:hideDisplay()
	self.platform = nil
	
	self:removeAllText()
	self:hide()
end

function platformInfo:canShow()
	return self.platform ~= nil
end

function platformInfo:showDisplay(platformObj)
	self:setPlatform(platformObj)
	
	if self:getVisible() then
		return 
	end
	
	self:show()
end

function platformInfo:updateDescbox(platformObj)
	self:removeAllText()
	
	platformObj = platformObj or self.platform
	
	platformObj:setupDescbox(self, 320, self.project)
end

gui.register("PlatformInfoDescbox", platformInfo, "GenericDescbox")
