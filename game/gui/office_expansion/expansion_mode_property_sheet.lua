local expansionSheet = {}

expansionSheet.tabButtonClass = "HUDExpansionTabButton"
expansionSheet.scaleButtonsByButtonCount = false

function expansionSheet:setSocketContainer(container)
	self.socketContainer = container
end

function expansionSheet:createTabButton()
	local tab = gui.create("HUDExpansionTabButton")
	
	tab:setSocketContainer(self.socketContainer)
	self.socketContainer:addButton(tab)
	
	return tab
end

function expansionSheet:setupTabButton(tabButton, w, h, text, callback, categoryID, iconOverride)
	tabButton:setScalingState(true, true)
	tabButton:setCategoryID(categoryID)
	
	local largest = math.max(w, h)
	
	tabButton:setSize(largest, largest)
	tabButton:setCallback(callback)
	tabButton:setCenterDescBox(true)
	tabButton:addDepth(self.depth + 10)
end

gui.register("ExpansionModePropertySheet", expansionSheet, "PropertySheet")
require("game/gui/office_expansion/expansion_mode_property_sheet_tab_button")
