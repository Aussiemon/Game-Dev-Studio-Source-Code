local goal = {}

goal.id = "goal_base"
goal.DEFAULT_MIN_EXP = 500
goal.PERCENTAGE_TO_NEXT_LEVEL = 1
goal.CAN_PICK = false

function goal:init()
end

function goal:initEventHandler()
	events:addDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function goal:removeEventHandler()
	events:removeDirectReceiver(self, self.CATCHABLE_EVENTS)
end

function goal:getID()
	return self.id
end

function goal:onFinish()
	if self.display then
		self.display:succeed()
	end
end

function goal:onFail()
	if self.display then
		self.display:fail()
	end
end

function goal:onStart()
	self:createDisplay()
end

function goal:remove()
	self:removeDisplay()
end

function goal:removeDisplay()
	if self.display then
		self.display:kill()
		
		self.display = nil
	end
end

function goal:createDisplay(width)
	if not yearlyGoalController:isTrackingGoals() or self.display and self.display:isValid() then
		return 
	end
	
	width = width or 230
	self.display = self:createDisplayElement()
	
	self.display:makeHUDElement()
	self.display:setDepth(50)
	self.display:setWidth(width)
	self.display:setPos(_S(5), game.topHUD.y + game.topHUD.h + _S(5))
	self.display:hide()
	self:updateDisplay(self.display)
	yearlyGoalController:queueGoalElement(self.display)
	
	return self.display
end

function goal:createDisplayElement(parent)
	local display = gui.create("YearlyGoalProgressDisplay", parent)
	
	return display
end

function goal:updateDisplay(displayElement)
	if displayElement then
		self:_updateDisplay(displayElement)
	end
end

function goal:_updateDisplay(displayElement)
end

function goal:getDisplay()
	return self.display
end

function goal:prepare()
end

function goal:canPick()
	return self.CAN_PICK
end

function goal:getText()
	return ""
end

function goal:getPriority()
	return 0
end

function goal:giveReward()
	local levels = math.ceil(self:getRewardedLevels())
	
	self.rewardedLevels = levels
	
	for key, object in ipairs(studio:getEmployees()) do
		local mainSkill = object:getRoleData().mainSkill
		
		if mainSkill then
			local level = object:getSkillLevel(mainSkill)
			
			for i = 1, levels do
				object:increaseSkill(mainSkill, math.max(skills:getRequiredExperience(level) * self.PERCENTAGE_TO_NEXT_LEVEL, self.DEFAULT_MIN_EXP))
				
				level = level + 1
			end
		else
			for i = 1, levels do
				local lowest, lowestID = math.huge
				local levels = object:getSkills()
				
				for key, skillData in ipairs(skills.developmentSkills) do
					local id = skillData.id
					local level = levels[id].level
					
					if level < lowest then
						lowestID = id
						lowest = level
					end
				end
				
				if lowestID then
					object:increaseSkill(lowestID, math.max(skills:getRequiredExperience(lowest) * self.PERCENTAGE_TO_NEXT_LEVEL, self.DEFAULT_MIN_EXP))
				end
			end
		end
	end
	
	self:createRewardPopup()
end

function goal:createRewardPopup()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont("pix24")
	popup:setTitle(_T("YEARLY_GOAL_ACHIEVED_TITLE", "Yearly Goal Achieved"))
	popup:setTextFont("pix20")
	popup:setText(_T("YEARLY_GOAL_ACHIEVED_DESCRIPTION", "Congratulations! You've achieved your yearly goal."))
	popup:hideCloseButton()
	
	local wrapWidth = popup.rawW - 20
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addText(_format(_T("YEARLY_GOAL_THOROUGH", "The goal was: GOAL"), "GOAL", self:getText()), "pix20", nil, 0, wrapWidth, "question_mark", 22, 22)
	self:setupRewardPopup(popup)
	popup:addButton("pix20", _T("GREAT", "Great"))
	popup:center()
	frameController:push(popup)
end

function goal:setupRewardPopup(popup)
	local left, right, extra = popup:getDescboxes()
	local baseText = self.rewardedLevels > 1 and _T("YEARLY_GOAL_REWARD_LEVELS", "Reward: all employees got LEVEL levels worth of experience for their main skill.") or _T("YEARLY_GOAL_REWARD_LEVEL", "Reward: all employees got LEVEL level worth of experience for their main skill.")
	
	extra:addSpaceToNextText(6)
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	extra:addText(_format(baseText, "LEVEL", math.round(self.rewardedLevels, 1)), "bh18", nil, 0, wrapWidth, "increase", 22, 22)
end

function goal:getRewardedLevels()
	return 1
end

function goal:onHoverTaskInfoDescBox(taskData)
end

function goal:handleEvent(event)
end

function goal:save()
	return {
		id = self.id
	}
end

function goal:load(data)
	self:createDisplay()
end

yearlyGoalController:registerNew(goal)
