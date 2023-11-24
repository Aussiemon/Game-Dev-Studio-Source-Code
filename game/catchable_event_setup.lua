developer.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_MONTH,
	team.EVENTS.MANAGER_ASSIGNED,
	developer.EVENTS.WORKPLACE_SET,
	studio.expansion.EVENTS.PLACED_OBJECT,
	studio.expansion.EVENTS.REMOVED_OBJECT,
	pathCaching.EVENTS.PATHS_INVALIDATED
}
studio.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_MONTH,
	project.EVENTS.SCRAPPED_PROJECT,
	pathCaching.EVENTS.PATHS_INVALIDATED,
	gameProject.EVENTS.REACHED_RELEASE_STATE,
	developer.EVENTS.SKILL_INCREASED,
	studio.expansion.EVENTS.POST_PLACED_OBJECT
}
project.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY
}
gameProject.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_MONTH,
	platformShare.EVENTS.PLATFORM_REMOVED,
	trends.EVENTS.TREND_OVER,
	trends.EVENTS.TREND_START,
	playerPlatform.EVENTS.CANCELLED_DEVELOPMENT
}
team.CATCHABLE_EVENTS = {
	project.EVENTS.PROJECT_COMPLETE,
	timeline.EVENTS.NEW_DAY
}
contractWork.CATCHABLE_EVENTS = {
	contractWork.OFFER_WORK_EVENT,
	timeline.EVENTS.NEW_MONTH,
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK,
	studio.EVENTS.RELEASED_GAME,
	gameProject.EVENTS.GAME_OFF_MARKET,
	project.EVENTS.SCRAPPED_PROJECT
}
platformShare.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_MONTH,
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK
}
dialogueHandler.CATCHABLE_EVENTS = {
	gui.getClassTable("ScreenDarkener").EVENTS.REACHED_FULL_ALPHA,
	gui.getClassTable("DialogueBox").EVENTS.FLEW_AWAY
}
objectSelector.CATCHABLE_EVENTS = {
	studio.expansion.EVENTS.REMOVED_OBJECT,
	studio.expansion.EVENTS.PLACED_OBJECT
}
rivalGameCompanies.CATCHABLE_EVENTS = {
	developer.EVENTS.SALARY_CHANGED,
	rivalGameCompany.SLANDER_ATTEMPT_EVENT,
	timeline.EVENTS.NEW_WEEK,
	timeline.EVENTS.NEW_MONTH,
	rivalGameCompany.EMPLOYEE_STEAL_ATTEMPT_EVENT
}
pedestrianController.CATCHABLE_EVENTS = {
	weather.EVENTS.STARTED,
	weather.EVENTS.ENDED,
	timeOfDay.EVENTS.NEW_HOUR
}
employeeAssignment.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	officeBuilding.EVENTS.BECOME_VISIBLE,
	officeBuilding.EVENTS.BECOME_INVISIBLE
}
gui.getClassTable("RivalScrollbarPanel").CATCHABLE_EVENTS = {
	rivalGameCompanies.EVENTS.COMPANY_DEFUNCT
}
gui.getClassTable("UpcomingContractDisplay").CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	contractor.EVENTS.BEGUN_PROJECT_SETUP
}
gui.getClassTable("PropertyHUDElement").CATCHABLE_EVENTS = {
	studio.EVENTS.REPUTATION_CHANGED,
	studio.EVENTS.REPUTATION_SET,
	rivalGameCompanies.EVENTS.LOCKED,
	rivalGameCompanies.EVENTS.UNLOCKED
}
gui.getClassTable("SaleDisplayFrame").CATCHABLE_EVENTS = {
	gameProject.EVENTS.COPIES_SOLD,
	gameProject.EVENTS.UPDATE_SALE_DISPLAY,
	gameProject.EVENTS.GAME_OFF_MARKET,
	project.EVENTS.SCRAPPED_PROJECT,
	gameProject.EVENTS.TREND_CONTRIBUTION_UPDATED
}

local element = gui.getClassTable("EmployeeTeamAssignmentButton")

gui.getClassTable("StudioEmploymentInfoDescbox").CATCHABLE_EVENTS = {
	employeeCirculation.EVENTS.JOB_OFFER_SENT,
	employeeCirculation.EVENTS.CANDIDATE_HIRED,
	element.EVENTS.MOUSE_OVER,
	element.EVENTS.MOUSE_LEFT
}

local serverRackData = objects.getClassData("server_rack")

gui.getClassTable("ServerRentingScrollbarPanel").CATCHABLE_EVENTS = {
	serverRackData.EVENTS.UPGRADED
}
gui.getClassTable("ServerCapacityBar").CATCHABLE_EVENTS = {
	serverRackData.EVENTS.UPGRADED,
	serverRenting.EVENTS.CHANGED_RENTED_SERVERS
}
gui.getClassTable("ChangeCustomerSupportButton").CATCHABLE_EVENTS = {
	serverRenting.EVENTS.CHANGED_CUSTOMER_SUPPORT
}
gui.getClassTable("AppearanceAdjustmentButton").CATCHABLE_EVENTS = {
	developer.EVENTS.SEX_CHANGED
}
gui.getClassTable("ExpoParticipantSelection").CATCHABLE_EVENTS = {
	gameConventions.EVENTS.BOOTH_CHANGED,
	gameConventions.EVENTS.PARTICIPANTS_REMOVED
}
gui.getClassTable("PrefabConstructionModeButton").CATCHABLE_EVENTS = {
	officePrefabEditor.EVENTS.CONSTRUCTION_MODE_CHANGED
}
gui.getClassTable("MapEditModeButton").CATCHABLE_EVENTS = {
	mapEditor.EVENTS.EDIT_MODE_CHANGED
}
gui.getClassTable("MapSelectionButton").CATCHABLE_EVENTS = {
	game.getGameTypeData("freeplay").EVENTS.SELECTED_MAP
}
traits:getData("bookworm").CATCHABLE_EVENTS = {
	objects.getClassData("bookshelf_object_base").EVENTS.BOOK_COUNT_CHANGED,
	studio.EVENTS.ROOMS_UPDATED
}

local manager = attributes.profiler:getRoleData("manager")

manager.CATCHABLE_EVENTS = {
	timeline.EVENTS.NEW_DAY,
	timeline.EVENTS.NEW_WEEK,
	team.EVENTS.MANAGER_ASSIGNED,
	developer.EVENTS.WORKPLACE_SET
}
task:getData("price_research_task").CATCHABLE_EVENTS = {
	studio.EVENTS.RELEASED_GAME
}

local genericRemoveEvents = {
	project.EVENTS.SCRAPPED_PROJECT,
	gameProject.EVENTS.GAME_OFF_MARKET
}

scheduledEvents:getData("screenshots_evaluation").CATCHABLE_EVENTS = genericRemoveEvents
scheduledEvents:getData("demo_evaluation").CATCHABLE_EVENTS = genericRemoveEvents
scheduledEvents:getData("game_edition_reaction").CATCHABLE_EVENTS = genericRemoveEvents

local updateOnEventGeneric = {
	[studio.expansion.EVENTS.POST_PLACED_OBJECT] = true,
	[studio.expansion.EVENTS.POST_REMOVED_OBJECT] = true,
	[studio.expansion.EVENTS.BOUGHT_WALL] = true,
	[studio.expansion.EVENTS.REMOVED_WALL] = true
}

objectiveHandler:getTaskData("have_workplaces").updateOnEvent = updateOnEventGeneric
objectiveHandler:getTaskData("have_objects").updateOnEvent = updateOnEventGeneric
