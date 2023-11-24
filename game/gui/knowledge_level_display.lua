local knowledgeLevelDisplay = {}

function knowledgeLevelDisplay:setData(data)
	self.knowledgeData = data
	self.knowledgeLevel = math.floor(self.employee:getKnowledge(data.id))
end

function knowledgeLevelDisplay:getIcon()
	return self.knowledgeData.icon
end

function knowledgeLevelDisplay:getLevelText()
	return self.knowledgeLevel
end

function knowledgeLevelDisplay:onMouseEntered()
	self:queueSpriteUpdate()
	
	self.descBox = gui.create("GenericDescbox")
	
	local wrapWidth = 400
	
	self.descBox:setWidth(wrapWidth)
	self.descBox:addText(string.easyformatbykeys(_T("KNOWLEDGE_LEVEL_LAYOUT", "KNOWLEDGE - LEVEL/MAX points"), "KNOWLEDGE", self.knowledgeData.display, "LEVEL", self.knowledgeLevel, "MAX", knowledge:getMaximumKnowledge(self.knowledgeData.id)), "pix20", nil, 10, wrapWidth)
	self.descBox:addText(self.knowledgeData.description, "pix18", nil, 0, wrapWidth)
	self.knowledgeData:setupDescbox(self.descBox, self.employee, wrapWidth)
	self.descBox:centerToElement(self)
end

function knowledgeLevelDisplay:onClick(x, y, key)
end

function knowledgeLevelDisplay:getProgress()
	return self.employee:getKnowledge(self.knowledgeData.id) / knowledge:getMaximumKnowledge(self.knowledgeData.id)
end

gui.register("KnowledgeLevelDisplay", knowledgeLevelDisplay, "SkillLevelDisplay")
