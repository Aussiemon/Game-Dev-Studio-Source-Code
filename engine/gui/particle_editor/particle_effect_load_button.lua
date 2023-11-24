local pLoad = {}

function pLoad:setEffectPath(path)
	self.effectPath = path
	
	self:setText(path)
end

function pLoad:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		particleEditor:loadEffect(self.effectPath)
	end
end

gui.register("PEffectLoadButton", pLoad, "Button")
