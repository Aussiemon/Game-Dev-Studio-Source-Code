local taskCategory = {}

taskCategory.MAX_SIGNS = 3
taskCategory.SIGN_SECTION = 0.25
taskCategory.POSITIVE_TEXT_COLOR = activities.POSITIVE_TEXT_COLOR
taskCategory.NEGATIVE_TEXT_COLOR = activities.NEGATIVE_TEXT_COLOR

function taskCategory:setProject(proj)
	self.project = proj
end

function taskCategory:getProject()
	return self.project
end

function taskCategory:setCategory(category)
	self.category = category
	self.categoryData = taskTypes.registeredByCategory[self.category]
	self.quality = taskTypes:getCategoryQualityType(category)
end

function taskCategory:getCategory()
	return self.category
end

function taskCategory:onSizeChanged()
	taskCategory.baseClass.onSizeChanged(self)
	
	if self.priorityAdjustment then
		self.priorityAdjustment:setSize(self.rawW * 0.3, 20)
		self.priorityAdjustment:setPos(self.w - self.priorityAdjustment.w - _S(30), (self.h - self.priorityAdjustment.h) * 0.5)
	end
end

function taskCategory:onHide()
	self:killDescBox()
end

function taskCategory:onMouseEntered()
	if not self.descBox then
		local wrapWidth = 320
		
		if self.categoryData.description then
			self.descBox = gui.create("GenericDescbox")
			
			for key, data in ipairs(self.categoryData.description) do
				self.descBox:addText(data.text, data.font, data.color, data.lineSpace or 0, wrapWidth, data.icon, data.iconWidth, data.iconHeight)
			end
		end
		
		if self.categoryData.setupDescbox then
			self.descBox = self.descBox or gui.create("GenericDescbox")
			
			self.categoryData:setupDescbox(self.project, self.descBox)
		end
		
		if self.quality then
			self.descBox = self.descBox or gui.create("GenericDescbox")
			
			if self.hoverText then
				for key, data in ipairs(self.hoverText) do
					self.descBox:addText(data.text, data.font, data.textColor, data.lineSpace, wrapWidth)
				end
			end
			
			local negativePresent = false
			local insertedHeader = false
			
			for key, genreData in ipairs(genres.registered) do
				if studio:isGameQualityMatchRevealed(studio.CONTRIBUTION_REVEAL_TYPES.GAME_QUALITY, self.quality, genreData.id) then
					local impact = genreData.scoreImpact[self.quality]
					local baseMult = 1
					
					if impact ~= baseMult then
						if not insertedHeader then
							self.descBox:addText(_T("CONTRIBUTION_FACTOR", "Contributes to:"), "bh20", nil, 5, wrapWidth)
							
							insertedHeader = true
						end
						
						local signs, color = game.getContributionSign(baseMult, impact, taskCategory.SIGN_SECTION, taskCategory.MAX_SIGNS, nil, nil, nil)
						
						self.descBox:addText(table.concatEasy(" ", signs, genreData.display, _T("GENRE_LOWERCASE", "genre")), "pix18", color, 0, wrapWidth, genres:getGenreUIIconConfig(genreData, 22, 22, 20))
					end
					
					if impact < baseMult then
						negativePresent = true
					end
				end
			end
			
			if not insertedHeader then
				self.descBox:addText(_T("NO_QUALITY_CONTRIBUTIONS_KNOWN", "No quality contributions known."), "bh18", nil, 0, wrapWidth, "question_mark", 20, 20)
			end
			
			if negativePresent then
				self.descBox:addSpaceToNextText(10)
				self.descBox:addText(_T("NEGATIVE_CONTRIBUTION_EXPLANATION", "A negative contributor indicates that the aspect is not very important for the genre."), "bh18", nil, 0, wrapWidth, "question_mark", 20, 20)
			end
		end
		
		if self.descBox then
			self.descBox:positionToMouse(_S(10), _S(10))
		end
	end
end

function taskCategory:onMouseLeft()
	self:killDescBox()
end

function taskCategory:createPriorityAdjustment()
	self.priorityAdjustment = gui.create("TaskCategoryPriorityAdjustment", self)
	
	self.priorityAdjustment:setCategoryUIObject(self)
	self.priorityAdjustment:setMin(gameProject.PRIORITY_MIN)
	self.priorityAdjustment:setMax(gameProject.PRIORITY_MAX)
	self.priorityAdjustment:setRounding(2)
	self.priorityAdjustment:setValue(taskTypes.registeredByCategory[self.category].priority)
end

gui.register("TaskCategory", taskCategory, "Category")
