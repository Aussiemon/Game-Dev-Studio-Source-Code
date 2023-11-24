local complexCost = {}

complexCost.class = "complex_monthly_cost_object_base"
complexCost.divideCostByObjectCount = true
complexCost.multiplyCostByEmployeeCount = true
complexCost.BASE = true

function complexCost:getMonthlyCosts()
	if self.realMonthlyCosts then
		local employeeCount = #self.office:getEmployees()
		local objectCount = studio:getOwnedObjectCountByClass(self.class)
		
		for key, data in ipairs(self.realMonthlyCosts) do
			local cost = data.cost
			
			if data.divideByObjectCount and objectCount > 0 then
				cost = cost / objectCount
			end
			
			if data.multiplyByEmployeeCount then
				cost = cost * employeeCount
			end
			
			if data.disableWithNoEmployees and self.office and #self.office:getEmployees() == 0 then
				cost = 0
			end
			
			self.monthlyCosts:setCostType(data.type, cost)
		end
	end
	
	return self.monthlyCosts
end

function complexCost:addMonthlyCostDisplayToDescbox(costList, descBox, wrapWidth)
end

function complexCost:addDescriptionToDescbox(descBox, wrapWidth)
	complexCost.baseClass.addDescriptionToDescbox(self, descBox, wrapWidth)
	
	if self.realMonthlyCosts then
		for key, data in ipairs(self.realMonthlyCosts) do
			local costData = monthlyCost.getCostData(data.type)
			local text
			
			if data.multiplyByEmployeeCount then
				text = _format(_T("INCREASE_IN_MONTHLY_COSTS_PER_EMPLOYEE", "+$CHANGE to AFFECTOR bills/month (per employee)"), "CHANGE", data.cost, "AFFECTOR", costData.display)
			else
				text = _format(_T("INCREASE_IN_MONTHLY_COSTS", "+$CHANGE to AFFECTOR bills/month"), "CHANGE", data.cost, "AFFECTOR", costData.display)
			end
			
			descBox:addText(text, "bh18", nil, 0, wrapWidth, costData.iconQuad, 22, 22)
		end
	end
end

objects.registerNew(complexCost, "static_object_base")
