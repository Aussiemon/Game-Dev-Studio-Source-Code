local GSB = {}

function GSB:attemptDrawDesc()
	if self:isMouseOver() then
		if not self.comboBox then
			if not self.descBox then
				self:makeDescBox()
			end
		else
			self:killDescBox()
		end
	else
		self:killDescBox()
	end
end

gui.register("GraphicsSettingsBase", GSB, "Panel")
