local mainState = {}

function mainState:update(dt)
	camera:update(dt)
	timer:process(dt)
	particleSystem.manager:update(dt)
	
	if not game.savingGame then
		game.worldObject:update(dt)
		lightingManager:updateMain()
		game.update(dt)
		
		if not mapEditor.active then
			timeline:progress(dt)
			
			local progress = timeline.realProgressTime
			
			pedestrianController:update(progress)
			ambientSounds:update(dt)
			
			for key, object in ipairs(game.dynamicObjects) do
				object:update(dt, progress)
			end
			
			motivationalSpeeches:update(dt)
			autosave:update(dt)
		else
			mapEditor:update(dt)
		end
	end
end

return mainState
