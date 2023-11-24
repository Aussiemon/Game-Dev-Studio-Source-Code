local rivalScrollbarPanel = {}

function rivalScrollbarPanel:handleEvent(event, companyObj)
	for key, item in ipairs(self.items) do
		if item.class == "RivalInfoDisplay" and item:getCompany() == companyObj then
			self:removeItem(item, nil, key)
			item:kill()
			
			break
		end
	end
end

gui.register("RivalScrollbarPanel", rivalScrollbarPanel, "ScrollbarPanel")
