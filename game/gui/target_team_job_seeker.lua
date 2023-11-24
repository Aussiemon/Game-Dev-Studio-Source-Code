local targetTeam = {}

function targetTeam:setJobSeeker(jobSeeker)
	self.jobSeeker = jobSeeker
end

function targetTeam:setJobSeekerElement(element)
	self.jobSeekerElement = element
end

function targetTeam:onClick(x, y, key)
	if key == gui.mouseKeys.LEFT then
		employeeCirculation:offerJob(self.jobSeeker, self.team)
		
		if self.jobSeekerElement then
			self.jobSeekerElement:moveToSentCategory()
		end
		
		self.basePanel:kill()
	end
end

gui.register("TargetTeamJobSeeker", targetTeam, "TeamButton")
