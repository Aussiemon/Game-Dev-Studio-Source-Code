local button = {}

button.icon = "decrease_red"
button.hoverText = {
	{
		font = "bh20",
		icon = "question_mark",
		iconHeight = 24,
		iconWidth = 24,
		text = _T("REFUSE_ALL_CANDIDATES_DESC", "Clicking this will reject all candidates")
	}
}

function button:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		local candidates = self.candidates
		
		for i = #self.candidates, 1, -1 do
			local cand = candidates[i]
			
			employeeCirculation:refuseListingCandidate(self.searchData, cand)
		end
		
		self.parent:kill()
	end
end

gui.register("RefuseAllCandidatesButton", button, "AcceptAllCandidatesButton")
