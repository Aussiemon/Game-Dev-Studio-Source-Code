local base = {}

base.id = "platform_part_advance"
base.inactive = true
base.partID = nil
base.level = nil

function base:activate()
	base.baseClass.activate(self)
	platformParts.registeredByID[self.partID]:setLevel(self.level)
end

scheduledEvents:registerNew(base)
