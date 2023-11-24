local checkbox = {}

function checkbox:setTag(tag)
	self.tag = tag
	self.added = workshop:hasTag(self.tag)
end

function checkbox:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if workshop:hasTag(self.tag) then
			workshop:removeTag(self.tag)
			
			self.added = false
		else
			workshop:addTag(self.tag)
			
			self.added = true
		end
		
		self:queueSpriteUpdate()
	end
end

function checkbox:isOn()
	return self.added
end

gui.register("WorkshopTagCheckbox", checkbox, "Checkbox")
