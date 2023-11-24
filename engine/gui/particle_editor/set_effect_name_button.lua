local setName = {}

function setName:setTextbox(box)
	self.textbox = box
end

function setName:onClick(x, y, key)
	particleEditor:setName(self.textbox:getText())
end

gui.register("PSetEffectNameButton", setName, "Button")
