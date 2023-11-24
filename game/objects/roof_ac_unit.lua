local roofACUnit = {}

roofACUnit.class = "roof_ac_unit"
roofACUnit.objectAtlas = "roof_decor"
roofACUnit.quad = quadLoader:load("ac_unit")
roofACUnit.scaleX = 2
roofACUnit.scaleY = 2
roofACUnit.display = "roof ac unit"

function roofACUnit:getDrawAngles()
	return 0
end

objects.registerNew(roofACUnit, "roof_decor_object_base")
