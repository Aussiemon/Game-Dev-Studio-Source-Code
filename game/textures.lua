cache.getImage("textures/generic_quad.png")

for i = 1, 5 do
	cache.getImage("textures/particles/smoke_" .. i .. ".png")
end

spritesheetParser:parse("textures/spritesheets/object_spritesheet")
spritesheetParser:parse("textures/spritesheets/worker")
spritesheetParser:parse("textures/spritesheets/floors_and_walls")
spritesheetParser:parse("textures/spritesheets/wall_test")
spritesheetParser:parse("textures/spritesheets/ui_icons", nil, nil, "nearest", "nearest")
spritesheetParser:parse("textures/spritesheets/portrait")
spritesheetParser:parse("textures/spritesheets/object_icons")
spritesheetParser:parse("textures/spritesheets/environmental")
spritesheetParser:parse("textures/spritesheets/platform_icons")
spritesheetParser:parse("textures/spritesheets/city_decorations")
spritesheetParser:parse("textures/spritesheets/world_decorations")
spritesheetParser:parse("textures/spritesheets/roof_decor")
spritesheetParser:parse("textures/spritesheets/main_menu")
spritesheetParser:parse("textures/spritesheets/game_convention")
spritesheetParser:parse("textures/spritesheets/particle_effects")
spritesheetParser:parse("textures/spritesheets/game_awards")
spritesheetParser:parse("textures/spritesheets/hud_new_icons", nil, nil, "linear", "nearest")
spritesheetParser:parse("textures/spritesheets/hud_new_borders")
