local sexButton = {}

sexButton.CATCHABLE_EVENTS = {
	developer.EVENTS.SEX_CHANGED
}

function sexButton:setEmployee(emp)
	self.employee = emp
end

function sexButton:setFemale(female)
	self.female = female
end

function sexButton:isOn()
	if self.female then
		if self.employee:isFemale() then
			return true
		end
		
		return false
	end
	
	if not self.employee:isFemale() then
		return true
	end
	
	return false
end

function sexButton:getSpriteColor()
	return not (not self:isMouseOver() and not self:isOn()) and self.mouseOverIconColor or self.regularIconColor
end

function sexButton:handleEvent(event, emp)
	if emp == self.employee then
		self:queueSpriteUpdate()
	end
end

function sexButton:getIcon()
	if self.female then
		if self.employee:isFemale() then
			return "sex_female_active"
		end
		
		return "sex_female_inactive"
	end
	
	if not self.employee:isFemale() then
		return "sex_male_active"
	end
	
	return "sex_male_inactive"
end

function sexButton:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		if self.female and self.employee:isFemale() or not self.female and not self.employee:isFemale() then
			return 
		end
		
		self.employee:setIsFemale(self.female)
		self.employee:createPortrait()
	end
end

gui.register("SexButton", sexButton, "IconButton")
