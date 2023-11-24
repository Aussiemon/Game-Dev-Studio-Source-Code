objects = {}
objects.registered = {}
objects.registeredByID = {}
objects.EVENTS = {
	OBJECT_REGISTERED = events:new()
}

function objects.registerNew(data, inherit)
	data.mtindex = {
		__index = data
	}
	
	if inherit then
		local baseClass = objects.registeredByID[inherit]
		
		setmetatable(data, baseClass.mtindex)
		
		data.baseClass = baseClass
	else
		setmetatable(data, entity.mtindex)
		
		data.baseClass = entity
	end
	
	if data.tileWidth then
		data.width = data.tileWidth * game.WORLD_TILE_WIDTH
		data.height = data.tileHeight * game.WORLD_TILE_HEIGHT
	end
	
	if data.category then
		objectCategories:addToCategory(data.category, data)
	end
	
	data:onRegister()
	table.insert(objects.registered, data)
	
	objects.registeredByID[data.class] = data
	
	events:fire(objects.EVENTS.OBJECT_REGISTERED, data)
end

function objects.getClassData(className)
	return objects.registeredByID[className]
end

function objects.create(className, ...)
	local objectData = objects.registeredByID[className]
	local new = {}
	
	setmetatable(new, objectData.mtindex)
	new:init(...)
	
	return new
end

require("game/objects/object_categories")
require("game/objects/generic_object")
require("game/objects/static_object_base")
require("game/objects/complex_monthly_cost_object_base")
require("game/objects/room_checking_object_base")
require("game/objects/housable_object_base")
require("game/objects/progressing_object_base")
require("game/objects/workplace_object_base")
require("game/objects/joinable_object_base")
require("game/objects/water_dispenser")
require("game/objects/workplace")
require("game/objects/toilet")
require("game/objects/sink")
require("game/objects/toilet_paper_holder")
require("game/objects/door_object_base")
require("game/objects/door")
require("game/objects/coffee_machine")
require("game/objects/vending_machine")
require("game/objects/gumball_machine")
require("game/objects/microwave")
require("game/objects/stove")
require("game/objects/fridge")
require("game/objects/light_source_base")
require("game/objects/lamp")
require("game/objects/conference_object_base")
require("game/objects/conference_table")
require("game/objects/bookshelf_object_base")
require("game/objects/bookshelf")
require("game/objects/decoration_object_base")
require("game/objects/tree_decoration")
require("game/objects/chair")
require("game/objects/squat_rack")
require("game/objects/barbell_bench")
require("game/objects/whiteboard")
require("game/objects/server_rack")
require("game/objects/kitchen_counter")
require("game/objects/kitchen_sink")
require("game/objects/dynamic_object_base")
require("game/objects/drive_increase")
require("game/objects/invalidity_display")
require("game/objects/pedestrian")
require("game/objects/quadtree_decor_object_base")
require("game/objects/trashcan_decor")
require("game/objects/grass_decor")
require("game/objects/rocks_decor")
require("game/objects/dumpster_decor")
require("game/objects/bench_decor")
require("game/objects/signpost_1")
require("game/objects/signpost_2")
require("game/objects/signpost_3")
require("game/objects/signpost_4")
require("game/objects/flower_1")
require("game/objects/flower_2")
require("game/objects/flower_3")
require("game/objects/flower_4")
require("game/objects/bush_small")
require("game/objects/bush_medium")
require("game/objects/bush_large")
require("game/objects/bush_long")
require("game/objects/billboard_1")
require("game/objects/billboard_2")
require("game/objects/billboard_3")
require("game/objects/billboard_4")
require("game/objects/water_puddle")
require("game/objects/comfort/beanbag")
require("game/objects/comfort/sofa")
require("game/objects/comfort/tv_and_consoles")
require("game/objects/comfort/plant_flower")
require("game/objects/comfort/ac_unit")
require("game/objects/comfort/table_football")
require("game/objects/comfort/table_tennis")
require("game/objects/roof_decor_object_base")
require("game/objects/roof_ac_unit")
require("game/objects/roof_antenna")
require("game/objects/floor_transition_object_base")
require("game/objects/staircase")
