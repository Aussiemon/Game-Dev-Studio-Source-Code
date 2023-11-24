local quadSel = {}

function quadSel:setQuadData(quad)
	self.quadData = quad
	
	self:setText(self.quadData.quad)
end

function quadSel:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		particleEditor:removeQuad(self.quadData)
		self:kill()
	end
end

gui.register("PActiveQuadButton", quadSel, "Button")
