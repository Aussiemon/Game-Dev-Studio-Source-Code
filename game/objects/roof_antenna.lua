local roofAntenna = {}

roofAntenna.display = "roof antenna"
roofAntenna.class = "roof_antenna"
roofAntenna.objectAtlas = "roof_decor"
roofAntenna.quad = quadLoader:load("roof_antenna")
roofAntenna.scaleX = 2
roofAntenna.scaleY = 2
roofAntenna.quads = {
	quadLoader:load("roof_antenna"),
	quadLoader:load("roof_antenna_2")
}

function roofAntenna:init()
	roofAntenna.baseClass.init(self)
	
	self.realQuad = self.quads[math.random(1, #self.quads)]
end

function roofAntenna:getQuad()
	return self.realQuad
end

function roofAntenna:getDrawAngles()
	return 0
end

objects.registerNew(roofAntenna, "roof_decor_object_base")
