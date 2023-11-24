local pageController = {}

pageController.canPropagateKeyPress = true
pageController.BUTTONS = {
	NEXT = 2,
	PREV = 1
}

function pageController:init()
	self.pages = {}
	self.pageButtonCallbacks = {}
	self.pageSwitchButtonCallbacks = {}
	self.curPage = 1
	self.lockedPages = 0
	self.visitablePageCount = 0
	
	for key, type in pairs(pageController.BUTTONS) do
		self.pageButtonCallbacks[type] = {}
		self.pageSwitchButtonCallbacks[type] = {}
	end
end

function pageController:initButtons()
	self:initNextButton()
	self:initPrevButton()
	self:positionButtons()
end

function pageController:initNextButton(text, w, h, pageSwitchButtonClass)
	self.nextButtonText = text
	self.nextButton = gui.create(pageSwitchButtonClass or "PageSwitchButton", self)
	
	self.nextButton:setDirection(1)
	self.nextButton:setFont("bh22")
	self.nextButton:setText(text)
	self.nextButton:setSize(w, h)
	
	return self.nextButton
end

function pageController:initPrevButton(text, w, h, pageSwitchButtonClass)
	self.prevButtonText = text
	self.prevButton = gui.create(pageSwitchButtonClass or "PageSwitchButton", self)
	
	self.prevButton:setDirection(-1)
	self.prevButton:setFont("bh22")
	self.prevButton:setText(text)
	self.prevButton:setSize(w, h)
	
	return self.prevButton
end

function pageController:positionButtons()
	local baseY = self.h - _S(3) - self.nextButton.h
	
	self.nextButton:setPos(self.w - _S(3) - self.nextButton.w, baseY)
	
	local x, y = self.nextButton:getPos(true)
	
	self.prevButton:setPos(x - _S(10) - self.prevButton.w, baseY)
end

function pageController:hideButtons()
	self.prevButton:hide()
	self.nextButton:hide()
end

function pageController:changePage(dir)
	local oldPage = self.curPage
	local newPage = math.min(self.visitablePageCount, math.max(1, oldPage + dir))
	
	self.curPage = newPage
	
	if newPage ~= oldPage then
		local oldPageObj = self.pages[oldPage]
		
		oldPageObj:hide()
		self.pages[newPage]:show()
	end
	
	self:verifyButton(pageController.BUTTONS.PREV, self.prevButton)
	self:verifyButton(pageController.BUTTONS.NEXT, self.nextButton)
end

function pageController:lockPage(amount)
	amount = amount or 1
	self.lockedPages = self.lockedPages + amount
	self.visitablePageCount = self.visitablePageCount - amount
end

function pageController:setPage(id)
	local prevPage = self.pages[self.curPage]
	
	prevPage:hide()
	
	local page = self.pages[id]
	
	page:show()
	
	self.curPage = id
	
	self:updateButtonStates()
end

function pageController:setPageButtonCallback(pageID, buttonType, callback)
	self.pageButtonCallbacks[buttonType][pageID] = callback
end

function pageController:setPageButtonShowCallback(pageID, buttonType, callback)
	self.pageSwitchButtonCallbacks[buttonType][pageID] = callback
end

function pageController:updateButtonStates()
	self:verifyButton(pageController.BUTTONS.PREV, self.prevButton)
	self:verifyButton(pageController.BUTTONS.NEXT, self.nextButton)
end

function pageController:verifyButton(type, button)
	local page = self.curPage
	local callback = self.pageSwitchButtonCallbacks[type][page]
	
	if callback then
		local clickAvailability = callback(button)
		
		if clickAvailability ~= nil then
			self.prevButton:setCanClick(clickAvailability)
		else
			self:_verifyButton(type, button)
		end
	else
		self:_verifyButton(type, button)
	end
	
	button:setClickCallback(self.pageButtonCallbacks[type][page])
end

function pageController:_verifyButton(type, button)
	if type == pageController.BUTTONS.PREV then
		button:setText(self.prevButtonText)
		
		if page == 1 then
			button:setCanClick(false)
		else
			button:setCanClick(true)
		end
	else
		button:setText(self.nextButtonText)
		
		if page == self.visitablePageCount then
			button:setCanClick(false)
		else
			button:setCanClick(true)
		end
	end
end

function pageController:createPage(w, h)
	local page = gui.create("Page", self)
	
	page:setSize(w, h)
	page:hide()
	
	self.visitablePageCount = self.visitablePageCount + 1
	
	table.insert(self.pages, page)
	
	return page
end

gui.register("PageController", pageController)
require("engine/gui/page")
require("engine/gui/page_switch_button")
