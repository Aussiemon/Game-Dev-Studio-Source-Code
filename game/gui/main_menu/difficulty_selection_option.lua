local difficultySelectionOption = {}

function difficultySelectionOption:setData(data)
	self.data = data
end

function difficultySelectionOption:onClicked()
	game.setDesiredDifficulty(self.data.id)
end

function difficultySelectionOption:setupDescbox()
	difficultySelectionOption.baseClass.setupDescbox(self)
	
	self.descBox = self.descBox or gui.create("GenericDescbox")
	
	self.data:setupDescbox(self.descBox)
	
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x + self.w + _S(5), y + self.h * 0.5 - self.descBox.h * 0.5)
	self.descBox:addDepth(10000)
end

gui.register("DifficultySelectionOption", difficultySelectionOption, "ComboBoxOption")
