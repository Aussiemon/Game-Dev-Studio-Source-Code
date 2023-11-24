local textureSel = {}

function textureSel:setTextureData(textureName)
	self.texture = textureName
	
	self:setText(textureName)
end

function textureSel:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		particleEditor:removeTexture(self.texture)
		self:kill()
	end
end

gui.register("PActiveTextureButton", textureSel, "Button")
