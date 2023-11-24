local hairAdjustment = {}

function hairAdjustment:getPart()
	return self:getParent():getEmployee():getPortrait():getHaircut()
end

function hairAdjustment:clickedCallback(portrait)
	local res = self:advanceStep()
	
	portrait:setHaircut(res and res.id)
end

gui.register("HairAdjustmentButton", hairAdjustment, "AppearanceAdjustmentButton")
require("game/gui/character_designer/hair_color_adjustment_button")
