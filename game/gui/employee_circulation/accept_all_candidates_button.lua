local button = {}

button.icon = "increase"
button.hoverText = {
	{
		font = "bh20",
		icon = "question_mark",
		iconHeight = 24,
		iconWidth = 24,
		text = _T("ACCEPT_ALL_CANDIDATES_DESC", "Clicking this will accept all candidates")
	}
}

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local candidates = self.candidates
		
		if self.searchData then
			for i = #self.candidates, 1, -1 do
				local cand = candidates[i]
				
				employeeCirculation:acceptListingCandidate(self.searchData, cand)
			end
		else
			for i = #self.candidates, 1, -1 do
				local cand = candidates[i]
				
				employeeCirculation:acceptCandidate(cand)
			end
		end
		
		self.parent:kill()
	end
end

function button:positionDescbox()
	local x, y = self:getPos(true)
	
	self.descBox:setPos(x - self.descBox.w + self.w, y + self.h + _S(5))
end

function button:setSearchData(data)
	self.searchData = data
end

function button:setCandidateList(candidates)
	self.candidates = candidates
end

gui.register("AcceptAllCandidatesButton", button, "IconButton")
