local projectScroll = {}

projectScroll.SAVED_DATA = {}

function projectScroll:preResolutionChange()
	for key, item in ipairs(self.items) do
		local saved = {
			class = item.class,
			project = item.project
		}
		
		item:saveData(saved)
		
		projectScroll.SAVED_DATA[#projectScroll.SAVED_DATA + 1] = saved
	end
end

function projectScroll:postResolutionChange()
	for key, item in ipairs(projectScroll.SAVED_DATA) do
		local element = gui.create(item.class)
		
		self:addItem(element, nil, item)
		
		projectScroll.SAVED_DATA[key] = nil
	end
end

function projectScroll:updateSprites()
end

function projectScroll:draw()
end

function projectScroll:onShow()
	for key, item in ipairs(self.items) do
		if item.onShowHUD then
			item:onShowHUD()
		end
	end
end

function projectScroll:showSlider()
	projectScroll.baseClass.showSlider(self)
end

function projectScroll:hideSlider()
	projectScroll.baseClass.hideSlider(self)
end

function projectScroll:addItem(item, data, savedData)
	item:setWidth(self.rawW - 15)
	
	if data then
		item:setData(data)
	elseif savedData then
		item:loadData(savedData)
	end
	
	projectScroll.baseClass.addItem(self, item)
end

gui.register("ProjectScrollbarPanel", projectScroll, "ScrollbarPanel")
