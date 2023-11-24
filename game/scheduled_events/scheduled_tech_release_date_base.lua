local base = {}

base.id = "scheduled_tech_release_date_base"
base.inactive = true

function base:activate()
	base.baseClass.activate(self)
	studio:addNewTechThisMonth(self)
end

scheduledEvents:registerNew(base)
