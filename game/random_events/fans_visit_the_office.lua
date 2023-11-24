local fansVisit = {}

fansVisit.id = "fan_wants_to_work"
fansVisit.eventRequirement = timeline.EVENTS.NEW_WEEK
fansVisit.rollMin = 1
fansVisit.rollMax = 100
fansVisit.cooldownFact = "fans_visit_cooldown_fact"
fansVisit.timeCooldown = timeline.DAYS_IN_MONTH * 6
fansVisit.occurChance = 1
fansVisit.minimumReputation = 5000

function fansVisit:canOccur(event)
	if studio:getReputation() <= self.minimumReputation then
		return false
	end
	
	local lastFan = studio:getFact(self.cooldownFact)
	
	if lastFan and timeline.curTime < lastFan + fansVisit.timeCooldown then
		return false
	end
	
	return true
end

function fansVisit:occur()
	local popup = game.createPopup(600, _T("FANS_HAVE_VISITED_YOU_TITLE", "Fan Visit"), _T("FANS_HAVE_VISITED_YOU_DESC", "Fans have visited your office and are wa"), "pix24", "pix20", nil)
end

randomEvents:registerNew(fansVisit)
