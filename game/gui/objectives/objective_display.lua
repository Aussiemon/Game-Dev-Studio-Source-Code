local objectiveDisplay = {}

objectiveDisplay.elementSpacing = 3

function objectiveDisplay:setObjective(objective)
	self.objective = objective
	
	self:createView()
end

function objectiveDisplay:updateSprites()
	self:setNextSpriteColor(0, 0, 0, 55)
	
	self.backSprite = self:allocateSprite(self.backSprite, "generic_1px", 0, 0, 0, self.rawW, self.rawH, 0, 0, -0.1)
end

function objectiveDisplay:createView()
	local scaledSpacing = _S(self.elementSpacing)
	
	self.mainDisplay = gui.create("ObjectiveMainDisplay", self)
	
	self.mainDisplay:setPos(scaledSpacing, scaledSpacing)
	self.mainDisplay:setSize(self.rawW - self.elementSpacing * 2, 0)
	self.mainDisplay:setObjective(self.objective)
	
	local mainW = self.mainDisplay:getRawWidth()
	local elementY = self.mainDisplay.h + scaledSpacing * 2
	
	self.dataDisplays = {}
	
	local datas = self.objective:getProgressData()
	local dataCount = #datas
	
	for key, data in ipairs(datas) do
		local display = gui.create("ObjectiveTaskDisplay", self)
		
		display:setPos(scaledSpacing, elementY)
		
		if dataCount > 10 then
			display:setFont("pix18")
			display:setSize(mainW, 20)
		else
			display:setSize(mainW, 24)
		end
		
		display:setDisplayData(data)
		
		elementY = elementY + display.h + scaledSpacing
		
		table.insert(self.dataDisplays, display)
	end
	
	self:setHeight(_US(elementY))
end

gui.register("ObjectiveDisplay", objectiveDisplay)
require("game/gui/objectives/objective_main_display")
require("game/gui/objectives/objective_task_display")
require("game/gui/objectives/objective_task_hud_display")
