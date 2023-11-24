local finalCandidatesFrame = {}

finalCandidatesFrame.closeButtonClass = "CloseCandidateFrameButton"

function finalCandidatesFrame:postKill()
	employeeCirculation:clearPendingCandidates()
end

gui.register("FinalCandidatesFrame", finalCandidatesFrame, "Frame")
