local newGameConfirmationButton = {}

newGameConfirmationButton.CATCHABLE_EVENTS = {
	game.EVENTS.DESIRED_GAMETYPE_SET
}

function newGameConfirmationButton:think()
	if self.currentGametype then
		local prevCanSelect = self.canStart
		
		self.canStart = self.currentGametype:canStartGame()
		self.curData = game.GAME_TYPES_BY_ID[desired]
		
		if prevCanSelect ~= self.canStart then
			self:queueSpriteUpdate()
		end
	end
end

function newGameConfirmationButton:onMouseEntered()
	newGameConfirmationButton.baseClass.onMouseEntered(self)
	
	if not self.canStart and self.currentGametype then
		self.descBox = gui.create("GenericDescbox")
		
		self.currentGametype:setupInvalidityDescbox(self.descBox)
		self.descBox:positionToMouse(_S(10), _S(10))
	end
end

function newGameConfirmationButton:onMouseLeft()
	newGameConfirmationButton.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function newGameConfirmationButton:isDisabled()
	return not game.getDesiredGametype() or not self.canStart
end

function newGameConfirmationButton:handleEvent(event, data)
	self.currentGametype = game.GAME_TYPES_BY_ID[data]
	
	self:queueSpriteUpdate()
end

function newGameConfirmationButton:onClick()
	local gametype = game.getDesiredGametype()
	
	if gametype and self.canStart then
		local campaignData = game.GAME_TYPES_BY_ID[gametype]
		
		if campaignData:preBegin() then
			game.GAME_TYPES_BY_ID[gametype]:begin()
		end
	end
end

gui.register("NewGameConfirmationButton", newGameConfirmationButton, "Button")
