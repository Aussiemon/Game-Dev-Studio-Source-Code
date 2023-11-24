local bookFrame = {}

bookFrame.bookBoostListHorizontalSpacing = 10

function bookFrame:postKill()
	bookController:onCloseFrame()
end

function bookFrame:createBookBoostList()
	local x, y = self:getPos(true)
	
	self.bookBoostList = gui.create("BookBoostTitledList")
	
	self.bookBoostList:setPos(x + self.w + _S(bookFrame.bookBoostListHorizontalSpacing), y)
end

function bookFrame:setupLevelInfo()
end

function bookFrame:kill()
	bookFrame.baseClass.kill(self)
	self.bookBoostList:kill()
	bookController:resetSkillLevelInfoData()
end

gui.register("BookManagementFrame", bookFrame, "Frame")
