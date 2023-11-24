local skill = {}

function skill:init()
	self:setFont(fonts.get("pix20"))
end

function skill:setFont(font)
	self.font = font
	self.textHeight = self.font:getHeight()
end

function skill:setEmployee(employee)
	self.employee = employee
	
	self:setHeight(#skills.registered * self.textHeight)
end

function skill:setNoOffset(state)
	self.noOffset = state
end

function skill:draw(w, h)
	local empSkills = self.employee:getSkills()
	local x, y = 0, 0
	
	if not self.noOffset then
		x = self.employee:getRight()
		y = self.employee.y
	end
	
	love.graphics.setColor(80, 80, 80, 255)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setFont(self.font)
	
	for key, data in ipairs(skills.registered) do
		local curSkill = empSkills[data.id]
		local reqExp = skills:getRequiredExperience(curSkill.level)
		local progress = curSkill.experience / reqExp
		local baseY = y + (key - 1) * self.textHeight
		
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(data.display, x + 5, baseY)
		
		local size = self.font:getWidth(curSkill.level)
		
		love.graphics.print(curSkill.level, x + 140 - size, baseY)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("fill", x + 145, baseY + 2, 50, 14)
		love.graphics.setColor(20, 20, 20, 255)
		love.graphics.rectangle("fill", x + 147, baseY + 4, 46, 10)
		love.graphics.setColor(180, 255, 180, 255)
		love.graphics.rectangle("fill", x + 147, baseY + 4, 48 * progress, 10)
	end
end

gui.register("SkillDisplay", skill)
