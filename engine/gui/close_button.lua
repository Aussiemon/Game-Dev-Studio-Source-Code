local close = {}

function close:init()
end

function close:postClick()
end

function close:setSkipKillOnClick(state)
	self.skipKillOnClick = state
end

function close:onClick(x, y, key)
	if not self.skipKillOnClick then
		self:getParent():kill()
	end
	
	self:postClick()
end

gui.register("CloseButton", close, "Button")
