local storyWrapper = objectiveHandler:getTaskData("story_wrapper")

storyWrapper:addAlwaysClickableID(mainMenu.SAVE_GAME_BUTTON_ID)
storyWrapper:addAlwaysClickableID(mainMenu.SAVE_AND_QUIT_BUTTON_ID)
storyWrapper:addAlwaysClickableID(mainMenu.QUIT_TO_MAIN_MENU_ID)
