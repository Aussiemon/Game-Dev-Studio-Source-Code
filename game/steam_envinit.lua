local e = {}

MODENV = e
e.string = string
e.math = math
e.assert = assert
e.error = error
e.getmetatable = getmetatable
e.ipairs = ipairs
e.next = next
e.pcall = pcall
e.print = print
e.rawequal = rawequal
e.rawget = rawget
e.rawlen = rawlen
e.rawset = rawset
e.select = select
e.setmetatable = setmetatable
e.tonumber = tonumber
e.tostring = tostring
e.type = type
e.xpcall = xpcall
e.pairs = pairs
e.unpack = unpack
e.coroutine = coroutine
e.math = math
e.table = table
e.utf8 = require("utf8")
e.love = {
	graphics = love.graphics,
	image = love.image,
	audio = love.audio,
	event = love.event,
	font = love.font,
	keyboard = love.keyboard,
	joystick = love.joystick,
	math = love.math,
	mouse = love.mouse,
	physics = love.physics,
	sound = love.sound,
	timer = love.timer,
	video = love.video,
	window = love.window,
	nonTextKeys = love.nonTextKeys,
	filesystem = {
		isFile = love.filesystem.isFile
	}
}
e.registered = registered
e.register = register
e.gui = gui
e.tdas = tdas
e.bitser = bitser
e.camera = camera
e.collision = collision
e.configLoader = configLoader
e.coroutineManager = coroutineManager
e.cullingTester = cullingTester
e.events = events
e.cache = cache
e.fonts = fonts
e.frameBuffer = frameBuffer
e.gameStateService = gameStateService
e.hook = hook
e.inputService = inputService
e.json = json
e.keyBinding = keyBinding
e.layerRenderer = layerRenderer
e.tileGrid = tileGrid
e.objectGrid = objectGrid
e.particleEffects = particleEffects
e.particleSystem = particleSystem
e.pf = pf
e.priorityRenderer = priorityRenderer
e.quadLoader = quadLoader
e.scaling = scaling
e.shaders = shaders
e.sound = sound
e.spriteDataContainer = spriteDataContainer
e.spritesheetParser = spritesheetParser
e.tileGridVisibilityHandler = tileGridVisibilityHandler
e.timer = timer
e.translation = translation
e.util = util
e.spriteBatchController = spriteBatchController
e.maps = maps
e.sounds = sounds
e.resolutionHandler = resolutionHandler
e.QuadTree = QuadTree
e.bit = bit
e._T = _T
e._format = _format
e._S = _S
e._US = _US
e.color = color
e.getFrameTime = getFrameTime
e.autosave = autosave
e.pathfinderThread = pathfinderThread
e.game = game
e.ambientSounds = ambientSounds
e.bookController = bookController
e.brightnessMap = brightnessMap
e.characterDesigner = characterDesigner
e.employeeCirculation = employeeCirculation
e.entity = entity
e.eventBoxText = eventBoxText
e.financeHistory = financeHistory
e.hintSystem = hintSystem
e.interactionRestrictor = interactionRestrictor
e.letsPlayers = letsPlayers
e.lightingManager = lightingManager
e.monthlyCost = monthlyCost
e.motivationalSpeeches = motivationalSpeeches
e.musicPlayback = musicPlayback
e.musicPlaylist = musicPlaylist
e.pathCaching = pathCaching
e.pedestrianController = pedestrianController
e.playthroughStats = playthroughStats
e.preferences = preferences
e.projectLoader = projectLoader
e.serverRenting = serverRenting
e.team = team
e.timeOfDay = timeOfDay
e.timeline = timeline
e.trends = trends
e.unlocks = unlocks
e.weather = weather
e.frameController = frameController
e.activities = activities
e.contractWork = contractWork
e.contractor = contractor
e.contractData = contractData
e.developerActions = developerActions
e.developer = developer
e.attributes = attributes
e.avatar = avatar
e.carryObjects = carryObjects
e.conversations = conversations
e.factValidity = factValidity
e.interests = interests
e.knowledge = knowledge
e.names = names
e.portrait = portrait
e.skills = skills
e.statusIcons = statusIcons
e.traits = traits
e.dialogueHandler = dialogueHandler
e.dialogue = dialogue
e.engine = engine
e.engineLicensing = engineLicensing
e.engineStats = engineStats
e.advertisement = advertisement
e.audience = audience
e.contentPoints = contentPoints
e.genres = genres
e.patchProject = patchProject
e.gameProject = gameProject
e.gameQuality = gameQuality
e.themes = themes
e.gameConventions = gameConventions
e.yearlyGoalController = yearlyGoalController
e.interview = interview
e.interviewTopics = interviewTopics
e.logicPieces = logicPieces
e.mainMenu = mainMenu
e.projectsMenu = projectsMenu
e.menuCreator = menuCreator
e.objectiveHandler = objectiveHandler
e.objective = objective
e.objects = objects
e.objectCategories = objectCategories
e.platform = platform
e.playerPlatform = playerPlatform
e.platformShare = platformShare
e.consoleManufacturer = consoleManufacturer
e.consoleManufacturers = consoleManufacturers
e.platformParts = platformParts
e.platforms = platforms
e.complexProject = complexProject
e.project = project
e.issues = issues
e.projectTypes = projectTypes
e.devStage = devStage
e.randomEvents = randomEvents
e.review = review
e.reviewer = reviewer
e.reviewers = reviewers
e.projectReview = projectReview
e.rivalGameCompany = rivalGameCompany
e.rivalGameCompanies = rivalGameCompanies
e.scheduledEvents = scheduledEvents
e.studio = studio
e.employeeAssignment = employeeAssignment
e.interactionController = interactionController
e.objectSelector = objectSelector
e.officeBuilding = officeBuilding
e.officeBuildingInserter = officeBuildingInserter
e.room = room
e.task = task
e.taskTypes = taskTypes
e.floorTileGrid = floorTileGrid
e.floorTileGridRenderer = floorTileGridRenderer
e.objectGridRenderer = objectGridRenderer
e.obstructionGrid = obstructionGrid
e.floors = floors
e.walls = walls
e.world = world
e.MOD = true
