local specButton = {}

function specButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local spec = self.parent:getSpecialist()
		local platObj = platformParts:getPlatformObject()
		
		if platObj:getSpecialist() ~= spec then
			platObj:setSpecialist(spec)
		else
			platObj:setSpecialist(nil)
		end
	end
end

gui.register("SelectPlatformSpecialistButton", specButton, "Button")
