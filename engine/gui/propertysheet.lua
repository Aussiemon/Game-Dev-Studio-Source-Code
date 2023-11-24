local PANEL = {}

PANEL.canPropagateKeyPress = true
PANEL.scaleButtonsByButtonCount = true
PANEL.tabX = 3
PANEL.tabY = 3
PANEL.buttonDepth = 10
PANEL.tabButtonClass = "PropertySheetTabButton"

function PANEL:init()
	self.option = nil
	self.font = fonts.get("pix28")
	self.items = {}
	self.elementX = 0
	self.elementY = 0
end

function PANEL:setButtonDepth(depth)
	self.buttonDepth = depth
end

function PANEL:setScaleButtonsByButtonCount(state)
	self.scaleButtonsByButtonCount = state
end

function PANEL:setFont(font)
	self.font = font
end

function PANEL:setTabOffset(x, y)
	self.tabX = x or 0
	self.tabY = y or 0
end

function PANEL:setElementOffset(x, y)
	self.elementX = x or 0
	self.elementY = y or 0
end

function PANEL:getItems()
	return self.items
end

function PANEL:switchTo(targetTab)
	if type(targetTab) == "table" then
		for key, object in ipairs(self.items) do
			if object[1] == targetTab then
				targetTab:switchTo()
				
				break
			end
		end
	elseif type(targetTab) == "number" then
		self.items[targetTab]:switchTo()
	end
end

function PANEL:performLayout()
	local w, h = self:getRawSize()
	local x = 0
	local elementCount = #self.items
	local elementSize = math.ceil((self.w - self.tabX * (elementCount - 1)) / elementCount)
	
	for k, v in pairs(self.items) do
		local tab = v[1]
		local panel = v[2]
		local tabW, tabH = tab:getSize()
		
		panel:setPos(self.elementX, tabH + self.tabY + self.elementY)
		panel:setSize(w, h - _US(tabH) - self.tabY)
		
		if self.scaleButtonsByButtonCount then
			tabW = elementSize
			
			tab:setSize(tabW, tabH)
		end
		
		tab:setPos(x, 0)
		
		x = x + tabW + self.tabX
	end
end

function PANEL:canEnable(child)
	if child.activeTabCanvas ~= nil then
		return child.activeTabCanvas
	end
	
	return true
end

function PANEL:setupTabButton(tabButton, w, h, text, callback)
	tabButton:setScalingState(false, false)
	tabButton:setSize(w, math.max(self.fontHeight, _S(h)))
	tabButton:setText(text)
	tabButton:setCallback(callback)
end

function PANEL:getTabButtonClass()
	return self.tabButtonClass
end

function PANEL:createTabButton()
	local tab = gui.create(self:getTabButtonClass(), self)
	
	tab:setScaler(self.scaler)
	tab:setPos(0, 0)
	tab:setFont(self.font)
	tab:setItemPosition(#self.items + 1)
	tab:setDepth(self:getDepth() + self.buttonDepth)
	
	return tab
end

function PANEL:addItem(item, txt, w, h, callback, ...)
	txt = txt or "tabtitle"
	w = w or _US(self.font:getWidth(txt)) + 10
	h = h or _US(self.font:getHeight()) + 5
	self.fontHeight = self.font:getHeight()
	
	local tab = self:createTabButton()
	
	if tab then
		self:setupTabButton(tab, w, h, txt, callback, ...)
	end
	
	local canvas = gui.create("Panel", self)
	
	canvas:setScaler(self.scaler)
	canvas:setPos(0, self.fontHeight)
	canvas:setSize(self.rawW, self.rawH - _US(self.fontHeight))
	canvas:setVisible(false)
	
	canvas.shouldDraw = false
	canvas.setScissors = true
	
	canvas:setDepth(self:getDepth() + self.buttonDepth)
	
	canvas.activeTabCanvas = false
	
	local ctnr = {}
	
	if tab then
		tab.ps = self
		tab.bar = canvas
		
		table.insert(ctnr, tab)
	end
	
	item:setDepth(self:getDepth() + self.buttonDepth)
	item:setParent(canvas)
	table.insert(ctnr, canvas)
	table.insert(self.items, ctnr)
	
	if not self.option then
		self.option = canvas
		
		tab:setCanvas(tab)
		tab:switchTo()
	end
	
	self:performLayout()
	
	return tab
end

function PANEL:draw(w, h)
end

gui.register("PropertySheet", PANEL)
