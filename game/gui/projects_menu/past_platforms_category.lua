local pastPlatformsCat = {}

function pastPlatformsCat:init()
	self.pendingPlatforms = {}
end

function pastPlatformsCat:unfold()
	if #self.pendingPlatforms > 0 then
		for key, platObj in ipairs(self.pendingPlatforms) do
			local elem = projectsMenu:createPlatformItem(platObj, self.rawW)
			
			self:addItem(elem)
			
			self.pendingPlatforms[key] = nil
		end
	end
	
	pastPlatformsCat.baseClass.unfold(self)
end

function pastPlatformsCat:getItemCount()
	if self.pendingPlatforms then
		local count = #self.pendingPlatforms
		
		if count > 0 then
			return count
		end
	end
	
	return pastPlatformsCat.baseClass.getItemCount(self)
end

function pastPlatformsCat:addPendingPlatform(plat)
	table.insert(self.pendingPlatforms, plat)
end

gui.register("PastPlatformsCategory", pastPlatformsCat, "Category")
