local quadSel = {}

function quadSel:setQuad(quad)
	self.quad = quad
	
	self:setText(self.quad)
end

function quadSel:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		particleEditor:addQuad(self.quad)
	end
end

gui.register("PQuadSelectionButton", quadSel, "Button")
