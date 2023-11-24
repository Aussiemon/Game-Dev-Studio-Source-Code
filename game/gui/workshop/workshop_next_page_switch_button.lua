local nextPage = {}

function nextPage:init()
	self.invalidityParams = {}
end

function nextPage:onMouseEntered()
	nextPage.baseClass.onMouseEntered(self)
	
	if #self.invalidityParams > 0 then
		self.descBox = gui.create("GenericDescbox")
		
		for key, param in ipairs(self.invalidityParams) do
			self.descBox:addText(param, "bh20", game.UI_COLORS.RED, 0, 300, "close_button", 22, 22)
			
			if key < #self.invalidityParams then
				self.descBox:addSpaceToNextText(4)
			end
		end
		
		self.descBox:positionToMouse(_S(5), _S(5))
	end
end

function nextPage:onMouseLeft()
	nextPage.baseClass.onMouseLeft(self)
	self:killDescBox()
end

function nextPage:clearInvalidityParameters()
	table.clearArray(self.invalidityParams)
end

function nextPage:addInvalidityParameters(text)
	self.invalidityParams[#self.invalidityParams + 1] = text
end

gui.register("WorkshopNextPageSwitchButton", nextPage, "PageSwitchButton")
