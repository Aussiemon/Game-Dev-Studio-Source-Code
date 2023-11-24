local glassesAdjustment = {}

function glassesAdjustment:getPart()
	return self:getParent():getEmployee():getPortrait():getGlasses()
end

function glassesAdjustment:clickedCallback(portrait)
	local res = self:advanceStep()
	
	portrait:setGlasses(res and res.id)
end

gui.register("GlassesAdjustmentButton", glassesAdjustment, "AppearanceAdjustmentButton")
