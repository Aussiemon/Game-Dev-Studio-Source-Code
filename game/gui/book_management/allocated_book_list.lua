local AllocatedBookList = {}

AllocatedBookList._scaleHor = false
AllocatedBookList._scaleVert = false
AllocatedBookList._inheritScalingState = false
AllocatedBookList._propagateScalingState = false
AllocatedBookList.backdropColor = game.UI_COLORS.STAT_POPUP_PANEL_COLOR:duplicate()
AllocatedBookList.backdropColor.a = 100

function AllocatedBookList:updateSprites()
	self:setNextSpriteColor(self.backdropColor:unpack())
	
	self.backdropSpriteList = self:allocateRoundedRectangle(self.backdropSpriteList, 0, 0, self.w, self.h, 6, -0.1)
end

function AllocatedBookList:draw(w, h)
end

function AllocatedBookList:addChild(child)
	AllocatedBookList.baseClass.addChild(self, child)
	
	if #self.children > 0 then
		self:setVisible(true)
	end
end

function AllocatedBookList:clearBooks()
	while #self.children > 0 do
		self.children[#self.children]:kill()
	end
	
	self:queueLayoutUpdate()
end

function AllocatedBookList:updateLayout(baseW)
	if #self.children == 0 then
		self:setVisible(false)
		
		self.queuedLayoutUpdate = false
		
		return 
	else
		self:setVisible(true)
	end
	
	AllocatedBookList.baseClass.updateLayout(self, baseW)
end

function AllocatedBookList:removeBookByID(bookID)
	for key, element in ipairs(self.children) do
		if element:getBookData().id == bookID then
			element:kill()
			self:queueLayoutUpdate()
			
			break
		end
	end
end

function AllocatedBookList:removeBook(element)
	for key, otherElement in ipairs(self.children) do
		if element == otherElement then
			element:kill()
			self:queueLayoutUpdate()
			
			break
		end
	end
end

function AllocatedBookList:setFinalSize(totalWidth, totalHeight)
	self:setSize(totalWidth, totalHeight + _S(self.elementSpacingVert) * 2)
end

gui.register("AllocatedBookList", AllocatedBookList, "List")
