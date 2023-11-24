gameProject = {}

setmetatable(gameProject, engine.mtindex)

gameProject.mtindex = {
	__index = gameProject
}
gameProject.PROJECT_TYPE = "game"
gameProject.PROJECT_TASK_CLASS = "game_task"
gameProject.MIN_GENRES_FOR_SUBGENRE = 6
gameProject.STARTED_GAMES_FACT = "started_games"
gameProject.SCRAPPED_GAMES_FACT = "scrapped_games"
gameProject.FINISHED_GAMES_FACT = "released_games"
gameProject.REVEALED_BRIBE_COUNT_FACT = "revealed_bribe_count"
gameProject.TOTAL_LOST_REPUTATION_TO_BRIBES = "total_lost_rep_to_bribes"
gameProject.QA_SESSION_END_TIME = "qa_session_end_time"
gameProject.QA_SESSION_START_TIME = "qa_session_start_time"
gameProject.QA_SESSIONS_FACT = "qa_session_fact"
gameProject.REMOVED_FROM_EVENT_RECEIVING = "removed_from_event_receiving"
gameProject.MENTIONED_REPETITIVENESS_FACT = "mentioned_repetitiveness"
gameProject.PRICING_MANAGER_DIALOGUE = "manager_pricing_dialogue"
gameProject.MMO_CAPACITY_DIALOGUE = "mmo_capacity_dialogue"
gameProject.MMO_CAPACITY_USE_PERCENTAGE = 0.7
gameProject.PERSPECTIVE_CATEGORY = "game_perspective"
gameProject.MICROTRANSACTIONS_CATEGORY = "microtransactions_category"
gameProject.DRM_CATEGORY = "game_drm"
gameProject.DRM_TASK = "game_drm"
gameProject.RELEASE_GAME_BUTTON_ID = "release_game_button"
gameProject.ADDED_TO_GAME_LIST_FACT = "added_to_game_list"
gameProject.REVIEW_CONVERSATION_TOPIC = "game_review"
gameProject.TALKED_ABOUT_REVIEWS_FACT = "talked_about_reviews"
gameProject.EVALUATED_CONTENT_FACT = "evaluated_content"
gameProject.NOTIFIED_OF_REVIEW_REP_DROP = "reputation_review_drop"
gameProject.OUTSOLD_DEV_COSTS_AMOUNT = 1.25
gameProject.OUTSOLD_DEV_COSTS_TOPIC = "outsold_dev_costs_topic"
gameProject.TALKED_ABOUT_OUTSELLING_DEV_COSTS_FACT = "talked_about_outselling_dev_costs"
gameProject.MAX_NAME_SYMBOLS = 35
gameProject.TESTING_SESSIONS = 60
gameProject.POPULARITY_TO_TIME_SALE_AFFECTOR = 2000
gameProject.MAX_TIME_SALE_AFFECTOR_FROM_POPULARITY = 5
gameProject.STATIC_PURCHASING_POWER_LOSS = 0.33
gameProject.DYNAMIC_PURCHASING_POWER_LOSS = 0.67
gameProject.SOLD_GAME_COPIES_FACT = "sold_game_copies"
gameProject.MAX_OF_PLATFORM_USERS_TO_SALE = 0.3
gameProject.TIME_SALE_AFFECTOR_MULTIPLIER = 0.5
gameProject.SCALE_TO_WORKAMOUNT_MAX = 0.9
gameProject.SCALE_TO_FEATURE_COUNT_MAX = 0.9
gameProject.SCALE_TO_FEATURE_PRICE_DELTA_MULTIPLIER = 0.125
gameProject.SALE_BOOST_PER_POSITIVE_SCALE_PRICE_RELATION = 0.25
gameProject.MAX_EXTRA_INTEREST = 5000
gameProject.MAX_FINAL_INTEREST = 20000
gameProject.MINIMUM_INTEREST_GAIN = 0.01
gameProject.DEVELOPMENT_CATEGORIES = {
	gameProject.PERSPECTIVE_CATEGORY,
	"game_story",
	"game_dialogue",
	"game_world_design",
	"game_gameplay",
	"game_graphics",
	"game_audio",
	gameProject.MICROTRANSACTIONS_CATEGORY,
	gameProject.DRM_CATEGORY
}
gameProject.MMO_DEVELOPMENT_CATEGORIES = {
	"game_mmo_progression",
	"game_mmo_difficulty",
	"game_mmo_death_penalty",
	"game_mmo_combat",
	"game_mmo_misc"
}

table.insertContents(gameProject.DEVELOPMENT_CATEGORIES, gameProject.MMO_DEVELOPMENT_CATEGORIES)
table.removeObject(gameProject.MMO_DEVELOPMENT_CATEGORIES, gameProject.DRM_CATEGORY)

gameProject.OPTIONAL_DEVELOPMENT_CATEGORIES = {
	game_mmo_misc = true,
	[gameProject.MICROTRANSACTIONS_CATEGORY] = true,
	[gameProject.DRM_CATEGORY] = true
}
gameProject.CONTENT_DEVELOPMENT_CATEGORIES = {
	"game_content"
}
gameProject.DEVELOPMENT_TYPE = {
	PATCH = "new_patch",
	NEW = "new_game",
	MMO = "new_mmo",
	EXPANSION = "new_expansion"
}
gameProject.DEVELOPMENT_TYPE_ORDER = {
	gameProject.DEVELOPMENT_TYPE.NEW,
	gameProject.DEVELOPMENT_TYPE.EXPANSION,
	gameProject.DEVELOPMENT_TYPE.MMO
}
gameProject.SEQUEL_DEV_TYPES = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true,
	[gameProject.DEVELOPMENT_TYPE.MMO] = true
}
gameProject.PIRATEABLE_DEV_TYPES = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true,
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = true
}
gameProject.DEVELOPMENT_TYPE_TEXT = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = _T("FULL_GAME", "Full game"),
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = _T("EXPANSION", "Expansion pack"),
	[gameProject.DEVELOPMENT_TYPE.MMO] = _T("GAME_MMO", "MMO"),
	[gameProject.DEVELOPMENT_TYPE.PATCH] = _T("GAME_PATCH", "Patch")
}
gameProject.CREATE_TASKS_ON_DEV_TYPE = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true,
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = true,
	[gameProject.DEVELOPMENT_TYPE.MMO] = true
}
gameProject.CONTENT_POINTS_ON_DEV_TYPE = {
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = true
}
gameProject.SCALE = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = {
		1,
		20
	},
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = {
		1,
		8
	},
	[gameProject.DEVELOPMENT_TYPE.MMO] = {
		1,
		20
	}
}
gameProject.DEFAULT_DEV_TYPES = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true,
	[gameProject.DEVELOPMENT_TYPE.MMO] = true
}
gameProject.NEW_GAME_DEV_TYPES = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true
}
gameProject.EXPANSION_DEV_TYPES = {
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = true
}
gameProject.PUBLISHABLE_GAME_TYPES = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true
}
gameProject.GENRE_BONUS_TYPES = {
	LONG_TIME_AGO = 2,
	NO_GAMES_MADE_BEFORE = 1
}
gameProject.ISSUE_COMPLAINTS = {
	HIGH = 3,
	LOW = 1,
	MEDIUM = 2
}
gameProject.MICROTRANSACTIONS_DEV_CATEGORIES = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true,
	[gameProject.DEVELOPMENT_TYPE.MMO] = true
}
gameProject.POPULARITY_SCORE_AFFECTOR = {
	{
		minScore = 0,
		start = 0.01,
		maxScore = 3,
		finish = 0.1
	},
	{
		minScore = 3,
		start = 0.1,
		maxScore = 6,
		finish = 0.4
	},
	{
		minScore = 6,
		start = 0.4,
		maxScore = 8,
		finish = 0.7
	},
	{
		minScore = 8,
		start = 0.7,
		maxScore = 10,
		finish = 1
	}
}
gameProject.ASK_FOR_MORE_CONTENT_RATING = 8
gameProject.ASK_FOR_MORE_MIN_SALES = 100000
gameProject.ASK_FOR_MORE_MAX_TIME = 20
gameProject.MAXIMUM_VARIETY_PENALTY = 0.25
gameProject.MIN_DELTA_FOR_PENALTY = 200
gameProject.VARIETY_PENALTY_MIN_DELTA = 0.25
gameProject.CONTENT_TO_PRICE_MAXIMUM_PENALTY = 0.1
gameProject.CONTENT_TO_PRICE_RELATION = 50
gameProject.CONTENT_DELTA_TO_PENALTY = 0.05
gameProject.CONTENT_AFFECTOR_MINIMUM_NOTIFY = 0.9
gameProject.EXPANSION_SALE_DROP_OFF_TIME_PERIOD = timeline.DAYS_IN_YEAR * 1.5
gameProject.EXPANSION_SALE_DROP_OFF_TIME_SPEED = timeline.DAYS_IN_YEAR
gameProject.EXPANSION_SALE_DROP_OFF_EXPONENT = 2
gameProject.MAX_EXPANSION_SALE_DROP_OFF = 4
gameProject.THEME_SALE_AFFECTOR_MULTIPLIER = 0.5
gameProject.INTEREST_TO_PLATFORM_INTEREST = 0.4
gameProject.ISSUE_EVALUATION_MINIMUM_DAYS_PASSED = 3
gameProject.ISSUE_EVALUATION_MINIMUM_SALES = 50
gameProject.ISSUE_COMPLAINTS_LEVEL = {
	[gameProject.ISSUE_COMPLAINTS.LOW] = 1.2,
	[gameProject.ISSUE_COMPLAINTS.MEDIUM] = 1.8,
	[gameProject.ISSUE_COMPLAINTS.HIGH] = 2.3
}
gameProject.ISSUE_COMPLAINTS_TEXT = {
	[gameProject.ISSUE_COMPLAINTS.LOW] = _T("ISSUES_COMPLAINT_LOW", "Players of 'GAME' are complaining about a small, but annoying amount of issues in the game. This slightly affects the sales of the game."),
	[gameProject.ISSUE_COMPLAINTS.MEDIUM] = _T("ISSUES_COMPLAINT_MEDIUM", "Players of 'GAME' are complaining about a small, but annoying amount of issues in the game. This affects the sales of the game."),
	[gameProject.ISSUE_COMPLAINTS.HIGH] = _T("ISSUES_COMPLAINT_HIGH", "Players of 'GAME' are complaining about a large amount of issues. This greatly affects the sales of the game.")
}
gameProject.BASE_QA_TIME = 4
gameProject.SCALE_TO_EXTRA_QA_TIME = 3
gameProject.QA_ISSUE_DISCOVER_MIN_CHANCE = 10
gameProject.QA_ISSUE_DISCOVER_MAX_CHANCE = 85
gameProject.QA_ISSUE_DISCOVER_CHANCE_DIVIDER = 100
gameProject.QA_DISCOVER_ATTEMPTS = {
	20,
	30
}
gameProject.QA_BASE_COST = 3000
gameProject.QA_COST_PER_DAY = 1000
gameProject.QA_COST_SCALE_MULTIPLIER = 0.5
gameProject.QA_COST_ROUNDING_SEGMENT = 500
gameProject.ISSUE_DISCOVERY_MINIMUM_FACTOR = 0.15
gameProject.ISSUE_DISCOVERY_MAXIMUM_FACTOR = 0.8
gameProject.MAXIMUM_SCORE_BEFORE_FACTOR_DROP = 7
gameProject.AUDIENCE_TO_DISCOVERY_DIVIDER = 200
gameProject.MAXIMUM_ISSUES_DISCOVERED_PER_DAY = 25
gameProject.MIN_REPETITIVENESS_FOR_PENALTY = 6
gameProject.UNIQUE_REPETITIVENESS_PREVENTION = 6
gameProject.REPETITIVENESS_PENALTY_TO_DIVIDER = 0.2
gameProject.MAX_TIME_DIFFERENCE = timeline.DAYS_IN_YEAR * 10
gameProject.BASE_REPUTATION_PER_REVIEW = 1500
gameProject.NEGATIVE_REPUTATION_CUTOFF = 3
gameProject.REVIEW_REPUTATION_CHANGE_RANDOM = {
	-0.16,
	0.16
}
gameProject.SCORE_SALE_MULTIPLIER = 0.5
gameProject.MAX_SCORE_SALE_MULTIPLIER = 5
gameProject.MAX_EXTRA_SALES_FROM_SCALING = 3
gameProject.MIN_SALE_MULTIPLIER_FROM_SCALING = 0.1
gameProject.SALE_SCALE_DROP_EXPONENT = 1.5
gameProject.MAX_SCALE_OFFSET = 0.7
gameProject.MINIMUM_SALE_MULTIPLIER_FROM_PRICE = 0.1
gameProject.POPULARITY_TO_EXTRA_SALES = 0.2
gameProject.HYPE_TO_EXTRA_SALES = 0.8
gameProject.EXTRA_REPUTATION_POPULARITY_SALES = 0.33
gameProject.MINIMUM_RATING_SALE_MULTIPLIER = 0.1
gameProject.RATING_SALE_MULTIPLIER_EXPONENT = math.log(9.5, 10)
gameProject.OVERALL_SALE_MULTIPLIER = 0.13
gameProject.RATING_SALE_TIME_REDUCTION_EXPONENT = 1.15
gameProject.RATING_SALE_TIME_REDUCTION_MULTIPLIER = 0.15
gameProject.PERCENTAGE_OF_INITIAL_SALES_ON_MARKET = 0.025
gameProject.PERCENTAGE_OF_INITIAL_SALES_ON_MARKET_RETURN = 0.125
gameProject.MIN_SALES_OFFMARKET_INCREASE = 5
gameProject.LOWEST_RATING_SALE_MULTIPLIER_DAYS_FACT = "lowest_rating_sale_multiplier_days"
gameProject.FULL_SALE_POWER_TIME = timeline.DAYS_IN_WEEK * 2
gameProject.SALE_ATTEMPTS_UNTIL_NO_SALES = 10
gameProject.REPUTATION_SALE_MULTIPLIER = 0.5
gameProject.MANDATORY_STAGE_TASK_CATEGORIES = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = {
		{
			"mandatory_game_stage1"
		},
		{
			"mandatory_game_stage2"
		},
		{
			"optional_game_polishing_stage"
		}
	},
	[gameProject.DEVELOPMENT_TYPE.EXPANSION] = {
		{
			"mandatory_game_stage_content_pack_1"
		},
		{
			"mandatory_game_stage_content_pack_2"
		},
		{
			"optional_game_polishing_stage"
		}
	},
	[gameProject.DEVELOPMENT_TYPE.MMO] = {
		{
			"mandatory_game_stage1",
			"mandatory_mmo_stage1"
		},
		{
			"mandatory_game_stage2",
			"mandatory_mmo_stage2"
		},
		{
			"optional_game_polishing_stage"
		}
	}
}
gameProject.MAX_SALES_PER_PLATFORM = 0.5
gameProject.MANDATORY_STAGES_TO_COMPLETE = {
	1,
	2
}
gameProject.SECOND_STAGE = "mandatory_game_stage2"
gameProject.CONCEPT_STAGE = 1
gameProject.DEVELOPMENT_STAGE = 2
gameProject.POLISHING_STAGE = 3
gameProject.QUALITY_SALE_MULT_INTEREST_REQUIREMENT = 7500
gameProject.STAGE_TEXT = {
	_T("GAME_STAGE_DESIGN_AND_CONCEPT", "Design & concept"),
	_T("GAME_STAGE_DEVELOPMENT", "Development"),
	(_T("GAME_STAGE_POLISHING", "Polishing"))
}
gameProject.STAGE_COLORS = {
	color(255, 236, 170, 255),
	color(200, 255, 170, 255),
	(color(170, 214, 255, 255))
}
gameProject.ANNOUNCED_FACT = "game_was_announced"
gameProject.REACTED_TO_ANNOUNCEMENT = "reacted_to_announcement"
gameProject.RELEASED_GAME = "released_game"
gameProject.EVENTS = {
	BEGAN_WORK = events:new(),
	FINISHED_GAME = events:new(),
	SET_PREQUEL = events:new(),
	ANNOUNCED = events:new(),
	CHANGED_PRICE = events:new(),
	REACHED_RELEASE_STATE = events:new(),
	DEVELOPMENT_TYPE_CHANGED = events:new(),
	NEW_REVIEW = events:new(),
	CHANGED_GENRE = events:new(),
	CHANGED_THEME = events:new(),
	GAME_OFF_MARKET = events:new(),
	SCALE_CHANGED = events:new(),
	WORK_PERIOD_EXTENDED = events:new(),
	CATEGORY_PRIORITY_CHANGED = events:new(),
	OPENED_INTERACTION_MENU = events:new(),
	PLATFORM_STATE_CHANGED = events:new(),
	PUBLISHER_SET = events:new(),
	AUDIENCE_CHANGED = events:new(),
	ENGINE_CHANGED = events:new(),
	ISSUE_DISCOVERED = events:new(),
	ISSUE_FIXED = events:new(),
	COPIES_SOLD = events:new(),
	UPDATE_SALE_DISPLAY = events:new(),
	QA_OVER = events:new(),
	QA_PROGRESSED = events:new(),
	TREND_CONTRIBUTION_UPDATED = events:new(),
	INITIAL_FINISH = events:new(),
	PRE_RELEASE_VERIFICATION = events:new(),
	SUBGENRE_CHANGED = events:new(),
	FILL_GAME_INFO_SCROLLER = events:new(),
	INHERITED_PROJECT_SETUP = events:new(),
	EDITION_ADDED = events:new(),
	EDITION_REMOVED = events:new(),
	ADVERT_MENU_OPENED = events:new()
}
gameProject.ON_FINISHED_FIRE_EVENT = gameProject.EVENTS.FINISHED_GAME
gameProject.AUTO_ADD_INTERVIEW_COOLDOWN = timeline.DAYS_IN_MONTH * 2.5
gameProject.GLOBAL_AUTO_ADD_INTERVIEW_COOLDOWN = 3
gameProject.MAX_AUTO_ADD_INTERVIEW_CHANCE = 30
gameProject.MAX_INTERVIEWS_PER_REVIEWER = 2
gameProject.REVEAL_REPUTATION_AFFECTOR = 0.1
gameProject.REVEAL_MINIMUM_REVEAL_TIME_DIFFERENCE = timeline.DAYS_IN_YEAR
gameProject.REVEAL_EARLY_REVEAL_PENALTY = 2
gameProject.REVEAL_BOOST_PER_DAY = 0.5
gameProject.REVEAL_BOOST_MAX = timeline.DAYS_IN_YEAR * gameProject.REVEAL_BOOST_PER_DAY * 4
gameProject.REVEAL_SCORE_TO_REPUTATION = 0.01
gameProject.REVEAL_AVG_SCORE_OF_PREV_GAME_MINIMUM = 6
gameProject.REVEAL_PREV_GAME_SCORE_DELTA_AFFECTOR = 200
gameProject.REVEAL_PREV_GAME_POPULARITY_AFFECTOR = 0.01
gameProject.REVEAL_PLAYERBASE_AFFECTOR = 0.001
gameProject.REVEAL_PLAYERBASE_REP_LOWER_BOUND = 60000
gameProject.REVEAL_PLAYERBASE_AFFECTOR_RANDOM = {
	0.75,
	1.25
}
gameProject.REVEAL_SCORE_TO_POPULARITY = 0.1
gameProject.REVEAL_NEW_GENRE_AFFECTOR = 0.15
gameProject.REVEAL_NEW_GENRE_MINIMUM_REPUTATION = 2000
gameProject.REVEAL_NOT_EXCITED_AVERAGE_SCORE = 6
gameProject.REVEAL_NOT_EXCITED_NEW_GENRE_AFFECTOR = 0.005
gameProject.PRIORITY_MIN = 0.25
gameProject.PRIORITY_MAX = 1
gameProject.POPULARITY_TO_FADE_AFFECTOR = 0.25
gameProject.POPULARITY_TO_FADE_SPEED_DECREASE = 0.1
gameProject.POPULARITY_FADE_SPEED_PER_DAY = 1
gameProject.POPULARITY_DECREASE_SPEED_PER_DAY = 0.75
gameProject.POPULARITY_MULTIPLIER = 0.25
gameProject.MAX_POPULARITY_FADE_VALUE = 1000
gameProject.REPUTATION_DECREASE_MINIMUM_POPULARITY = 1000
gameProject.REPUTATION_LOSS_PER_POP_POINT = 0.1
gameProject.PLATFORM_HYPE_DIVIDER = 0.5
gameProject.PLATFORM_HYPE_BASE_DIVIDER = 1
gameProject.PREVIOUS_GAME_EXTRA_SALES_RATING_CUTOFF = -6
gameProject.MINIMUM_TIME_TO_SEQUEL = timeline.DAYS_IN_WEEK * timeline.WEEKS_IN_MONTH * 8
gameProject.SEQUEL_LOW_TIME_PENALTY = 0.7
gameProject.MIN_SEQUEL_TIME_BONUS_MULTIPLIER = 1
gameProject.MAX_SEQUEL_TIME_BONUS_MULTIPLIER = 1.5
gameProject.TIME_DIFFERENCE_EXPONENT = 1.15
gameProject.TIME_DIFFERENCE_DIVIDER = 1000
gameProject.DEFAULT_POPULARITY_TO_REPUTATION_MULT = 0.02
gameProject.SALE_POST_TAX_PERCENTAGE = 0.8
gameProject.REPUTATION_GAIN_FROM_POPULARITY_WITH_CONTRACTOR = 0.1
gameProject.MAX_WORK_PERIOD_EXTENDS = 3
gameProject.HYPE_COUNTER_INCREASE = 1
gameProject.BASE_HYPE_RATING = 5
gameProject.BASE_HYPE_COUNTER_VALUE = 4
gameProject.BASE_HYPE_RATING_OFFSET = 0.5
gameProject.MULTIPLIER_PER_HYPE_COUNTER = 0.05
gameProject.MAX_HYPE_COUNTERS = 4
gameProject.HYPE_MAX_REP_LOSS = 0.9
gameProject.DEFAULT_POP_GAIN_LIMITER_MULTIPLIER = 1
gameProject.REVIEW_REPUTATION_GAIN_PER_SCALE_POINT = 6000
gameProject.REVIEW_REPUTATION_CUTOFF = 8000
gameProject.REVIEW_REPUTATION_CUTOFF_PENALTY_MULTIPLIER = 0.2
gameProject.REVIEW_REPUTATION_MIN_REP_GAIN = 0.1
gameProject.REVIEW_REPUTATION_MAX_REP_GAIN = 1
gameProject.MAX_REVIEW_REP_GAIN_SCALE = 0.8
gameProject.MAX_REVIEW_REP_GAIN = 1
gameProject.MIN_REVIEW_REP_GAIN = 0.05
gameProject.MIN_REVIEW_REP_GAIN_REPUTATION = 20000
gameProject.MIN_REVIEW_REP_GAIN_UPPER_LIMIT = 0.55
gameProject.TIME_SALE_AFFECTOR_CHANGE_MULTIPLIER = 0.5
gameProject.RETURNABLE_TO_MARKET = {
	[gameProject.DEVELOPMENT_TYPE.NEW] = true
}
gameProject.REVEAL_MAIN_REACTION = {
	{
		score = 0,
		text = _T("REACTION_NOONE", "The reveal was met by either a minimal amount of people or no one at all.")
	},
	{
		score = 200,
		text = _T("REACTION_MINIMAL", "The reveal was met by very few people.")
	},
	{
		score = 1000,
		text = _T("REACTION_SMALL", "The reveal was met by few people.")
	},
	{
		score = 3000,
		text = _T("REACTION_SOME", "The reveal was met by some people.")
	},
	{
		score = 5000,
		text = _T("REACTION_DECENT", "The reveal was met by a decent amount of people.")
	},
	{
		score = 10000,
		text = _T("REACTION_NICE", "The reveal was met by a nice amount of people")
	},
	{
		score = 20000,
		text = _T("REACTION_BIG", "The reveal was met with a lot of people.")
	},
	{
		score = 50000,
		text = _T("REACTION_HUGE", "The reveal was met with a huge amount of people.")
	}
}
gameProject.EDITIONS = {
	priceToEditionSaleBase = 100,
	valueToPriceDeltaDrop = 0.07,
	basePriceOffset = 10,
	basePriceMult = 2,
	max = 7,
	penalty = {
		cutoff = 5,
		exponent = 2,
		multiplier = 2,
		dividerOpinion = 0.32,
		poorValueRepLoss = 250,
		poorValueOpiLoss = 2,
		divider = 50
	},
	bonus = {
		maxSaleBoost = 0.4,
		boostExponent = 0.5,
		goodValueRepGain = 40,
		goodValueOpiGain = 0.2
	}
}
gameProject.PIRACY = {
	maxPiracy = 0.9,
	minPiracy = 0.04,
	ratingExponent = 1.5,
	minPiracySafe = 0.01,
	safeRepEnd = 10000,
	maxPenaltyDelta = 200,
	opinionPerRep = 200,
	maxPenaltyChange = 150,
	dialogueFact = "piracy_dialogue_shown",
	maxOpinionValue = 800,
	base = 150,
	safeRep = 5000,
	ratingDeltaMult = 2,
	ratingCutoff = 9,
	ratingDeltaDiv = 2,
	dialogueThreshold = 0.1,
	maxPenaltyChangeExponent = math.log(150, 200)
}
gameProject.DRM = {
	opinionDeltaMax = 200,
	opinionReduction = 0.02,
	base = 1,
	increasePerPoint = 0.2,
	randomRange = {
		0.9,
		1.25
	}
}
gameProject.OPINION = {
	baseGain = 20,
	drmPenalty = 3,
	maxOpinionLoss = -10,
	minOpinionGain = 0,
	opinionReviewLerp = 0.25,
	maxGainRating = 8,
	round = 1,
	noOpinionGainRating = 3,
	maxReduction = 10,
	minGainRating = 5,
	drmPenaltyMultiplier = 3,
	reductionRep = {
		10000,
		50000
	}
}
gameProject.DEMO = {
	cutoff = 5,
	repAffectorNegative = 7000,
	repAffectorPositive = 10000,
	popGainMax = math.log(4000, 5),
	popLossMax = math.log(8000, 4)
}
gameProject.GAME_TYPE_VALIDITY_CHECKS = {}

function gameProject.registerGametypeValidityCheck(id, func)
	gameProject.GAME_TYPE_VALIDITY_CHECKS[id] = func
end

gameProject.registerGametypeValidityCheck(gameProject.DEVELOPMENT_TYPE.MMO, function(projObj)
	return studio:isFeatureResearched(gameProject.MMO_RESEARCH_TASK)
end)

gameProject.GAME_TYPE_SALE_AFFECTOR = {}

function gameProject.registerSaleMultiplier(gameType, callback)
	gameProject.GAME_TYPE_SALE_AFFECTOR[gameType] = callback
end

gameProject.registerSaleMultiplier(gameProject.DEVELOPMENT_TYPE.MMO, function(gameProj)
	local mmo = gameProj.mmoLogic
	
	return gameProj.mmoSaleAffector * mmo:getLongevitySaleAffector() * gameProject.MMO_BASE_SALE_MULT * math.min(1, mmo:getAttractiveness()), 1
end)
gameProject.registerSaleMultiplier(gameProject.DEVELOPMENT_TYPE.EXPANSION, function(gameProj)
	local saleMult = 1
	
	if gameProj:getFact(gameProject.MMO_EXPANSION_PACK_COOLDOWN_FACT) then
		saleMult = saleMult * gameProject.MMO_EXPANSION_PACK_COOLDOWN
	end
	
	if gameProj.isMMO then
		local mmo = gameProj.sequelTo.mmoLogic
		
		saleMult = saleMult * mmo:getLongevitySaleAffector() * math.min(1, mmo:getAttractiveness())
	end
	
	return saleMult, 1
end)

gameProject.GAME_TYPE_RELEASE_CALLBACK = {}

function gameProject.registerReleaseCallback(gameType, callback)
	gameProject.GAME_TYPE_RELEASE_CALLBACK[gameType] = callback
end

gameProject.MMO_ATTRACTIVENESS_FACT = "mmo_attractiveness"
gameProject.MMO_CONTENT_AMOUNT_FACT = "mmo_content"
gameProject.MMO_COMPLEXITY_FACT = "mmo_complexity"
gameProject.MMO_SUBSCRIPTION_FEE_FACT = "mmo_sub_fee"
gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID = "mmo_subscriptions"
gameProject.MMO_SALE_AFFECTOR = "mmo_sale_affector"
gameProject.MMO_BASE_COMPLEXITY = 0
gameProject.MMO_EXPANSION_PACK_COOLDOWN_FACT = "mmo_exp_cooldown"
gameProject.MMO_EXPANSION_PACK_COOLDOWN = 0.2
gameProject.MMO_EXPANSION_POPULARITY_TRANSFER = 0.25
gameProject.MMO_MAX_PLATFORMS = 2
gameProject.MMO_BASE_SALE_MULT = 0.5
gameProject.EXPANSION_POPULARITY_TRANSFER = 0.4
gameProject.CONTENT_TO_TIME_SALE_AFFECTOR_DIVIDER = 8

gameProject.registerReleaseCallback(gameProject.DEVELOPMENT_TYPE.MMO, function(gameProj)
	local taskList = gameProj:getMMOTasks()
	local taskMap = taskTypes.registeredByID
	local genre = gameProj:getGenre()
	local matchValue = 1
	local finalMult = 1
	
	for key, taskID in ipairs(taskList) do
		local data = taskMap[taskID]
		local mmoMatch = data.mmoMatch[genre]
		
		if mmoMatch then
			if mmoMatch < 1 then
				finalMult = finalMult * mmoMatch
			elseif mmoMatch > 1 then
				matchValue = matchValue + (mmoMatch - 1)
			end
		end
	end
	
	local finalValue = matchValue * finalMult
	
	gameProj:setFact(gameProject.MMO_ATTRACTIVENESS_FACT, finalValue)
	
	local totalContent, totalComplexity = gameProj:countMMOValues()
	
	gameProj:setFact(gameProject.MMO_CONTENT_AMOUNT_FACT, totalContent)
	gameProj:setFact(gameProject.MMO_COMPLEXITY_FACT, totalComplexity)
	
	local piece = logicPieces.create(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID)
	
	piece:setup(gameProj)
	gameProj:addLogicPiece(piece)
end)

gameProject.EXPANSION_POPULARITY_BOOST = {
	releaseMultiplier = 1,
	exponent = 1.5,
	maxPopularityNewGame = 15000,
	announceMultiplier = 0.8,
	newGamePopularityMult = 0.5,
	offset = 40,
	scaleToPointsMultiplier = 35,
	noBoostDivider = 15,
	divider = 60
}

gameProject.registerReleaseCallback(gameProject.DEVELOPMENT_TYPE.EXPANSION, function(gameProj)
	local sequelTo = gameProj:getSequelTo()
	
	if sequelTo:getGameType() == gameProject.DEVELOPMENT_TYPE.MMO then
		local totalContent = 0
		local taskMap = taskTypes.registeredByID
		
		for featureID, state in pairs(gameProj:getFeatures()) do
			local data = taskMap[featureID]
			
			totalContent = totalContent + data.mmoContent
		end
		
		gameProj:setFact(gameProject.MMO_CONTENT_AMOUNT_FACT, totalContent)
		sequelTo:getLogicPiece(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID):onReleaseExpansionPack(gameProj)
		sequelTo:changeTimeSaleAffector(-(totalContent / gameProject.TIME_SALE_AFFECTOR_MULTIPLIER))
		sequelTo:increasePopularity(gameProj:getPopularity() / gameProject.POPULARITY_MULTIPLIER * gameProject.MMO_EXPANSION_POPULARITY_TRANSFER)
	else
		sequelTo:boostPopularityFromExpansionPack(gameProj, gameProject.EXPANSION_POPULARITY_BOOST.releaseMultiplier)
	end
end)

function gameProject.findHighestAndLowestPrices()
	local highest, lowest = -math.huge, math.huge
	
	for key, price in ipairs(gameProject.PRICE_POINTS) do
		highest = math.max(highest, price)
		lowest = math.min(lowest, price)
	end
	
	gameProject.MIN_PRICE = lowest
	gameProject.MAX_PRICE = highest
end

function gameProject.sortPrices(a, b)
	return a < b
end

function gameProject.addPricePoint(price)
	table.insert(gameProject.PRICE_POINTS)
	table.sortl(gameProject.PRICE_POINTS, gameProject.sortPrices)
end

gameProject.PRICE_POINTS = {
	4.99,
	9.99,
	14.99,
	19.99,
	24.99,
	29.99,
	34.99,
	39.99,
	44.99,
	49.99,
	54.99,
	59.99
}
gameProject.SUBSCRIPTION_PRICE_POINTS = {
	4.99,
	7.49,
	9.99,
	11.49,
	14.99,
	17.49,
	19.99,
	22.49,
	24.99,
	26.49,
	29.99
}

gameProject.findHighestAndLowestPrices()

function gameProject.new(owner)
	local new = {}
	
	setmetatable(new, gameProject.mtindex)
	new:init(owner)
	
	return new
end

gameProject.SELECT_VERIFY_CALLBACK = {}

function gameProject.registerSelectionVerificationCallback(id, callback)
	gameProject.SELECT_VERIFY_CALLBACK[id] = callback
end

gameProject.MMO_SELECT_DIALOGUE_FACT = "mmo_first_select_dialogue"
gameProject.MMO_SELECT_DIALOGUE = "manager_mmo_setup_dialogue_1"

gameProject.registerSelectionVerificationCallback(gameProject.DEVELOPMENT_TYPE.MMO, function(projObj)
	if studio:getEmployeeCountByRole("manager") > 0 and not studio:getFact(gameProject.MMO_SELECT_DIALOGUE_FACT) then
		local manager = studio:getRandomEmployeeOfRole("manager")
		
		dialogueHandler:addDialogue(gameProject.MMO_SELECT_DIALOGUE, nil, manager)
		studio:setFact(gameProject.MMO_SELECT_DIALOGUE_FACT, true)
		
		return false
	end
	
	return true
end)

function gameProject:init(owner)
	engine.init(self, owner)
	
	self.employeeStatContribution = {}
	self.featureStatContribution = {}
	self.qualityPoints = {}
	
	for key, qualityData in ipairs(gameQuality.registered) do
		self.qualityPoints[qualityData.id] = 0
	end
	
	self.sales = 0
	self.editionPayment = 0
	
	self:setPopularity(0)
	self:setMomentPopularity(0)
	
	self.performedSubEvents = {}
	self.patches = {}
	self.platforms = {}
	self.manufacturerPlatformCount = {}
	self.reviews = {}
	self.reviewedBy = {}
	self.advertisements = {}
	self.salesByPlatform = {}
	self.moneyMadeByPlatform = {}
	self.categoryPriorities = {}
	self.totalDiscoveredQAIssues = {}
	self.discoveredQAIssues = {}
	self.currentQAIssues = {}
	self.interviewsOfferedByReviewer = {}
	self.knowledgeStatContribution = {}
	self.qualityFromKnowledge = {}
	self.interviewCooldown = {}
	self.activeAdvertisements = {}
	self.qualityByTasks = {}
	self.invalidTasks = {}
	self.editions = {}
	self.manufacturerCount = 0
	self.lastInterviewTime = 0
	self.totalQASessions = 0
	self.totalSales = 0
	self.totalSalesThisMonth = 0
	self.moneyMade = 0
	self.workExtends = 0
	self.offeredInterviews = 0
	self.shownInterviews = 0
	self.canEvaluateIssues = true
	self.rating = 0
	self.issueDiscoveryProgress = 0
	self.salesByWeek = {}
	self.highestSales = 0
	self.lastSales = 0
	self.lastMoneyMade = 0
	self.shareMoney = 0
	self.lastShareMoney = 0
	self.realMoneyMade = 0
	self.totalRealMoneyMade = 0
	self.selectedContent = 0
	self.platformCount = 0
	self.popularityFade = 0
	self.testers = 0
	self.popularityFadeSpeed = 0
	self.popularityDecreaseSpeed = 0
	self.timeSaleAffector = 0
	self.timeUntilPiracy = 0
	self.featureCountSaleAffector = 1
	self.platformScaleMax = gameProject.SCALE_MAX
	self.queuedBugFixAssignment = false
	self.tasksWithIssues = {}
	self.tasksWithIssuesMap = {}
	self.selectedTasksByCategory = {}
	self.drmValue = 0
	self.totalIssues, self.discoveredIssues, self.fixedIssues, self.accumulatedIssues = issues:initIssues()
	self.curDevType = gameProject.DEVELOPMENT_TYPE.NEW
	
	self:updatePirateableState()
	self:calculatePlatformWorkAmountAffector()
end

gameProject.concatMiscReaction = {}
gameProject.gameCountFormatMethods = {
	ru = function(amt)
		return translation.conjugateRussianText(amt, "%s игр", "%s игры", "%s игра")
	end
}

function gameProject:getGameCountString(amt)
	local method = self.gameCountFormatMethods[translation.currentLanguage]
	
	if method then
		return method(amt)
	end
	
	if amt == 1 then
		return _T("AMOUNT_OF_GAMES_SINGLE", "1 game")
	end
	
	return _format(_T("AMOUNT_OF_GAMES_MULTIPLE", "AMOUNT games"), "AMOUNT", amt)
end

function gameProject:boostPopularityFromExpansionPack(expPack, mult)
	local saleAffector = expPack:getExpansionSaleAffector()
	local points, divider, popVal
	local boost = gameProject.EXPANSION_POPULARITY_BOOST
	
	if expPack:getReleaseDate() then
		divider = ((timeline.curTime - expPack:getReleaseDate() - boost.offset) / boost.divider)^boost.exponent
		popVal = expPack:getPopularity()
	else
		divider = 1
		popVal = math.min(boost.maxPopularityNewGame, self:getPopularity() * boost.newGamePopularityMult)
	end
	
	if expPack:isNewGame() then
		points = self:getScale() * boost.scaleToPointsMultiplier
	else
		points = expPack:getTotalContentPoints()
	end
	
	if divider < boost.noBoostDivider then
		if self:isOffMarket() and self:canReturnToMarket() then
			self:returnToMarket()
		end
		
		self:changeTimeSaleAffector(-(points / gameProject.TIME_SALE_AFFECTOR_MULTIPLIER / gameProject.CONTENT_TO_TIME_SALE_AFFECTOR_DIVIDER / divider) * mult)
		self:increasePopularity(popVal / gameProject.POPULARITY_MULTIPLIER * gameProject.EXPANSION_POPULARITY_TRANSFER / divider * mult)
	end
end

function gameProject:getProjectStartCost()
	return self:getDesiredFeaturesCost() + self.editionPayment
end

function gameProject:addEdition(edition)
	self.editions[#self.editions + 1] = edition
	
	edition:setProject(self)
	self:updateEditionPayment()
	events:fire(gameProject.EVENTS.EDITION_ADDED, self, edition)
end

function gameProject:removeEdition(edition, menuIdx)
	if table.removeObject(self.editions, edition) then
		self:updateEditionPayment()
		events:fire(gameProject.EVENTS.EDITION_REMOVED, edition, menuIdx)
	end
end

function gameProject:hasEdition(edition)
	return table.find(self.editions, edition)
end

function gameProject:updateEditionPayment(shouldChangeFunds)
	self.editionPayment = gameEditions:calculateUpFrontCost(self)
	
	if not studio:isLoading() and self.paidEditionCost then
		local delta = self.editionPayment - self.paidEditionCost
		
		if delta > 0 then
			self.owner:deductFunds(delta)
		else
			self.owner:addFunds(-delta)
		end
		
		self.paidEditionCost = self.editionPayment
	end
end

function gameProject:evaluateEditions()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont("pix24")
	popup:setTitle(_T("GAME_EDITION_RESPONSE_TITLE", "Game Edition Response"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("GAME_EDITION_RESPONSE_DESC", "Fans of 'GAME' have reacted to its editions..."), "GAME", self.name))
	popup:hideCloseButton()
	
	local left, right, extra = popup:getDescboxes()
	local editCfg = gameProject.EDITIONS
	local penalty = editCfg.penalty
	local bonus = editCfg.bonus
	local editList = self.editions
	local editCount = #editList
	local editCountDelta = editCount - penalty.cutoff
	local repLoss = 0
	local opinionChange = 0
	local own = self.owner
	local wrapW = popup.rawW - 24
	local textResults = {}
	
	if editCountDelta > 0 then
		local editCountPenalty = (editCountDelta * penalty.multiplier)^penalty.exponent
		
		repLoss = repLoss + own:getReputation() * (editCountPenalty / penalty.divider)
		opinionChange = opinionChange - editCountPenalty / penalty.dividerOpinion
		
		table.insert(textResults, {
			_T("GAME_EDITION_PENALTY_TOO_MANY", "Players say there are too many various editions for the game."),
			"bh20",
			game.UI_COLORS.RED,
			"exclamation_point_red",
			22,
			22
		})
	end
	
	local price = self.price
	local goodValueGames, badValueGames = 0, 0
	
	for key, edit in ipairs(self.editions) do
		local markup = edit:getPrice() - price
		local value = edit:getValue()
		local priceVsValue = markup - value
		
		if priceVsValue > 0 then
			repLoss = repLoss + priceVsValue * penalty.poorValueRepLoss
			opinionChange = opinionChange - penalty.poorValueOpiLoss
			badValueGames = badValueGames + 1
		elseif priceVsValue < 0 then
			repLoss = repLoss + priceVsValue * bonus.goodValueRepGain
			opinionChange = opinionChange - priceVsValue * bonus.goodValueOpiGain
			goodValueGames = goodValueGames + 1
		else
			goodValueGames = goodValueGames + 1
		end
	end
	
	if badValueGames > 0 then
		table.insert(textResults, {
			_format(_T("GAME_EDITION_BONUS_BAD_VALUE", "Players said AMOUNT out of TOTAL game editions had bad value."), "AMOUNT", badValueGames, "TOTAL", editCount),
			"bh20",
			game.UI_COLORS.RED,
			"exclamation_point_red",
			22,
			22
		})
	end
	
	if self.editionSaleBoost > 1 then
		table.insert(textResults, {
			_format(_T("GAME_EDITION_BONUS_REGULAR_EDITION_GOOD", "Players are really happy with the value of the EDITION."), "EDITION", self.editions[1]:getName()),
			"bh20",
			game.UI_COLORS.LIGHT_BLUE,
			"exclamation_point",
			22,
			22
		})
	end
	
	if goodValueGames > 0 then
		table.insert(textResults, {
			_format(_T("GAME_EDITION_BONUS_GOOD_VALUE", "Players said AMOUNT out of TOTAL game editions had good value."), "AMOUNT", goodValueGames, "TOTAL", editCount),
			"bh20",
			game.UI_COLORS.LIGHT_BLUE,
			"exclamation_point",
			22,
			22
		})
	end
	
	if repLoss > 0 then
		own:decreaseReputation(repLoss)
		extra:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("GAME_EDITION_REP_LOSS", "You've lost REP Reputation points."), "REP", string.roundtobignumber(repLoss)), "bh20", game.UI_COLORS.RED, 4, wrapW, "efficiency_star_red", 22, 22)
		popup:setShowSound("bad_jingle")
	elseif repLoss < 0 then
		own:increaseReputation(-repLoss)
		
		local repGain = math.abs(repLoss)
		
		extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("GAME_EDITION_REP_GAIN", "You've gained REP Reputation points."), "REP", string.roundtobignumber(repGain)), "bh20", game.UI_COLORS.LIGHT_BLUE, 4, wrapW, "efficiency_star", 22, 22)
		popup:setShowSound("good_jingle")
	end
	
	own:changeOpinion(opinionChange)
	
	if opinionChange > 0 then
		extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("GAME_EDITION_OPINION_GAIN", "You've gained OPI Opinion points."), "OPI", string.roundtobignumber(opinionChange)), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "efficiency_star", 22, 22)
	elseif opinionChange < 0 then
		local opiGain = math.abs(opinionChange)
		
		extra:addTextLine(-1, game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		extra:addText(_format(_T("GAME_EDITION_OPINION_LOSS", "You've lost OPI Opinion points."), "OPI", string.roundtobignumber(opiGain)), "bh20", game.UI_COLORS.RED, 0, wrapW, "efficiency_star_red", 22, 22)
	end
	
	if #textResults > 0 then
		for key, data in ipairs(textResults) do
			local clr = data[3]
			
			extra:addTextLine(-1, clr, nil, "weak_gradient_horizontal")
			extra:addText(data[1], data[2], clr, 0, wrapW, data[4], data[5], data[6])
		end
	else
		extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
		extra:addText(_T("GAME_EDITION_NO_REMARKS", "There were no special remarks."), "bh20", game.UI_COLORS.LIGHT_BLUE, 0, wrapW, "question_mark", 22, 22)
	end
	
	popup:addOKButton("bh20")
	popup:center()
	frameController:push(popup)
end

function gameProject:calculateEditionPurchasePercentages()
	if not self.price then
		return 
	end
	
	local price = self.price
	local editCfg = gameProject.EDITIONS
	local bonus = editCfg.bonus
	local maxPrice = price * editCfg.basePriceMult + editCfg.basePriceOffset
	local maxPriceNormal = maxPrice - price
	local saleDropLog = math.log(editCfg.priceToEditionSaleBase, maxPriceNormal)
	local saleMult, editDiv = {}, {}
	
	self.editionSaleMult = saleMult
	self.editionDividers = editDiv
	
	local totalDivider = 0
	local editList = self.editions
	local editCount = #editList
	
	for key, edit in ipairs(editList) do
		local editPrice = edit:getPrice()
		local priceDelta = editPrice - price
		local saleDrop = priceDelta^saleDropLog - edit:getValue() * editCfg.valueToPriceDeltaDrop * edit:getDesire()
		
		if saleDrop >= 0 then
			saleDrop = math.max(saleDrop, 1)
		else
			saleDrop = 1 / math.abs(saleDrop * 2)
		end
		
		totalDivider = totalDivider + saleDrop
		editDiv[key] = saleDrop
	end
	
	self.editionSaleBoost = 1
	
	if editCount > 0 then
		local regEdit = editList[1]
		
		if regEdit:getValue() > 0 then
			self.editionSaleBoost = 1 + math.min((regEdit:getValue() / gameEditions.maxValue * regEdit:getDesire())^bonus.boostExponent, bonus.maxSaleBoost)
		end
	end
	
	local editionCountDivider = math.max(1, editCount - 1)
	
	if editCount > 1 then
		for i = 1, editCount do
			saleMult[i] = (1 - editDiv[i] / totalDivider) / editionCountDivider
		end
	else
		saleMult[1] = 1
	end
end

function gameProject:getEditionPayment()
	return self.editionPayment
end

function gameProject:getEditions()
	return self.editions
end

function gameProject:initFirstTimeEdition()
	self:initDefaultEdition()
	
	local iniEdit = self.editions[1]
	
	iniEdit:changeSales(self.totalSales)
	iniEdit:validateSaleBuffer()
	iniEdit:setPrice(self.price)
end

function gameProject:initDefaultEdition()
	local edit = gameEditions:instantiate(self, gameEditions.DEFAULT_EDITION)
	
	edit:setDeletable(false)
	self:addEdition(edit)
end

function gameProject:updateEditionPrices(oldPrice)
	local delta = self.price - oldPrice
	
	if delta ~= 0 then
		for key, edition in ipairs(self.editions) do
			edition:setPrice(edition:getPrice() + delta)
		end
	end
end

function gameProject:updatePirateableState()
	if self.sequelTo and not self:isNewGame() then
		if gameProject.PIRATEABLE_DEV_TYPES[self.sequelTo:getGameType()] then
			self.pirateable = self.sequelTo:canPirate()
		else
			self.pirateable = false
		end
	else
		self.pirateable = gameProject.PIRATEABLE_DEV_TYPES[self.curDevType]
	end
end

function gameProject:canPirate()
	return self.pirateable
end

function gameProject:countMMOValues()
	local taskMap = taskTypes.registeredByID
	local totalComplexity = gameProject.MMO_BASE_COMPLEXITY
	local totalContent = 0
	local catPriors = self.categoryPriorities
	local stages = self.stages
	
	for key, stageID in ipairs(gameProject.MANDATORY_STAGES_TO_COMPLETE) do
		for key, taskObj in ipairs(stages[stageID].tasks) do
			local data = taskMap[taskObj:getTaskType()]
			local category = data.category
			local prior = catPriors[category] or 1
			
			totalContent = totalContent + data.mmoContent * prior
			
			if data.mmoComplexity then
				totalComplexity = totalComplexity + data.mmoComplexity * prior
			end
		end
	end
	
	return totalContent, self:finalizeMMOComplexity(totalComplexity)
end

function gameProject:getMMOComplexityAffector()
	return 1 + (self.scale - gameProject.SCALE_MIN) / (platformShare:getMaxGameScale() - gameProject.SCALE_MIN)
end

function gameProject:finalizeMMOComplexity(value)
	return math.round(value * self:getMMOComplexityAffector(), 1)
end

function gameProject:createPrereleaseSubscriptionFeeMenu()
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setTitle(_T("MMO_SET_MONTHLY_SUBSCRIPTION_FEE", "Set Monthly Subscription Fee"))
	frame:setSize(400, 140)
	
	local frameH = 35
	local label = gui.create("Label", frame)
	
	label:setPos(_S(5), _S(30))
	label:setFont("pix20")
	label:wrapText(frame.w - _S(10), _T("MMO_SET_MONTHLY_SUBSCRIPTION_FEE_DESCRIPTION", "Before releasing, you have to set the monthly subscription fee players will have to pay to keep playing.\n\nSetting it too high will impact the longevity of subscriptions, as well as the game sales. You can change this fee at any time, but increasing it post-release will also have a negative effect on player happiness."))
	
	frameH = frameH + _US(label.h)
	
	local buttonWidth = (frame.rawW - 15) / 2
	local buttonHeight = 28
	
	frame:setHeight(frameH + buttonHeight + 45)
	
	local slider = gui.create("MMOSubscriptionFeeSlider", frame)
	local pricePoints = gameProject.SUBSCRIPTION_PRICE_POINTS
	
	slider:setProject(self)
	slider:setFont("bh22")
	slider:setText(_T("MONTHLY_SUBSCRIPTION_FEE", "Monthly subscription fee: SLIDER_VALUE"))
	slider:setMinMax(pricePoints[1], pricePoints[#pricePoints])
	slider:setSize(frame.rawW - 10, 38)
	slider:setValue(1)
	slider:setPos(_S(5), label.h + label.y + _S(5))
	slider:setSliderGap(#pricePoints, 3)
	
	local releaseButton = gui.create("ReleaseButton", frame)
	
	releaseButton:setSize(buttonWidth, buttonHeight)
	releaseButton:setFont("bh24")
	releaseButton:setText(_T("RELEASE", "Release"))
	releaseButton:setProject(self)
	releaseButton:setSkip(true)
	releaseButton:setPos(_S(5), frame.h - releaseButton.h - _S(5))
	
	local cancelButton = gui.create("GenericFrameControllerPopButton", frame)
	
	cancelButton:setSize(buttonWidth, buttonHeight)
	cancelButton:setFont("bh24")
	cancelButton:setText(_T("CANCEL", "Cancel"))
	cancelButton:setPos(frame.w - _S(5) - cancelButton.w, releaseButton.y)
	frame:center()
	frameController:push(frame)
end

function gameProject:canHaveGametype(id)
	local callback = gameProject.GAME_TYPE_VALIDITY_CHECKS[id]
	
	if callback then
		if callback(self) then
			return true
		else
			return false
		end
	end
	
	return true
end

function gameProject:increaseDRMValue(val)
	self.drmValue = self.drmValue + val
end

function gameProject:getDRMValue()
	return self.drmValue
end

function gameProject:calculateDRMAffectors()
	if not self.timeUntilPiracyCalculated then
		self.timeUntilPiracy = 0
		self.timeUntilPiracyCalculated = true
		
		if self.drmValue > 0 then
			local drm = gameProject.DRM
			local final = self.drmValue / drm.increasePerPoint * math.randomf(drm.randomRange[1], drm.randomRange[2])
			local minOpi = self:getMinimumOpinionValue(self.owner:getReputation())
			local opiDelta = minOpi - self.owner:getOpinion()
			
			if opiDelta > 0 then
				final = final - math.min(drm.opinionDeltaMax, opiDelta * drm.opinionReduction)
			end
			
			self.timeUntilPiracy = math.max(drm.base, math.round(final, 1))
		end
	end
	
	self.piracyDRMAffector = 1
	self.opinionReviewDRMAffector = 1
end

function gameProject:onProjectMenuCreated()
	self:setCategoryPriority(gameProject.MICROTRANSACTIONS_CATEGORY, gameProject.PRIORITY_MIN)
	self:setCategoryPriority(gameProject.DRM_CATEGORY, gameProject.PRIORITY_MIN)
	self:initDefaultEdition()
end

function gameProject:getProjectTypeText()
	if self.curDevType == gameProject.DEVELOPMENT_TYPE.MMO then
		if self.subgenre then
			return _format(_T("THEME_GENRE_SUBGENRE_GAME_MMO", "THEME GENRE-SUB Game MMO"), "THEME", themes:getName(self.theme), "GENRE", genres:getName(self.genre), "SUB", genres:getName(self.subgenre))
		else
			return _format(_T("THEME_GENRE_GAME_MMO", "THEME GENRE Game MMO"), "THEME", themes:getName(self.theme), "GENRE", genres:getName(self.genre))
		end
	end
	
	if self.subgenre then
		return _format(_T("THEME_GENRE_SUBGENRE_GAME", "THEME GENRE-SUB Game"), "THEME", themes:getName(self.theme), "GENRE", genres:getName(self.genre), "SUB", genres:getName(self.subgenre))
	end
	
	return _format(_T("THEME_GENRE_GAME", "THEME GENRE Game"), "THEME", themes:getName(self.theme), "GENRE", genres:getName(self.genre))
end

function gameProject:addInvalidTask(taskID)
	if table.find(self.invalidTasks, taskID) then
		return 
	end
	
	self.invalidTasks[#self.invalidTasks + 1] = taskID
end

function gameProject:removeInvalidTask(taskID)
	table.removeObject(self.invalidTasks, taskID)
end

function gameProject:addActiveAdvertisement(adID)
	if not table.find(self.activeAdvertisements, adID) then
		self.activeAdvertisements[#self.activeAdvertisements + 1] = adID
	end
end

function gameProject:removeActiveAdvertisement(adID)
	table.removeObject(self.activeAdvertisements, adID)
end

function gameProject:isAdvertisementActive(adID)
	return table.find(self.activeAdvertisements, adID)
end

function gameProject:areAdsInProgress()
	return #self.activeAdvertisements > 0
end

function gameProject:getSalesByWeek()
	return self.salesByWeek
end

function gameProject:getHighestSales()
	return self.highestSales
end

function gameProject:changeTimeSaleAffector(change)
	self.timeSaleAffector = math.max(0, self.timeSaleAffector + change * gameProject.TIME_SALE_AFFECTOR_MULTIPLIER)
end

function gameProject:addEventReceiver()
	engine.addEventReceiver(self)
	events:addFunctionReceiver(self, self.handleTimelineChange, timeline.EVENTS.NEW_TIMELINE)
end

function gameProject:removeEventReceiver()
	engine.removeEventReceiver(self)
	events:removeFunctionReceiver(self, timeline.EVENTS.NEW_TIMELINE)
end

function gameProject:handleTimelineChange()
	if self.newWeek and self.releaseDate then
		if self:canGenerateSales() then
			self:generateSales()
		else
			self:onRanOutMarketTime()
		end
		
		self.newWeek = false
	end
end

function gameProject:handleEvent(event, data, data2, ...)
	engine.handleEvent(self, event, data, data2, ...)
	
	local types = advertisement.registeredByID
	
	for key, adID in ipairs(self.activeAdvertisements) do
		types[adID]:handleEvent(self, event, data, data2, ...)
	end
	
	local isStudio = self.owner == studio
	
	if event == timeline.EVENTS.NEW_DAY and isStudio then
		if self:getFact(gameProject.ANNOUNCED_FACT) and not self:getFact(gameProject.REACTED_TO_ANNOUNCEMENT) then
			self:performRevealReaction()
		end
		
		if self:getFact(gameProject.QA_SESSION_START_TIME) then
			self:performQA()
		end
		
		if self.releaseDate then
			if not self.allIssuesDiscovered then
				self:performAudienceIssueDiscovery()
			end
			
			if self.canEvaluateIssues then
				self:evaluateIssues()
			end
		elseif self.momentPopularity > 0 then
			if self.popularityFade <= 0 then
				self.momentPopularity = math.max(0, self.momentPopularity - math.floor(self.popularityDecreaseSpeed))
				self.popularityDecreaseSpeed = self.popularityDecreaseSpeed + gameProject.POPULARITY_DECREASE_SPEED_PER_DAY
			else
				self.popularityFadeSpeed = self.popularityFadeSpeed + gameProject.POPULARITY_FADE_SPEED_PER_DAY
				self.popularityFade = math.max(0, self.popularityFade - self.popularityFadeSpeed)
				
				if self.popularityFade <= 0 then
					self.popularityFadeSpeed = 0
					self.popularityFade = 0
					self.popularityDecreaseSpeed = 1
				end
			end
		end
		
		local key = 1
		
		for i = 1, #self.interviewCooldown do
			local data = self.interviewCooldown[key]
			
			if data.cooldown == 1 then
				table.remove(self.interviewCooldown, key)
			else
				data.cooldown = data.cooldown - 1
				key = key + 1
			end
		end
	elseif event == timeline.EVENTS.NEW_WEEK then
		self.newWeek = true
		
		local relDate = self.releaseDate
		
		if isStudio then
			if interactionRestrictor:canPerformAction("interviews") and not relDate and self:getFact(gameProject.ANNOUNCED_FACT) and timeline.curTime >= review:getInterviewCooldown() then
				local reviewerList = review:getReviewers()
				local randomReviewer = reviewerList[math.random(1, #reviewerList)]
				local reviewerID = randomReviewer:getID()
				local cooldown = self:getInterviewCooldown(reviewerID)
				
				if not cooldown then
					local prevReviewAmount = self.interviewsOfferedByReviewer[reviewerID]
					
					if (not prevReviewAmount or prevReviewAmount < gameProject.MAX_INTERVIEWS_PER_REVIEWER) and math.random(1, 100) <= randomReviewer:getAutoAddInterviewChance(self) then
						self:performAutoInterview(randomReviewer)
						
						self.interviewsOfferedByReviewer[reviewerID] = (self.interviewsOfferedByReviewer[reviewerID] or 0) + 1
					end
				end
			end
			
			if relDate then
				local popupPresent = false
				local fact = gameProject.EVALUATED_CONTENT_FACT
				
				if not self.facts[fact] then
					if not self.contractor and timeline.curTime - relDate < gameProject.ASK_FOR_MORE_MAX_TIME then
						if not self.contractor then
							if not gameProject.CONTENT_POINTS_ON_DEV_TYPE[self.curDevType] then
								if self.hypeCounter and self.realRating < gameProject.BASE_HYPE_RATING + self.hypeCounter - gameProject.BASE_HYPE_RATING_OFFSET then
									if not self.lostReputationOverhype then
										self:loseReputationHypeCounter()
									end
								elseif self.rating >= gameProject.ASK_FOR_MORE_CONTENT_RATING and self.totalSales >= gameProject.ASK_FOR_MORE_MIN_SALES and self.curDevType ~= gameProject.DEVELOPMENT_TYPE.MMO then
									self:askForMoreContent()
									
									self.facts[fact] = true
								end
							else
								popupPresent = self:evaluateContentAmount()
								self.facts[fact] = true
							end
						end
					else
						self.facts[fact] = true
					end
				end
				
				if self.repetitivenessSaleAffector >= 1.4 and not self.facts[gameProject.MENTIONED_REPETITIVENESS_FACT] and not popupPresent then
					local popup = gui.create("DescboxPopup")
					
					popup:setWidth(600)
					popup:setFont(fonts.get("pix24"))
					popup:setTextFont(fonts.get("pix20"))
					popup:setTitle(_T("REPETITIVE_GAMES_TITLE", "Repetitive Games"))
					popup:setText(_format(_T("REPETITIVE_GAMES_DESCRIPTION", "Your 'PROJECT' game seems like it could be selling better, but isn't. Fans say that they've grown tired of the same type of games we've been releasing and would like to see a different genre & theme combination."), "PROJECT", self:getName()))
					popup:setShowSound("bad_jingle")
					
					local left, right, extra = popup:getDescboxes()
					
					extra:addTextLine(popup.w - _S(20), game.UI_COLORS.UI_PENALTY_LINE)
					extra:addText(_T("REPETITIVE_GAMES_DETAILED", "Decreased sales due to repeated genre & theme combination."), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 25, "exclamation_point_red", 24, 24)
					popup:addOKButton("pix20")
					popup:center()
					frameController:push(popup)
					
					self.facts[gameProject.MENTIONED_REPETITIVENESS_FACT] = true
				end
			end
		end
	elseif event == timeline.EVENTS.NEW_MONTH then
		self.totalSalesThisMonth = 0
	elseif event == platformShare.EVENTS.PLATFORM_REMOVED then
		table.removeObject(self.platforms, data:getID())
	elseif (event == trends.EVENTS.TREND_OVER or event == trends.EVENTS.TREND_START) and self.releaseDate then
		if data == trends.TREND_TYPES.THEME and data2 == self.theme or data == trends.TREND_TYPES.GENRE and data2 == self.genre then
			self:updateTrendContribution()
		end
	elseif event == playerPlatform.EVENTS.CANCELLED_DEVELOPMENT then
		local platID = data:getID()
		
		for key, id in ipairs(self.platforms) do
			if id == platID then
				table.remove(self.platforms, key)
				
				break
			end
		end
	end
end

function gameProject:loseReputationHypeCounter()
	local delta = (gameProject.BASE_HYPE_RATING + self.hypeCounter - self.realRating) * gameProject.MULTIPLIER_PER_HYPE_COUNTER
	local value = gameProject.BASE_HYPE_COUNTER_VALUE^(1 + delta) - gameProject.BASE_HYPE_COUNTER_VALUE
	local curRep = self.owner:getReputation()
	local lostRep = math.floor(math.min(curRep * gameProject.HYPE_MAX_REP_LOSS, curRep * value))
	
	self.owner:decreaseReputation(lostRep)
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	popup:setFont("pix24")
	popup:setTitle(_T("FANS_DISAPPOINTED_TITLE", "Fans Disappointed"))
	popup:setTextFont("pix20")
	popup:setText(_format(_T("FANS_DISAPPOINTED_OVERHYPED_GAME", "Your fans are disappointed with 'GAME'. You've hyped it up during interviews, but the game turned out to be worse than they expected.\n\n'I wish 'STUDIO' would not overhype it like that.', said one concerned fan."), "GAME", self.name, "STUDIO", self.owner:getName()))
	popup:setShowSound("bad_jingle")
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(10)
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("FANS_DISAPPOINTED_OVERHYPED_GAME_LOST_REP", "This has cost you REP reputation points."), "REP", string.comma(lostRep)), "bh20", game.UI_COLORS.RED, 0, popup.rawW - 25, "exclamation_point_red", 22, 22)
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
	
	self.lostReputationOverhype = true
end

function gameProject:askForMoreContent()
	local popup = game.createPopup(600, _T("FANS_ASKING_FOR_MORE_TITLE", "Fans Asking For More Content"), _format(_T("FANS_ASKING_FOR_MORE_DESCRIPTION", "Your fans love 'PROJECT' and are asking for more content.\n\nCreating a content or expansion pack for it is a good idea to get more cash and reputation."), "PROJECT", self:getName()), fonts.get("pix24"), fonts.get("pix20"))
	
	popup:setShowSound("good_jingle")
	frameController:push(popup)
end

function gameProject:evaluateContentAmount()
	if self.contentPriceAffector < gameProject.CONTENT_AFFECTOR_MINIMUM_NOTIFY or self.contentVarietyAffector < gameProject.CONTENT_AFFECTOR_MINIMUM_NOTIFY then
		local finalText = _format(_T("CONTENT_LOW_SALES_TEXT", "Fans are complaining about your 'GAME' expansion pack, and due to that the sales are hurt."), "GAME", self.name)
		
		if self.contentPriceAffector < gameProject.CONTENT_AFFECTOR_MINIMUM_NOTIFY then
			finalText = finalText .. "\n\n" .. _T("CONTENT_NOT_ENOUGH_FOR_PRICETAGE", "They say the price is too high for the amount of content it adds.")
		end
		
		if self.contentVarietyAffector < gameProject.CONTENT_AFFECTOR_MINIMUM_NOTIFY then
			finalText = finalText .. "\n" .. _T("CONTENT_NOT_ENOUGH_VARIETY", "They say there isn't enough content variety in the expansion packs we've released so far.")
		end
		
		local popup = game.createPopup(600, _T("FANS_NOT_HAPPY_CONTENT_TITLE", "Fans Not Happy With Expansion"), finalText, fonts.get("pix24"), fonts.get("pix20"))
		
		popup:setShowSound("bad_jingle")
		frameController:push(popup)
		
		return true
	end
	
	return false
end

function gameProject.sortNoticeByBadness(a, b)
	return a.score > b.score
end

function gameProject:performRevealReaction()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(600)
	
	local wrapWidth = popup.rawW - 25
	
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("REVEAL_RESULT_POPUP_TITLE_TITLE", "Reveal Result"))
	
	local revealScore, repAffector, timeAffector, scorePrevGameRatingAffector, scorePrevGamePopularityAffector, scorePeopleAffector, scoreNewGenreAffector, repetitiveness = self:getRevealScore()
	local popGain = math.round(revealScore * gameProject.REVEAL_SCORE_TO_POPULARITY)
	
	self:increasePopularity(popGain)
	
	local notices = {}
	
	if timeAffector ~= 0 then
		if timeAffector < 0 then
			table.insert(gameProject.concatMiscReaction, _T("REVEAL_REACTION_TOO_EARLY", "Some people think the reveal of a sequel happened a bit too early."))
			table.insert(notices, {
				font = "bh20",
				isBad = true,
				icon = "exclamation_point_red",
				text = _format(_T("SEQUEL_TIME_PENALTY", "CHANGE reveal score due to early sequel reveal."), "CHANGE", string.roundtobignumber(math.round(timeAffector))),
				score = timeAffector
			})
		else
			table.insert(notices, {
				font = "bh20",
				isBad = false,
				icon = "increase",
				text = _format(_T("SEQUEL_TIME_BOOST", "+BOOST reveal score due to sequel timing!"), "BOOST", string.roundtobignumber(math.round(timeAffector))),
				score = timeAffector
			})
		end
	end
	
	if repetitiveness > 1 then
		table.insert(gameProject.concatMiscReaction, _format(_T("REVEAL_REACTION_REPETITIVENESS", "People are somewhat sick of THEME GENRE games in general."), "THEME", themes.registeredByID[self.theme].display, "GENRE", genres.registeredByID[self.genre].display))
		table.insert(notices, {
			font = "bh20",
			isBad = true,
			score = -1,
			icon = "exclamation_point_red",
			text = _T("REVEAL_REACTION_REPETITIVENESS_PENALTY", "Lower reveal score due to repetitive theme and/or genre.")
		})
	end
	
	if scorePeopleAffector > 0 then
		table.insert(notices, {
			font = "bh20",
			isBad = false,
			icon = "increase",
			text = _format(_T("REVEAL_BOOST_PEOPLE_AFFECTOR", "+BOOST reveal score from chosen platform users!"), "BOOST", string.roundtobignumber(math.round(scorePeopleAffector))),
			score = scorePeopleAffector
		})
	end
	
	if scorePrevGameRatingAffector > 0 then
		table.insert(notices, {
			font = "bh20",
			isBad = false,
			icon = "increase",
			text = _format(_T("SEQUEL_REVEAL_BOOST", "+BOOST reveal score due to fan-favorite sequel!"), "BOOST", string.roundtobignumber(scorePrevGameRatingAffector)),
			score = scorePrevGameRatingAffector
		})
	end
	
	if scoreNewGenreAffector > 0 then
		local canReceiveBonus, bonusType = self:canReceiveGenreRevealBonus()
		
		if canReceiveBonus then
			if self.owner:getAverageGameScore() <= gameProject.REVEAL_NOT_EXCITED_NEW_GENRE_AFFECTOR then
				if bonusType == gameProject.GENRE_BONUS_TYPES.NO_GAMES_MADE_BEFORE then
					table.insert(gameProject.concatMiscReaction, string.easyformatbykeys(_T("REVEAL_NEW_GENRE_NOT_EXCITED", "A small portion of your fans are excited to see what kind of game you will be able to make of the GENRE genre, the rest are skeptic as your previous games weren't very good."), "GENRE", genres.registeredByID[self.genre].display))
					table.insert(notices, {
						font = "bh20",
						isBad = false,
						icon = "increase",
						text = _format(_T("NEW_GENRE_BOOST", "+BOOST reveal score boost due to new genre!"), "BOOST", string.roundtobignumber(math.round(scoreNewGenreAffector))),
						score = scoreNewGenreAffector
					})
				else
					table.insert(gameProject.concatMiscReaction, string.easyformatbykeys(_T("REVEAL_EXISTING_GENRE_LONG_AGO_NOT_EXCITED", "A small portion of your fans are excited to see that you are making a new game of the GENRE genre, the rest are skeptic as your previous games weren't very good."), "GENRE", genres.registeredByID[self.genre].display))
					table.insert(notices, {
						font = "bh20",
						isBad = false,
						icon = "increase",
						text = _format(_T("OLD_TIME_GENRE_BOOST", "+BOOST reveal score boost due to old-time genre!"), "BOOST", string.roundtobignumber(math.round(scoreNewGenreAffector))),
						score = scoreNewGenreAffector
					})
				end
			elseif bonusType == gameProject.GENRE_BONUS_TYPES.NO_GAMES_MADE_BEFORE then
				table.insert(gameProject.concatMiscReaction, _format(_T("REVEAL_NEW_GENRE_EXCITED", "Your fans are excited to see what kind of game you will be able to make of the GENRE genre."), "GENRE", genres.registeredByID[self.genre].display))
				table.insert(notices, {
					font = "bh20",
					isBad = false,
					icon = "increase",
					text = _format(_T("NEW_GENRE_BOOST", "+BOOST reveal score boost due to new genre!"), "BOOST", string.roundtobignumber(math.round(scoreNewGenreAffector))),
					score = scoreNewGenreAffector
				})
			else
				table.insert(gameProject.concatMiscReaction, _format(_T("REVEAL_REPEAT_GENRE_EXCITED", "Your fans are excited to see that you are making a new game of the GENRE genre."), "GENRE", genres.registeredByID[self.genre].display))
				table.insert(notices, {
					font = "bh20",
					isBad = false,
					icon = "increase",
					text = _format(_T("OLD_TIME_GENRE_BOOST", "+BOOST reveal score boost due to old-time genre!"), "BOOST", string.roundtobignumber(math.round(scoreNewGenreAffector))),
					score = scoreNewGenreAffector
				})
			end
		end
	end
	
	local reaction = gameProject.REVEAL_MAIN_REACTION[1]
	local highest = -math.huge
	
	for key, data in ipairs(gameProject.REVEAL_MAIN_REACTION) do
		if revealScore >= data.score and highest < data.score then
			reaction = data
			highest = data.score
		end
	end
	
	local finalText = type(reaction.text) == "table" and reaction.text[math.random(1, #reaction.text)] or reaction.text
	local text
	
	if #gameProject.concatMiscReaction > 0 then
		text = string.easyformatbykeys("BASE_REACTION\n\nMISC_REACTION", "BASE_REACTION", finalText, "MISC_REACTION", table.concat(gameProject.concatMiscReaction, "\n"))
	else
		text = finalText
	end
	
	popup:setText(text)
	table.sortl(notices, gameProject.sortNoticeByBadness)
	
	local left, right, extra = popup:getDescboxes()
	
	left:addSpaceToNextText(10)
	left:addText(_format(_T("TOTAL_REVEAL_SCORE", "Reveal score: SCORE pts."), "SCORE", string.roundtobignumber(revealScore)), "bh22", nil, 0, wrapWidth * 0.5, "efficiency", 22, 22)
	right:addSpaceToNextText(10)
	right:addText(_format(_T("REVEAL_POPULARITY_GAINED", "Popularity gained: SCORE pts."), "SCORE", string.roundtobignumber(popGain)), "bh22", nil, 0, wrapWidth * 0.5, "star", 22, 22)
	
	if #notices > 0 then
		extra:addSpaceToNextText(10)
		
		for key, data in ipairs(notices) do
			local textColor
			
			if data.isBad then
				textColor = game.UI_COLORS.RED
				
				extra:addTextLine(popup.w - _S(20), game.UI_COLORS.UI_PENALTY_LINE)
			end
			
			extra:addSpaceToNextText(3)
			extra:addText(data.text, data.font or "pix20", textColor, 0, wrapWidth, data.icon, 22, 22)
		end
	end
	
	popup:addButton(fonts.get("pix20"), _T("OK", "OK"))
	popup:center()
	
	local prevGame = self.sequelTo
	
	if prevGame then
		prevGame:boostPopularityFromExpansionPack(self, gameProject.EXPANSION_POPULARITY_BOOST.announceMultiplier)
	end
	
	frameController:push(popup)
	table.clear(gameProject.concatMiscReaction)
	self:setFact(gameProject.REACTED_TO_ANNOUNCEMENT, true)
end

gameProject._polishWorkAmount = {}
gameProject._contributingKnowledge = {}

function gameProject:getThoroughWorkInfo()
	local listOfTasks = taskTypes.registeredByID
	local total = 0
	local mmoComplex, mmoContent = gameProject.MMO_BASE_COMPLEXITY, 0
	local isMMO = self.curDevType == gameProject.DEVELOPMENT_TYPE.MMO or self.sequelTo and self.sequelTo.isMMO
	local workByWorkField = complexProject.workAmountByWorkfield
	local polishWorkAmounts = gameProject._polishWorkAmount
	local contributingKnowledge = gameProject._contributingKnowledge
	
	table.clear(workByWorkField)
	table.clear(polishWorkAmounts)
	table.clearArray(contributingKnowledge)
	
	local taskClass = gameProject.TASK_CLASS
	local polishTask = gameProject.POLISH_TASK_CLASS
	local catPriors = self.categoryPriorities
	
	for featureID, state in pairs(self.desiredFeatures) do
		local featureData = listOfTasks[featureID]
		local workAmount = taskClass:calculateRequiredWork(featureData, self)
		
		total = total + workAmount
		workByWorkField[featureData.workField] = (workByWorkField[featureData.workField] or 0) + workAmount
		
		featureData:getContributingKnowledge(self, contributingKnowledge)
		
		if isMMO then
			local category = featureData.category
			local prior = catPriors[category] or 1
			
			if featureData.mmoComplexity then
				mmoComplex = mmoComplex + featureData.mmoComplexity * prior
			end
			
			if featureData.mmoContent then
				mmoContent = mmoContent + featureData.mmoContent * prior
			end
		end
		
		if featureData.stage == 2 then
			local polishWorkAmount = polishTask:calculateRequiredWork(featureData, self)
			
			total = total + polishWorkAmount
			polishWorkAmounts[featureData.workField] = (polishWorkAmounts[featureData.workField] or 0) + polishWorkAmount
		end
	end
	
	if isMMO then
		mmoContent = math.round(mmoContent * logicPieces:getData(gameProject.MMO_SUBSCRIPTIONS_LOGIC_PIECE_ID):getRealScaleMultiplier(self.scale), 1)
	end
	
	local stageTasks = self:getGameTypeStageTasks()
	
	for key, categoryListID in ipairs(gameProject.MANDATORY_STAGES_TO_COMPLETE) do
		local listOfCategories = stageTasks[categoryListID]
		
		for key, categoryID in ipairs(listOfCategories) do
			local tasks = taskTypes:getTasksByCategory(categoryID)
			
			if tasks then
				for key, taskData in ipairs(tasks) do
					local workAmount = taskClass:calculateRequiredWork(taskData, self)
					
					total = total + workAmount
					workByWorkField[taskData.workField] = (workByWorkField[taskData.workField] or 0) + workAmount
					
					taskData:getContributingKnowledge(self, contributingKnowledge)
					
					if taskData.stage == 2 then
						local polishWorkAmount = polishTask:calculateRequiredWork(taskData, self)
						
						total = total + polishWorkAmount
						polishWorkAmounts[taskData.workField] = (polishWorkAmounts[taskData.workField] or 0) + polishWorkAmount
					end
				end
			end
		end
	end
	
	if mmoComplex > 0 then
		mmoComplex = self:finalizeMMOComplexity(mmoComplex)
	end
	
	return total, workByWorkField, polishWorkAmounts, contributingKnowledge, mmoComplex, mmoContent
end

gameProject.DEMO_INVALID = {
	unannounced = {
		{
			font = "bh20",
			wrapWidth = 200,
			iconHeight = 22,
			icon = "question_mark",
			iconWidth = 22,
			text = _T("DEMO_INVALID_UNANNOUNCED", "You must announce the game before making a demo version of it.")
		}
	},
	present = {
		{
			font = "bh20",
			wrapWidth = 200,
			iconHeight = 22,
			icon = "question_mark",
			iconWidth = 22,
			text = _T("DEMO_INVALID_EVALUATING", "A demo has already been released for this game.")
		}
	},
	notPolishing = {
		{
			font = "bh20",
			wrapWidth = 200,
			iconHeight = 22,
			icon = "question_mark",
			iconWidth = 22,
			text = _T("DEMO_INVALID_NOT_POLISHING", "Game must be in the Polishing stage.")
		}
	},
	noEngineers = {
		{
			font = "bh20",
			wrapWidth = 200,
			iconHeight = 22,
			icon = "question_mark",
			iconWidth = 22,
			text = _T("DEMO_INVALID_NO_SOFTWARE_ENGINEERS", "No available Software Engineers.")
		}
	}
}

function gameProject:canCreateDemo()
	if self.curDevType ~= gameProject.DEVELOPMENT_TYPE.NEW then
		return false
	end
	
	if not self:wasAnnounced() then
		return false, gameProject.DEMO_INVALID.unannounced
	end
	
	if self.evaluatingDemo or self.evaluatedDemo then
		return false, gameProject.DEMO_INVALID.present
	end
	
	if self.stage ~= gameProject.POLISHING_STAGE then
		return false, gameProject.DEMO_INVALID.notPolishing
	end
	
	if not self.owner:getBestEmployeeBySkill("software") then
		return false, gameProject.DEMO_INVALID.noEngineers
	end
	
	return true
end

function gameProject:addDemoCreationOption(comboBox)
	if self.creatingDemo then
		return 
	end
	
	local canCreate, reason = self:canCreateDemo()
	
	if canCreate or not canCreate and reason then
		local option = comboBox:addOption(0, 0, 0, 24, _T("CREATE_A_DEMO", "Create a demo"), fonts.get("pix20"), gameProject.createDemoCallback)
		
		option.project = self
		
		if not canCreate then
			option:setCanClick(false)
			option:setHoverText(reason)
		end
	end
end

eventBoxText:registerNew({
	id = "demo_created",
	getText = function(self, data)
		return _format(_T("DEMO_CREATED_EVENT_BOX", "Demo for 'GAME' created. A result on what people think of it will become available shortly."), "GAME", data)
	end
})
eventBoxText:registerNew({
	id = "demo_in_progress",
	getText = function(self, data)
		if data.player then
			return _format(_T("DEMO_IN_PROGRESS_SELF_EVENT_BOX", "You are now creating a demo for 'GAME'."), "GAME", data.game)
		end
		
		return _format(_T("DEMO_IN_PROGRESS_EVENT_BOX", "ASSIGNEE is now creating a demo for 'GAME'."), "ASSIGNEE", names:getFullName(data.name[1], data.name[2], data.name[3], data.name[4]), "GAME", data.game)
	end
})

function gameProject:createDemoTask()
	local employeeObj = self.owner:getBestEmployeeBySkill("software")
	
	if employeeObj then
		local demoTask = task.new("demo_creation_task")
		
		demoTask:setProject(self)
		demoTask:setWorkField("software")
		demoTask:addTrainedSkill("software", game.RESEARCH_MIN_EXP, game.RESEARCH_MAX_EXP, game.RESEARCH_EXP_MIN_TIME, game.RESEARCH_EXP_MAX_TIME)
		demoTask:setTimeToProgress(0.5)
		demoTask:setRequiredWork(demoTask.DEFAULT_REQUIRED_WORK_AMOUNT + demoTask.EXTRA_WORK_PER_SCALE * self.scale)
		employeeObj:setTask(demoTask)
		
		if employeeObj:isPlayerCharacter() then
			game.addToEventBox("demo_in_progress", {
				player = true,
				game = self:getName()
			}, 1, nil, "exclamation_point")
		else
			game.addToEventBox("demo_in_progress", {
				name = {
					employeeObj:getNameConfig()
				},
				game = self:getName()
			}, 1, nil, "exclamation_point")
		end
	end
end

function gameProject:setCreatingDemo(state)
	self.creatingDemo = state
end

function gameProject:cancelDemoCreation()
	self:setCreatingDemo(false)
end

function gameProject:scheduleDemoEvaluation()
	self.evaluatingDemo = true
	
	local event = scheduledEvents:instantiateEvent("demo_evaluation")
	
	event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
	event:setRating(review:getCurrentGameVerdict(self))
	event:setProject(self)
	
	local elem = game.addToEventBox("demo_created", self:getName(), 1, nil, "exclamation_point")
	
	elem:setFlash(true, true)
end

function gameProject:evaluateDemo(rating)
	local demoCfg = gameProject.DEMO
	local delta = rating - demoCfg.cutoff
	local popGain = 0
	local contents, sound, color, sprite, bottomText, verdictColor, verdictIcon
	
	if delta > 0 then
		local repGain, realPopGain = self:increasePopularity(delta^demoCfg.popGainMax * (1 + self.owner:getReputation() / demoCfg.repAffectorPositive))
		
		contents, sound, color, sprite = _T("DEMO_EVAL_POPULARITY_GAINED", "The demo elicited a positive response from the audience for 'GAME'."), "good_jingle", game.UI_COLORS.LIGHT_BLUE, "increase"
		bottomText = _format(_T("GENERIC_EVAL_POPULARITY_GAINED_AMOUNT", "The project gained POPULARITY Popularity points."), "POPULARITY", string.roundtobignumber(realPopGain))
		verdictIcon = "exclamation_point"
		verdictColor = game.UI_COLORS.LIGHT_BLUE
	elseif delta < 0 then
		local repLoss = math.abs(delta)^demoCfg.popLossMax * (1 + self.owner:getReputation() / demoCfg.repAffectorNegative)
		
		self:decreasePopularity(repLoss)
		
		contents, sound, color, sprite = _T("DEMO_EVAL_POPULARITY_LOST", "The demo elicited a negative response from the audience for 'GAME'."), "bad_jingle", game.UI_COLORS.RED, "decrease_red"
		bottomText = _format(_T("DEMO_EVAL_POPULARITY_LOST_AMOUNT", "The project lost POPULARITY Popularity points."), "POPULARITY", string.roundtobignumber(repLoss))
		verdictIcon = "exclamation_point_red"
		verdictColor = game.UI_COLORS.RED
	else
		contents, sound, color, sprite = _T("DEMO_EVAL_NEUTRAL", "The demo elicited a completely neutral response from the audience for 'GAME'."), "generic_jingle", game.UI_COLORS.IMPORTANT_3, "question_mark"
		bottomText = _T("DEMO_EVAL_POPULARITY_NO_CHANGE", "No change in Popularity points.")
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(400)
	popup:setFont("pix24")
	popup:setTitle(_T("DEMO_RESULTS_TITLE", "Demo Results"))
	popup:setTextFont("pix20")
	popup:setText(_format(contents, "GAME", self.name))
	popup:setShowSound(sound)
	popup:hideCloseButton()
	
	local left, right, extra = popup:getDescboxes()
	
	extra:addSpaceToNextText(20)
	extra:addTextLine(-1, color, nil, "weak_gradient_horizontal")
	extra:addText(bottomText, "bh20", color, 6, popup.rawW - 20, sprite, 22, 22)
	extra:addTextLine(-1, verdictColor, nil, "weak_gradient_horizontal")
	extra:addText(_format(_T("DEMO_EVAL_RATING", "People say that if they were writing a review the average rating they would give is RATING/MAX."), "RATING", math.round(rating), "MAX", review.maxRating), "bh20", verdictColor, 10, popup.rawW - 20, verdictIcon, 22, 22)
	extra:addTextLine(-1, game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
	extra:addText(_T("DEMO_EVAL_TIP", "The quality of the demo directly depends on the quality of your game."), "bh20", nil, 6, popup.rawW - 20, "question_mark", 22, 22)
	popup:addOKButton("bh20")
	popup:center()
	frameController:push(popup)
	
	self.evaluatedDemo = true
end

function gameProject:canReceiveGenreRevealBonus()
	local canReceiveGenreBonus = true
	local genre = self:getGenre()
	
	if self.owner:getGameCountByGenre(genre) > 0 then
		local previousGame = self.owner:getLastGameOfGenre(genre)
		local timeDifference = (timeline.curTime - previousGame:getReleaseDate()) / timeline.DAYS_IN_YEAR
		
		return timeDifference >= #genres.registered, gameProject.GENRE_BONUS_TYPES.LONG_TIME_AGO
	else
		return true, gameProject.GENRE_BONUS_TYPES.NO_GAMES_MADE_BEFORE
	end
	
	return false, nil
end

function gameProject:addMMOTask(taskID)
	if not self.mmoTasks then
		self.mmoTasks = {}
	end
	
	if not table.find(self.mmoTasks, taskID) then
		self.mmoTasks[#self.mmoTasks + 1] = taskID
	end
end

function gameProject:getMMOTasks()
	return self.mmoTasks
end

function gameProject:setupInfoDescbox(descBox, wrapW)
	engine.setupInfoDescbox(self, descBox, wrapW)
	descBox:addSpaceToNextText(8)
	
	local idxs = #issues.registered
	local largestAmt, largestData = -math.huge
	local total, bySkill, taskCount, finishedTaskCount = self:getStageWorkAmount(self.stage)
	
	for key, data in ipairs(skills.registered) do
		local required = bySkill[data.id]
		
		if required and required > 0 and largestAmt < required then
			largestAmt = required
			largestData = data
		end
	end
	
	if largestData then
		descBox:addText(_format(_T("LARGEST_WORK_CHUNK", "Largest work chunk: TYPE (POINTS pts.)"), "TYPE", largestData.display, "POINTS", string.comma(largestAmt)), "bh16", nil, 4, wrapW - 100, largestData:getIconConfig(22, 22, 1, 1))
	end
	
	for key, data in ipairs(issues.registered) do
		local count = self:getDiscoveredUnfixedIssueCount(data.id)
		
		descBox:addText(_format("TYPE - AMOUNT", "TYPE", data.display, "AMOUNT", count), "bh16", nil, key < idxs and 3 or 0, wrapW, data.icon, 20, 20)
	end
end

function gameProject:getRevealScore()
	local repetitivenessAffector = self:calculateRepetitivenessSaleAffector()
	local rep = self.owner:getReputation()
	local repAffector = rep * gameProject.REVEAL_REPUTATION_AFFECTOR / repetitivenessAffector
	local score = repAffector
	local scorePrevGameTimeAffector = 0
	local scorePrevGameRatingAffector = 0
	local scorePrevGamePopularityAffector = 0
	local scoreNewGenreAffector = 0
	
	if self.sequelTo and self:isNewGame() then
		local prevGame = self.sequelTo
		local prevReleaseTime = prevGame:getReleaseDate()
		local timeDifference = timeline.curTime - prevReleaseTime
		local delta = timeDifference - gameProject.REVEAL_MINIMUM_REVEAL_TIME_DIFFERENCE
		
		if delta < 0 then
			scorePrevGameTimeAffector = scorePrevGameTimeAffector - delta * gameProject.REVEAL_EARLY_REVEAL_PENALTY
		elseif delta > 0 then
			scorePrevGameTimeAffector = scorePrevGameTimeAffector + math.min(delta * gameProject.REVEAL_BOOST_PER_DAY, gameProject.REVEAL_BOOST_MAX) / repetitivenessAffector
		end
		
		local avgScore = prevGame:getReviewRating()
		local delta = avgScore - gameProject.REVEAL_AVG_SCORE_OF_PREV_GAME_MINIMUM
		
		if delta > 0 then
			scorePrevGameRatingAffector = delta * gameProject.REVEAL_PREV_GAME_SCORE_DELTA_AFFECTOR / repetitivenessAffector
		end
		
		scorePrevGamePopularityAffector = scorePrevGamePopularityAffector + prevGame:getPopularity() * gameProject.REVEAL_PREV_GAME_POPULARITY_AFFECTOR / repetitivenessAffector
	end
	
	local totalPeople = 0
	
	for key, platformID in ipairs(self.platforms) do
		totalPeople = totalPeople + platformShare:getPlatformOwners(platformID)
	end
	
	totalPeople = totalPeople / repetitivenessAffector
	
	if rep >= gameProject.REVEAL_NEW_GENRE_MINIMUM_REPUTATION and self:canReceiveGenreRevealBonus() then
		local mult = 0
		
		if self.owner:getAverageGameScore() <= gameProject.REVEAL_NOT_EXCITED_AVERAGE_SCORE then
			mult = gameProject.REVEAL_NOT_EXCITED_NEW_GENRE_AFFECTOR
		else
			mult = gameProject.REVEAL_NEW_GENRE_AFFECTOR
		end
		
		score = score + rep * mult / repetitivenessAffector
	end
	
	totalPeople = math.min(math.max(gameProject.REVEAL_PLAYERBASE_REP_LOWER_BOUND, rep * math.randomf(gameProject.REVEAL_PLAYERBASE_AFFECTOR_RANDOM[1], gameProject.REVEAL_PLAYERBASE_AFFECTOR_RANDOM[2])), totalPeople * gameProject.REVEAL_PLAYERBASE_AFFECTOR)
	score = score + scorePrevGameTimeAffector + scorePrevGameRatingAffector + scorePrevGamePopularityAffector + totalPeople
	
	return score, rep * gameProject.REVEAL_REPUTATION_AFFECTOR, scorePrevGameTimeAffector, scorePrevGameRatingAffector, scorePrevGamePopularityAffector, totalPeople, scoreNewGenreAffector, repetitivenessAffector
end

local function onClicked(self)
	self.tree.baseButton.project:setPrice(self.price)
	
	for key, option in ipairs(self.tree:getOptionElements()) do
		option:highlight(option.price == self.price)
	end
	
	self.tree:close()
end

function gameProject:setCategoryPriority(id, priority)
	local oldPriority = self.categoryPriorities[id]
	
	self.categoryPriorities[id] = priority or 1
	
	if not self._minimalEffort and self.categoryPriorities[id] ~= oldPriority then
		self:calculateDesiredFeaturesCost()
		events:fire(gameProject.EVENTS.CATEGORY_PRIORITY_CHANGED, self, priority, oldPriority, id)
	end
end

function gameProject:getCategoryPriority(id)
	return self.categoryPriorities[id] or 1
end

function gameProject:getCategoryPriorities()
	return self.categoryPriorities
end

function gameProject:calculateMinimumOpinion(reputation)
	local pir = gameProject.PIRACY
	local repDelta = reputation - pir.safeRep
	
	return math.min(pir.maxOpinionValue, pir.base + repDelta / pir.opinionPerRep)
end

function gameProject:calculatePiracyValue()
	local rat = self.realRating
	local pir = gameProject.PIRACY
	local delta = pir.ratingCutoff - self.realRating
	local rep = self.owner:getReputation()
	local piracy
	local safeRep = pir.safeRep
	
	if safeRep < rep then
		piracy = math.lerp(pir.minPiracySafe, pir.minPiracy, math.min(1, (rep - safeRep) / (pir.safeRepEnd - safeRep)))
	else
		piracy = pir.minPiracySafe
	end
	
	if delta > 0 then
		local value = (delta * pir.ratingDeltaMult)^pir.ratingExponent / pir.ratingDeltaDiv
		
		piracy = piracy + value / 100
	end
	
	local repDelta = rep - safeRep
	
	if repDelta > 0 then
		local baseOpinion = self:calculateMinimumOpinion(rep)
		local opinionDelta = math.min(pir.maxPenaltyDelta, baseOpinion - self.owner:getOpinion())
		
		if opinionDelta > 0 then
			local penalty = 1 + (pir.maxPenaltyChange - (pir.maxPenaltyDelta + 1 - opinionDelta)^pir.maxPenaltyChangeExponent) / 100
			
			piracy = piracy * penalty
		end
	end
	
	return math.min(pir.maxPiracy, piracy)
end

function gameProject:getMinimumOpinionValue(rep)
	local pir = gameProject.PIRACY
	local repDelta = rep - pir.safeRep
	
	return math.min(pir.maxOpinionValue, pir.base + repDelta / pir.opinionPerRep)
end

function gameProject:getIssueComplaintsLevel()
	local affector = review:getIssueScoreAffector(self)
	local highest = -math.huge
	
	for key, affectorLevel in ipairs(gameProject.ISSUE_COMPLAINTS_LEVEL) do
		if affectorLevel <= affector and highest < key then
			highest = key
		end
	end
	
	return highest
end

function gameProject:evaluateIssues()
	if self:getProjectAge() < gameProject.ISSUE_EVALUATION_MINIMUM_DAYS_PASSED or self.totalSales < gameProject.ISSUE_EVALUATION_MINIMUM_SALES then
		return false
	end
	
	local affector, opinionChange = review:getIssueScoreAffector(self)
	local highest = -math.huge
	
	for key, affectorLevel in ipairs(gameProject.ISSUE_COMPLAINTS_LEVEL) do
		if affectorLevel <= affector and highest < key then
			highest = key
		end
	end
	
	local issueText = gameProject.ISSUE_COMPLAINTS_TEXT[highest]
	
	if issueText then
		issueText = string.easyformatbykeys(issueText, "GAME", self.name)
		
		local releasedPatchesText
		local patchCount = #self.patches
		
		if patchCount == 0 then
			releasedPatchesText = _T("ISSUE_EVALUATION_NO_PATCHES_RELEASED", "To this day you have released no patches for this game.")
		elseif patchCount == 1 then
			releasedPatchesText = _T("ISSUE_EVALUATION_ONE_PATCH_RELEASED", "To this day you have released 1 patch for this game.")
		elseif patchCount > 1 then
			releasedPatchesText = string.easyformatbykeys(_T("ISSUE_EVALUATION_SEVERAL_PATCHES_RELEASED", "To this day you have released PATCHES patches for this game."), "PATCHES", patchCount)
		end
		
		local mainText = string.easyformatbykeys(_T("ISSUE_EVALUATION_LAYOUT", "COMPLAINTS\n\nRELEASED_PATCHES_TEXT"), "COMPLAINTS", issueText, "RELEASED_PATCHES_TEXT", releasedPatchesText)
		local popup = gui.create("DescboxPopup")
		
		popup:setFont("pix24")
		popup:setTitle(_T("COMPLAINTS_ABOUT_BUGS_TITLE", "Game Bug Complaints"))
		popup:setTextFont("pix20")
		popup:setWidth(600)
		popup:setText(mainText)
		popup:setShowSound("bad_jingle")
		popup:hideCloseButton()
		
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		extra:addText(_T("ISSUE_COMPLAINTS_QA_HINT", "Making your games go through QA sessions once the game is close to release helps with finding issues."), "bh20", nil, 0, popup.rawW - 30, "question_mark", 22, 22)
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
	end
	
	self.owner:changeOpinion(-opinionChange)
	
	self.canEvaluateIssues = false
	
	return true
end

gameProject.IDEAL_PRICEPOINT_HOVER_TEXT = {
	{
		font = "bh18",
		wrapWidth = 300,
		iconWidth = 22,
		iconHeight = 22,
		icon = "question_mark",
		text = _T("IDEAL_PRICEPOINT_FOR_THIS_GAME", "This is the ideal price-point for this game.")
	}
}

function gameProject:openGameEditionsCallback()
	gameEditions:createMenu(self.project)
end

function gameProject:createPricePointComboBox(element, width, comboBox)
	local x, y = element:getPos(true)
	
	width = width or element.rawW
	
	local was = comboBox
	
	comboBox = comboBox or gui.create("ComboBox")
	
	comboBox:setPos(x, y + element.h)
	comboBox:setDepth(100)
	
	comboBox.baseButton = element
	comboBox.project = self
	
	if not was then
		comboBox:setInteractionObject(element)
	end
	
	local projPrice = self:getPrice()
	
	projPrice = projPrice or 0
	
	if not self.releaseDate then
		local option = comboBox:addOption(0, 0, width, 18, _T("GAME_EDITIONS_CONTINUE", "Game editions..."), fonts.get("bh20"), gameProject.openGameEditionsCallback)
		
		option.project = self
	end
	
	local bestPrice
	
	if self.knownIdealPrice then
		bestPrice = self:calculateIdealPriceForScale()
	end
	
	for key, price in ipairs(gameProject.PRICE_POINTS) do
		local optionObject = comboBox:addOption(0, 0, width, 18, "$" .. price, fonts.get("pix20"), onClicked)
		
		optionObject.price = price
		
		optionObject:highlight(price == projPrice)
		optionObject:setCloseOnClick(false)
		
		if price == bestPrice then
			optionObject:setIcon("exclamation_point")
			optionObject:setHoverText(gameProject.IDEAL_PRICEPOINT_HOVER_TEXT)
		end
	end
	
	return comboBox
end

function gameProject:fillWithGenreThemeMatches(descbox, genreID, wrapWidth)
	local themeGenreMatching = themes:getRevealedGenreMatching(genreID)
	
	descbox:addText(_T("GENRE_THEME_MATCHING", "Genre-theme matching:"), "pix20", nil, 10, 700)
	
	if #themeGenreMatching == 0 then
		descbox:addText(_T("NONE_KNOWN_YET", "None known yet"), "bh18", nil, 0, 700)
	else
		for key, themeData in ipairs(themeGenreMatching) do
			local genreMatching = themeData.match[genreID]
			local signs, color = game.getContributionSign(1, genreMatching, 0.1, 3, nil, nil, nil)
			
			descbox:addText(signs .. " " .. themeData.display, "bh18", color, 0, 700)
		end
	end
	
	trends:setupGenreTrendDescbox(descbox, genreID, 700)
end

function gameProject:fillWithThemeGenreMatches(descbox, themeID, wrapWidth)
	local genreList = genres:getRevealedThemeMatching(themeID)
	
	descbox:addText(_T("GENRE_THEME_MATCHING", "Genre-theme matching:"), "pix20", nil, 10, 700)
	
	if #genreList == 0 then
		descbox:addText(_T("NONE_KNOWN_YET", "None known yet"), "bh18", nil, 0, 700)
	else
		local themeMap = themes.registeredByID
		local themeData = themeMap[themeID]
		
		for key, genreData in ipairs(genreList) do
			local genreMatching = themeData.match[genreData.id]
			local signs, color = game.getContributionSign(1, genreMatching, 0.1, 3, nil, nil, nil)
			
			descbox:addText(signs .. " " .. genreData.display, "bh18", color, 0, 700, genres:getGenreUIIconConfig(genreData, 24, 24, 22))
		end
	end
end

function gameProject:fillWithSubgenreMatches(descbox, subgenreID, wrapWidth)
	descbox:addText(_T("GENRE_SUBGENRE_MATCHING", "Genre-subgenre matching:"), "pix20", nil, 10, 300)
	
	local subID = subgenreID
	local subgenreMatches = genres:getRevealedSubgenreMatching(subID)
	
	if #subgenreMatches == 0 then
		descbox:addText(_T("NONE_KNOWN_YET", "None known yet"), "bh18", nil, 0, wrapWidth)
	else
		local subMatches = genres.subgenreMatches
		
		for key, genreData in ipairs(subgenreMatches) do
			local matchVal = subMatches[genreData.id][subID]
			local signs, color = game.getContributionSign(1, matchVal, 0.075, 3, nil, nil, nil)
			
			descbox:addText(signs .. " " .. genreData.display, "pix18", color, 0, wrapWidth, genres:getGenreUIIconConfig(genreData, 24, 24, 22))
		end
	end
end

gameProject.GENRE_THEME_MATCH_DESCBOX_ID = "genre_theme_match"
gameProject.THEME_GENRE_MATCH_DESCBOX_ID = "theme_genre_match"
gameProject.GENRE_SUBGENRE_MATCH_DESCBOX_ID = "genre_subgenre_theme_match"

function gameProject:createGenreSelectionMenu(validGenreList)
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText(_T("SELECT_GENRE_TITLE", "Select Genre"))
	frame:setSize(500, 400)
	frame:center()
	frame:addDepth(100)
	
	if #genres:getValidResearchGenres() > 0 then
		local designNew = gui.create("DesignNewGenreButton", frame)
		
		designNew:setSize(150, 22)
		designNew:setFont("bh20")
		designNew:setText(_T("DESIGN_NEW", "Design new"))
		
		local close = frame:getCloseButton()
		
		designNew:setPos(close.localX - designNew.w - _S(10), close.localY)
	end
	
	local descbox = gui.create("GenreThemeMatchDescbox")
	
	descbox:tieVisibilityTo(frame)
	descbox:hide()
	descbox:setID(gameProject.GENRE_THEME_MATCH_DESCBOX_ID)
	descbox:setPos(frame.x - _S(5), frame.y)
	descbox:bringUp()
	
	local descbox = gui.create("SubgenreMatchDescbox")
	
	descbox:tieVisibilityTo(frame)
	descbox:hide()
	descbox:setID(gameProject.GENRE_SUBGENRE_MATCH_DESCBOX_ID)
	descbox:setPos(frame.x + _S(5) + frame.w, frame.y)
	descbox:bringUp()
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(490, frame.rawH - 40)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:setAdjustElementPosition(false)
	scrollbar:setAdjustElementSize(false)
	scrollbar:addDepth(100)
	
	local padding = _S(3)
	local x, y = padding, padding
	local elemW, elemH = 242, 56
	
	for key, gData in ipairs(validGenreList) do
		local element = gui.create("GenreSelectionElement")
		
		element:setSize(elemW, elemH)
		element:setGenre(gData)
		element:setProject(self)
		element:createCheckboxes()
		scrollbar:addItem(element)
		element:setPos(x, y)
		
		if key % 2 == 0 then
			y = y + element.h + padding
			x = padding
		else
			x = x + element.w
		end
	end
	
	local canvas = scrollbar:getCanvas()
	local itemList = scrollbar:getItems()
	local lastItem = itemList[#itemList]
	
	canvas:setHeight(_US(lastItem.h + lastItem.y))
	scrollbar:verifySlider()
	
	if scrollbar:verifySlider() then
		local x, y = padding, padding
		
		elemW = elemW - _US(scrollbar:getScrollerSize() * 0.5)
		
		for key, item in ipairs(scrollbar:getItems()) do
			item:setSize(elemW, elemH)
			item:setPos(x, y)
			
			if key % 2 == 0 then
				y = y + item.h + padding
				x = padding
			else
				x = x + item.w
			end
		end
	end
	
	frameController:push(frame)
end

function gameProject:createThemeSelectionMenu(validThemeList)
	local frame = gui.create("Frame")
	
	frame:setFont("pix24")
	frame:setText(_T("SELECT_THEME_TITLE", "Select Theme"))
	frame:setSize(500, 400)
	frame:center()
	frame:addDepth(100)
	
	if #themes:getValidResearchThemes() > 0 then
		local designNew = gui.create("DesignNewThemeButton", frame)
		
		designNew:setSize(150, 22)
		designNew:setFont("bh20")
		designNew:setText(_T("DESIGN_NEW", "Design new"))
		
		local close = frame:getCloseButton()
		
		designNew:setPos(close.localX - designNew.w - _S(10), close.localY)
	end
	
	local descbox = gui.create("ThemeGenreMatchDescbox")
	
	descbox:tieVisibilityTo(frame)
	descbox:hide()
	descbox:setID(gameProject.THEME_GENRE_MATCH_DESCBOX_ID)
	descbox:setPos(frame.x - _S(5), frame.y)
	descbox:bringUp()
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(490, frame.rawH - 40)
	scrollbar:setSpacing(3)
	scrollbar:setPadding(3, 3)
	scrollbar:setAdjustElementPosition(false)
	scrollbar:setAdjustElementSize(false)
	scrollbar:addDepth(100)
	
	local padding = _S(3)
	local x, y = padding, padding
	local elemW, elemH = 242, 34
	
	for key, tData in ipairs(validThemeList) do
		local element = gui.create("ThemeSelectionElement")
		
		element:setSize(elemW, elemH)
		element:setTheme(tData)
		element:setProject(self)
		scrollbar:addItem(element)
		element:setPos(x, y)
		
		if key % 2 == 0 then
			y = y + element.h + padding
			x = padding
		else
			x = x + element.w
		end
	end
	
	local canvas = scrollbar:getCanvas()
	local itemList = scrollbar:getItems()
	local lastItem = itemList[#itemList]
	
	canvas:setHeight(_US(lastItem.h + lastItem.y))
	
	if scrollbar:verifySlider() then
		local x, y = padding, padding
		
		elemW = elemW - _US(scrollbar:getScrollerSize() * 0.5)
		
		for key, item in ipairs(scrollbar:getItems()) do
			item:setSize(elemW, elemH)
			item:setPos(x, y)
			
			if key % 2 == 0 then
				y = y + item.h + padding
				x = padding
			else
				x = x + item.w
			end
		end
	end
	
	frameController:push(frame)
end

function gameProject:getRequiredFeatureCountPercentage()
	return self.scale / (self.maxPriceScale or platformShare:getMaxGameScale()) * gameProject.SCALE_TO_FEATURE_COUNT_MAX
end

function gameProject:getMaxPriceFeatureLimiter()
	local standardKey, standardTable = review:getLatestStandardByYear(timeline:getYear(self.releaseDate or timeline.curTime))
	local implementedFeatureStandardPercentage = self.totalRequiredWork / (standardTable.workAmounts[self.curDevType] * self.scale * gameProject.SCALE_TO_WORKAMOUNT_MAX)
	local gamePrice = gameProject.PRICE_POINTS[math.min(#gameProject.PRICE_POINTS, math.max(1, math.ceil(implementedFeatureStandardPercentage * #gameProject.PRICE_POINTS)))]
	local revisionData = self.engine:getRevisionData(self.engineRevision)
	local featureCount = revisionData.featureCount
	local engineFeatureCountPerc = featureCount / (standardTable.engineTaskCount * (self.scale / (self.maxPriceScale or platformShare:getMaxGameScale())))
	local enginePrice = gameProject.PRICE_POINTS[math.min(#gameProject.PRICE_POINTS, math.max(1, math.ceil(engineFeatureCountPerc * #gameProject.PRICE_POINTS)))]
	
	return math.min(gamePrice, enginePrice)
end

function gameProject:setupWorkAmountFeatureSaleAffector(currentMaxWorkAmount)
	local implementedFeatureStandardPercentage = self.totalFinishedWork / (currentMaxWorkAmount * self.scale * gameProject.SCALE_TO_WORKAMOUNT_MAX)
	local maxPrice = gameProject.PRICE_POINTS[math.min(#gameProject.PRICE_POINTS, math.max(1, math.ceil(implementedFeatureStandardPercentage * #gameProject.PRICE_POINTS)))]
	local delta = self.price - maxPrice
	
	self.gameFeatureCountSaleAffector = 1
	
	if delta > 0 then
		self.gameFeatureCountSaleAffector = 1 / (1 + delta * gameProject.SCALE_TO_FEATURE_PRICE_DELTA_MULTIPLIER)
		self.featureCountSaleAffector = self.gameFeatureCountSaleAffector
	end
end

function gameProject:setupFeatureCountSaleAffector(standardEngineFeatCount)
	local revisionData = self.engine:getRevisionData(self.engineRevision)
	local featureCount = revisionData.featureCount
	
	self.engineFeatureCountPercentage = featureCount / (standardEngineFeatCount * (self.scale / (self.maxPriceScale or platformShare:getMaxGameScale())))
	
	local maxPrice = gameProject.PRICE_POINTS[math.min(#gameProject.PRICE_POINTS, math.max(1, math.ceil(self.engineFeatureCountPercentage * #gameProject.PRICE_POINTS)))]
	local delta = self.price - maxPrice
	
	self.engineFeatureCountSaleAffector = 1
	
	if delta > 0 then
		self.engineFeatureCountSaleAffector = 1 / (1 + delta * gameProject.SCALE_TO_FEATURE_PRICE_DELTA_MULTIPLIER)
		self.featureCountSaleAffector = self.gameFeatureCountSaleAffector * self.engineFeatureCountSaleAffector
	end
end

function gameProject:getFeatureCountSaleAffector()
	return self.featureCountSaleAffector
end

function gameProject:getEngineFeatureCountSaleAffector()
	return self.engineFeatureCountSaleAffector
end

function gameProject:getGameFeatureCountSaleAffector()
	return self.gameFeatureCountSaleAffector
end

function gameProject:getEngineFeatureCountPercentage()
	return self.engineFeatureCountPercentage
end

function gameProject:addRelatedGame(gameObj)
	if not self.relatedGames then
		self.relatedGames = {
			gameObj
		}
	elseif not table.find(self.relatedGames, gameObj) then
		table.insert(self.relatedGames, gameObj)
	end
end

function gameProject:removeRelatedGame(gameObj)
	if self.relatedGames then
		table.removeObject(self.relatedGames, gameObj)
	end
end

function gameProject:getRelatedGames()
	return self.relatedGames
end

function gameProject:wasSequelMade()
	if self.relatedGames then
		local newGame = gameProject.DEVELOPMENT_TYPE.NEW
		
		for key, gameObj in ipairs(self.relatedGames) do
			if gameObj:getGameType() == newGame then
				return true
			end
		end
	end
	
	return false
end

function gameProject:setSequelTo(gameProj, skipRelatedGame)
	local prevSequel = self.sequelTo
	
	self.sequelTo = gameProj
	
	if self.sequelTo then
		self:setFact("perspective", gameProj:getFact("perspective"))
		
		if not skipRelatedGame then
			gameProj:addRelatedGame(self)
		end
	else
		self:setFact("perspective", nil)
		
		if prevSequel then
			prevSequel:removeRelatedGame(self)
		end
		
		if self.curDevType == gameProject.DEVELOPMENT_TYPE.EXPANSION then
			self:setGameType(gameProject.DEVELOPMENT_TYPE.NEW)
		end
	end
	
	self:verifyPerspectiveState()
	events:fire(gameProject.EVENTS.SET_PREQUEL, self, gameProj)
end

function gameProject:createPrequelSelectionMenu()
	local frame = gui.create("Frame")
	
	frame:setSize(460, 600)
	frame:center()
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("SELECT_PREQUEL_TITLE", "Select Prequel"))
	
	local scrollBarPanel = gui.create("ScrollbarPanel", frame)
	
	scrollBarPanel:setSize(frame.rawW - 10, frame.rawH - 35)
	scrollBarPanel:setPos(_S(5), _S(30))
	scrollBarPanel:setAdjustElementPosition(true)
	scrollBarPanel:setPadding(4, 4)
	scrollBarPanel:setSpacing(4)
	scrollBarPanel:addDepth(50)
	
	local category = gui.create("Category")
	
	category:setHeight(25)
	category:setFont(fonts.get("pix24"))
	category:setText(_T("RELEASED_GAMES", "Released games"))
	category:assumeScrollbar(scrollBarPanel)
	scrollBarPanel:addItem(category)
	
	local list = self.owner:getGames()
	
	for i = #list, 1, -1 do
		local gameObj = list[i]
		
		if gameObj ~= self and gameObj:getReleaseDate() and gameObj:isNewGame() and self.contractor == gameObj:getContractor() then
			local button = gui.create("PrequelSelectionButton")
			
			button:setHeight(60)
			button:setProject(self)
			button:setFont(fonts.get("pix22"))
			button:setPrequel(gameObj)
			button:setBasePanel(frame)
			category:addItem(button)
		end
	end
	
	frameController:push(frame)
end

local tasksWithIssues = {}

function gameProject:performAudienceIssueDiscovery()
	local clampedRealRating = math.max(1, self.realRating)
	local ratingDelta = gameProject.MAXIMUM_SCORE_BEFORE_FACTOR_DROP - clampedRealRating
	
	ratingDelta = (ratingDelta - 1) / gameProject.MAXIMUM_SCORE_BEFORE_FACTOR_DROP
	
	local audience = self.totalSales
	
	if ratingDelta > 0 then
		audience = self.totalSales * math.lerp(gameProject.ISSUE_DISCOVERY_MINIMUM_FACTOR, gameProject.ISSUE_DISCOVERY_MAXIMUM_FACTOR, ratingDelta)
	else
		audience = audience * gameProject.ISSUE_DISCOVERY_MAXIMUM_FACTOR
	end
	
	self.issueDiscoveryProgress = self.issueDiscoveryProgress + math.min(audience / gameProject.AUDIENCE_TO_DISCOVERY_DIVIDER, gameProject.MAXIMUM_ISSUES_DISCOVERED_PER_DAY)
	
	local flooredDiscoveryProgress = math.floor(self.issueDiscoveryProgress)
	
	if flooredDiscoveryProgress > 0 then
		local stage = self.stages[2]
		
		for key, taskObject in ipairs(stage.tasks) do
			if taskObject:canHaveIssues() and taskObject:hasAtLeastOneUndiscoveredUnfixedIssue() then
				tasksWithIssues[#tasksWithIssues + 1] = taskObject
			end
		end
		
		if #tasksWithIssues == 0 then
			self.allIssuesDiscovered = true
			
			return 
		end
		
		local issuesToDiscover = flooredDiscoveryProgress
		
		while issuesToDiscover > 0 and #tasksWithIssues > 0 do
			local randomIndex = math.random(1, #tasksWithIssues)
			local randomTaskObject = tasksWithIssues[randomIndex]
			local discoverableIssueTypes, issueCount = randomTaskObject:getDiscoverableIssueTypes()
			local randomIssueType = discoverableIssueTypes[math.random(1, #discoverableIssueTypes)]
			
			randomTaskObject:discoverIssue(randomIssueType, false)
			
			if issueCount == 1 then
				table.remove(tasksWithIssues, randomIndex)
			end
		end
		
		if #tasksWithIssues == 0 then
			self.allIssuesDiscovered = true
		end
	end
end

function gameProject:createQADisplay()
	if self.owner:isPlayer() then
		local qaDisplay = gui.create("QAIssueDisplay")
		
		game.addToProjectScroller(qaDisplay, self)
	end
end

function gameProject:isOffMarket()
	return self.offMarket
end

function gameProject:canPresentAtConvention()
	return not self.offMarket and not self.releaseDate
end

function gameProject:createSaleDisplay()
	if self.owner:isPlayer() and self.releaseDate and not self.offMarket then
		local saleDisplay = gui.create("SaleDisplayFrame")
		
		game.addToProjectScroller(saleDisplay, self)
	end
end

function gameProject:getSequelTo()
	return self.sequelTo
end

function gameProject:isNewGame()
	return not self.sequelTo or self.sequelTo and gameProject.SEQUEL_DEV_TYPES[self.curDevType]
end

function gameProject:performAutoInterview(reviewerObject)
	self.shownInterviews = self.shownInterviews + 1
	self.lastInterviewTime = timeline.curTime
	
	local id = reviewerObject:getID()
	
	self:setInterviewCooldown(id, gameProject.AUTO_ADD_INTERVIEW_COOLDOWN)
	
	local interviewObj = interview.new(self, reviewerObject)
	
	interviewObj:createInterviewOfferPopup()
	review:setInterviewCooldown(gameProject.GLOBAL_AUTO_ADD_INTERVIEW_COOLDOWN)
end

function gameProject:setInterviewCooldown(reviewerID, cooldown)
	local data = self:getInterviewCooldown(reviewerID)
	
	if data then
		data.cooldown = cooldown
	else
		self.interviewCooldown[#self.interviewCooldown + 1] = {
			id = id,
			cooldown = cooldown
		}
	end
end

function gameProject:getInterviewCooldown(reviewerID)
	for key, data in ipairs(self.interviewCooldown) do
		if data.id == reviewerID then
			return data
		end
	end
	
	return nil
end

function gameProject:getLastInterviewTime()
	return self.lastInterviewTime
end

function gameProject:onAdvertisementSelected(id, ...)
	local data = advertisement:getData(id)
	
	data:onSelected(self, ...)
end

function gameProject:addAdvertisement(id, skipActive)
	local count = self.advertisements[id]
	
	if not skipActive then
		self:addActiveAdvertisement(id)
	end
	
	self.advertisements[id] = count and count + 1 or 1
	
	events:fire(advertisement.EVENTS.STARTED_ADVERTISEMENT, self, id)
end

function gameProject:getTimesAdvertised(id)
	return self.advertisements[id] or 0
end

function gameProject:getAdvertisements()
	return self.advertisements
end

function gameProject:wasAdvertised()
	for type, times in pairs(self.advertisements) do
		if times > 0 then
			return true
		end
	end
	
	return false
end

function gameProject:setTheme(theme)
	self.theme = theme
	
	events:fire(gameProject.EVENTS.CHANGED_THEME, self, theme)
end

function gameProject:getTheme()
	return self.theme
end

function gameProject:setPlatformState(id, state)
	if not state then
		table.removeObject(self.platforms, id)
		
		self.platformCount = self.platformCount - 1
		self.platformScaleMax = gameProject.SCALE_MAX
		
		local manufac = platformShare:getPlatformByID(id):getManufacturerID()
		
		if manufac then
			self:changeManufacturerConsoleCount(manufac, -1)
		end
		
		for key, platformID in ipairs(self.platforms) do
			self.platformScaleMax = math.min(self.platformScaleMax, platformShare:getPlatformByID(platformID):getMaxProjectScale())
		end
	else
		table.insert(self.platforms, id)
		
		self.platformCount = self.platformCount + 1
		
		local obj = platformShare:getPlatformByID(id)
		
		self.platformScaleMax = math.min(obj:getMaxProjectScale(), self.platformScaleMax)
		
		local manufac = obj:getManufacturerID()
		
		if manufac then
			self:changeManufacturerConsoleCount(manufac, 1)
		end
	end
	
	self.scale = math.min(self.scale, self.platformScaleMax)
	
	if not self._minimalEffort then
		self:calculatePlatformWorkAmountAffector()
		events:fire(gameProject.EVENTS.PLATFORM_STATE_CHANGED, self, id, state)
	end
end

function gameProject:changeManufacturerConsoleCount(manufacturerID, amount)
	local value = self.manufacturerPlatformCount[manufacturerID]
	
	self.manufacturerPlatformCount[manufacturerID] = (self.manufacturerPlatformCount[manufacturerID] or 0) + amount
	
	if not value or value == 0 then
		if self.manufacturerPlatformCount[manufacturerID] > 0 then
			self.manufacturerCount = self.manufacturerCount + 1
		end
	elseif self.manufacturerPlatformCount[manufacturerID] == 0 then
		self.manufacturerCount = self.manufacturerCount - 1
	end
end

function gameProject:getManufacturerCount()
	return self.manufacturerCount
end

function gameProject:countManufacturerConsoleAmount()
	for key, platformID in ipairs(self.platforms) do
		local manufac = platformShare:getPlatformByID(platformID)
		
		if manufac then
			self:changeManufacturerConsoleCount(manufac, 1)
		end
	end
end

function gameProject:getManufacturerConsoleCount(id)
	return self.manufacturerPlatformCount[id] or 0
end

function gameProject:getPlatformScaleBoundary()
	return self.platformScaleMax
end

function gameProject:getPlatformCount()
	return self.platformCount
end

function gameProject:addToPlatforms(increaseCounter, recalculateAttract)
	for key, platform in ipairs(self.platforms) do
		platformShare:addGameToPlatform(platform, self, increaseCounter, recalculateAttract)
	end
end

function gameProject:calculatePlatformWorkAmountAffector()
	local affector = 0
	
	for key, platformID in ipairs(self.platforms) do
		affector = affector + platformShare:getPlatformByID(platformID):getDevelopmentDifficulty()
	end
	
	self.platformWorkAmountAffector = platforms.BASE_DEVELOPMENT_TIME_AFFECTOR + affector
end

function gameProject:getPlatformWorkAmountAffector()
	return self.platformWorkAmountAffector
end

function gameProject:getPlatformState(id)
	local key = table.find(self.platforms, id)
	
	return key ~= nil
end

function gameProject:getTargetPlatforms()
	return self.platforms
end

function gameProject:setRecoupAmount(amount)
	self.recoupAmount = amount
end

function gameProject:getRecoupAmount()
	return self.recoupAmount
end

function gameProject:setSubgenre(genre)
	self.subgenre = genre
	
	if self.subgenre and self.subgenre == self.genre then
		self:setGenre(nil)
	end
	
	events:fire(gameProject.EVENTS.SUBGENRE_CHANGED, self, genre)
end

function gameProject:getSubgenre()
	return self.subgenre
end

function gameProject:setGenre(genre)
	if self.contractData and genre ~= self.contractData:getDesiredGenre() then
		return false
	end
	
	if self.genre == genre then
		return false
	end
	
	self.genre = genre
	
	if self.genre and self.subgenre == self.genre then
		self:setSubgenre(nil)
	end
	
	events:fire(gameProject.EVENTS.CHANGED_GENRE, self, genre)
	
	return true
end

function gameProject:getGenre()
	return self.genre
end

function gameProject:setAudience(aud)
	self.audience = aud
	
	events:fire(gameProject.EVENTS.AUDIENCE_CHANGED, self)
end

function gameProject:getAudience()
	return self.audience
end

function gameProject:setPrice(price)
	if self.contractor and price ~= self.contractor:getDesiredCost() then
		return false
	end
	
	local oldPrice = self.price
	
	self.price = price
	
	self:updateEditionPrices(oldPrice or 0)
	events:fire(gameProject.EVENTS.CHANGED_PRICE, self)
	
	return true
end

function gameProject:getPrice()
	return self.price
end

function gameProject:setStage(...)
	engine.setStage(self, ...)
	
	if self:canReleaseGame() and not self.releaseDate then
		events:fire(gameProject.EVENTS.REACHED_RELEASE_STATE, self)
	end
end

function gameProject:setContractor(contractor)
	self.contractor = contractor
	
	if not self.contractorFunding then
		self.contractorFunding = 0
	end
	
	self:setGenre(self.contractData:getDesiredGenre())
	self:setScale(self.contractData:getScale())
	self:setGameType(self.contractData:getGameType())
	self:setPrice(contractor:getDesiredCost())
end

function gameProject:setDeadline(deadline)
	self.deadline = deadline
end

function gameProject:getDeadline()
	return self.deadline
end

function gameProject:getContractor()
	return self.contractor
end

function gameProject:setContractData(data)
	self.contractData = data
end

function gameProject:getContractData()
	return self.contractData
end

function gameProject:updateSaleAffectors()
	self.maxPriceScale = platformShare:getMaxGameScale()
	
	self:updatePrequelSaleAffector()
	
	self.issueSaleAffector = self:calculateIssueSaleAffector()
	
	self:calculateExpansionSaleDivider()
	
	self.scalePriceAffector = self:getScalePriceRelationAffector()
	self.reviewRatingRepMult = self:calculateReviewRatingReputationMultiplier()
	self.priceSaleAffector = self:getScalePriceAffector()
	
	self:updateGenreMatchValue()
	self:updateScorePopularityAffector()
end

function gameProject:updateScorePopularityAffector()
	self.scorePopAffector = self:getScorePopularityAffector()
end

function gameProject:verifyReviewStandard()
	if not self.realReviewStandard then
		review:setupRealReviewStandard(self)
	end
end

function gameProject:validatePlatforms()
	local index = 1
	
	for i = 1, #self.platforms do
		local platformID = self.platforms[index]
		
		if not platformShare:getOnMarketPlatformByID(platformID) then
			table.remove(self.platforms, index)
		else
			index = index + 1
		end
	end
end

function gameProject:calculateReviewRepGainScaler()
	local maxPossibleScale = 0
	local relDate = self.releaseDate
	
	for key, platformObj in ipairs(platformShare:getOnMarketPlatforms()) do
		maxPossibleScale = math.max(maxPossibleScale, platformObj:getMaxProjectScale(relDate))
	end
	
	local scaleBounds = self:getScaleBounds(self.curDevType)
	local lowerBound = gameProject.MIN_REVIEW_REP_GAIN
	local rep = self.owner:getReputation()
	
	if rep < gameProject.MIN_REVIEW_REP_GAIN_REPUTATION then
		lowerBound = lowerBound + math.min(1, 1 - rep / gameProject.MIN_REVIEW_REP_GAIN_REPUTATION) * gameProject.MIN_REVIEW_REP_GAIN_UPPER_LIMIT
	end
	
	self.reviewRepGainScaler = math.max(lowerBound, math.min(gameProject.MAX_REVIEW_REP_GAIN, self.scale / (math.min(scaleBounds[2], maxPossibleScale) * gameProject.MAX_REVIEW_REP_GAIN_SCALE)))
end

function gameProject:getPiratedCopies()
	return self.piratedCopies
end

function gameProject:getPiracyPercentage()
	return math.min(1, math.max(0, self.piratedCopies / self.totalSales))
end

function gameProject:getNicePiracyPercentage()
	return math.round(self:getPiracyPercentage() * 100, 1)
end

function gameProject:release(skip)
	self.piratedCopies = 0
	
	if not skip and self.curDevType == gameProject.DEVELOPMENT_TYPE.MMO then
		self:createPrereleaseSubscriptionFeeMenu()
		
		return 
	end
	
	local requiresEvaluation = review:setReviewStandard(self)
	
	for key, platformID in ipairs(self.platforms) do
		self.salesByPlatform[platformID] = 0
		
		local obj = platformShare:getPlatformByID(platformID)
		
		if obj.PLAYER then
			obj:changeInterest(self.popularity * gameProject.INTEREST_TO_PLATFORM_INTEREST)
		end
	end
	
	self:verifyReviewStandard()
	
	if requiresEvaluation then
		review:evaluateGameStandard(self)
	end
	
	self:announce(true)
	self:setReleaseDate(timeline.curTime)
	self:setupCutsPerSale()
	self.owner:releaseGame(self)
	self:updateSaleAffectors()
	self:updateTrendContribution()
	self:calculateReviewRepGainScaler()
	self:calculateEditionPurchasePercentages()
	self:performAdvertisementEffects()
	
	self.repetitivenessSaleAffector = self:calculateRepetitivenessSaleAffector()
	
	self.owner:setFact(gameProject.FINISHED_GAMES_FACT, (self.owner:getFact(gameProject.FINISHED_GAMES_FACT) or 0) + 1)
	self:createSaleDisplay()
	self:validatePlatforms()
	self:calculateDRMAffectors()
	
	if self.owner:isPlayer() then
		local event = scheduledEvents:instantiateEvent("game_edition_reaction")
		
		event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
		event:setProject(self)
	end
	
	local callback = gameProject.GAME_TYPE_RELEASE_CALLBACK[self.curDevType]
	
	if callback then
		callback(self)
	end
	
	self:createLogicPieces()
	
	if not self:isStageDone(3) then
		for key, taskObj in ipairs(self.stages[3]:getTasks()) do
			local assignee = taskObj:getAssignee()
			
			if assignee then
				assignee:cancelTask()
			end
		end
	end
	
	self.subEvents:onGameReleased(self)
end

function gameProject:updateGenreMatchValue()
	local genreMatch = themes:getMatch(self)
	
	if self.subgenre then
		self.subgenreMatch = genres:getSubgenreMatch(self.genre, self.subgenre)
		genreMatch = genreMatch * self.subgenreMatch
	end
	
	self.genreMatchBase = genreMatch - 1
end

function gameProject:isStageDone(stage)
	stage = stage or self.stage
	
	if self:getFact(gameProject.REMOVED_FROM_EVENT_RECEIVING) then
		return true
	end
	
	return self.stages[stage]:isDone()
end

function gameProject:performAdvertisementEffects()
	for adID, amount in pairs(self.advertisements) do
		local data = advertisement:getData(adID)
		
		if data then
			data:postRelease(self, amount)
		end
	end
end

function gameProject:getGameTypeStageTasks()
	return gameProject.MANDATORY_STAGE_TASK_CATEGORIES[self.curDevType]
end

function gameProject:getMandatoryStageTasks(stage)
	return self:getGameTypeStageTasks()[stage or self.stage]
end

function gameProject:updateMMOState()
	local mmo = gameProject.DEVELOPMENT_TYPE.MMO
	
	if self.sequelTo and self.sequelTo:getGameType() == mmo then
		self.prevGameMMO = true
	end
	
	if self.curDevType == mmo then
		self.isMMO = true
	end
end

function gameProject:onReleaseGame()
	self:updateRealGameRating()
	
	self.canEvaluateIssues = true
	
	if self.sequelTo and gameProject.CONTENT_POINTS_ON_DEV_TYPE[self.curDevType] then
		self.sequelTo:addExpansionPack(self)
	end
	
	self:updateMMOState()
	
	if self.isMMO then
		serverRenting:addActiveMMO(self)
	end
	
	self:calculateExpansionSaleAffector()
	self:setFact(gameProject.RELEASED_GAME, true)
end

function gameProject:setPopularity(amount)
	self.popularity = amount
end

function gameProject:getAverageRating()
	local total = self.realRating
	
	if self.rating > 0 then
		total = (total + self.rating) / 2
	end
	
	return total
end

gameProject.SALE_AFFECTOR_DECREASE_CHANGE = {
	finish = 0.5,
	start = 1,
	max = 100,
	base = 30
}

function gameProject:getTimeSaleDecreaseMultiplier()
	local change = gameProject.SALE_AFFECTOR_DECREASE_CHANGE
	local relDate = self.releaseDate
	
	if not relDate then
		return change.start
	end
	
	local delta = timeline.curTime - relDate - change.base
	
	if delta < 0 then
		return change.start
	end
	
	local maxVal = change.max
	
	return math.lerp(change.start, change.finish, math.min(maxVal, delta) / maxVal)
end

function gameProject:increasePopularity(amount, addReputation, maxRepGain, limiterMultiplier)
	if self.releaseDate then
		amount = math.round(amount * (self:getAverageRating() / review.maxRating))
	end
	
	if not self:isNewGame() then
		local sequelTo = self.sequelTo
		
		if sequelTo and not sequelTo:isOffMarket() then
			local devType = gameProject.DEVELOPMENT_TYPE
			
			if sequelTo:getGameType() == devType.NEW then
				sequelTo:increasePopularity(amount * gameProject.EXPANSION_POPULARITY_TRANSFER)
			else
				sequelTo:increasePopularity(amount * gameProject.MMO_EXPANSION_POPULARITY_TRANSFER)
			end
		end
	end
	
	limiterMultiplier = limiterMultiplier or gameProject.DEFAULT_POP_GAIN_LIMITER_MULTIPLIER
	
	local popChange = math.ceil(amount * gameProject.POPULARITY_MULTIPLIER)
	local popAmount = popChange
	local result = self.popularity + popChange
	local cutoff = self.owner:getReputation() * limiterMultiplier + gameProject.MAX_EXTRA_INTEREST
	local distance = result - cutoff
	local multiplier = 1
	
	if distance > 0 then
		local finalDist = math.min(1, math.max(0, distance / gameProject.MAX_FINAL_INTEREST))
		
		multiplier = math.lerp(1, gameProject.MINIMUM_INTEREST_GAIN, finalDist)
		
		if cutoff > self.popularity and cutoff < result then
			local distToCutoff = cutoff - self.popularity
			
			popAmount = math.ceil(distToCutoff + distance * multiplier)
		else
			popAmount = math.ceil(popAmount * multiplier)
		end
	end
	
	local result = self.momentPopularity + amount
	local hypeCutoff = cutoff / gameProject.POPULARITY_MULTIPLIER
	local distance = result - hypeCutoff
	local multiplier = 1
	
	if distance > 0 then
		local finalDist = math.min(1, math.max(0, distance / (gameProject.MAX_FINAL_INTEREST / gameProject.POPULARITY_MULTIPLIER)))
		
		multiplier = math.lerp(1, gameProject.MINIMUM_INTEREST_GAIN, finalDist)
		
		if hypeCutoff > self.momentPopularity and hypeCutoff < result then
			local distToCutoff = hypeCutoff - self.momentPopularity
			
			amount = math.ceil(distToCutoff + distance * multiplier)
		else
			amount = math.ceil(amount * multiplier)
		end
	end
	
	self.popularity = self.popularity + popAmount
	
	self:changeTimeSaleAffector(-math.min(gameProject.MAX_TIME_SALE_AFFECTOR_FROM_POPULARITY, amount / gameProject.POPULARITY_TO_TIME_SALE_AFFECTOR) * self:getTimeSaleDecreaseMultiplier())
	
	local popularityFade = math.floor(amount * gameProject.POPULARITY_TO_FADE_AFFECTOR)
	local fadeSpeedChange = math.floor(amount * gameProject.POPULARITY_TO_FADE_SPEED_DECREASE)
	
	self.popularityFade = math.min(gameProject.MAX_POPULARITY_FADE_VALUE, self.popularityFade + popularityFade)
	self.popularityFadeSpeed = math.max(0, self.popularityFadeSpeed - fadeSpeedChange)
	
	self:increaseMomentPopularity(amount)
	
	if addReputation then
		local mult = gameProject.DEFAULT_POPULARITY_TO_REPUTATION_MULT
		
		if type(addReputation) == "number" then
		end
		
		if self.contractor or self.publisher then
			mult = mult * gameProject.REPUTATION_GAIN_FROM_POPULARITY_WITH_CONTRACTOR
		end
		
		local repGain = math.min(maxRepGain or math.huge, amount * mult)
		
		self.owner:increaseReputation(repGain)
		
		return repGain, amount
	end
	
	return 0, amount
end

function gameProject:decreasePopularity(amount)
	local popChange = math.ceil(amount * gameProject.POPULARITY_MULTIPLIER)
	
	self.popularity = math.max(0, self.popularity - popChange)
	
	self:increaseMomentPopularity(-amount)
end

function gameProject:getPopularity()
	return self.popularity
end

function gameProject:createProjectAdvertisementPopup()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 604)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("ADVERTISE_GAME_HEADER_TITLE", "Advertise Game"))
	frame:center()
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(34))
	scrollbar:setSize(390, 565)
	scrollbar:setSpacing(4)
	scrollbar:setPadding(4, 4)
	scrollbar:setAdjustElementPosition(true)
	
	local title = gui.create("Category")
	
	title:setFont(fonts.get("pix24"))
	title:setText(_T("SELECT_ADVERTISEMENT_TYPE", "Select advertisement type"))
	title:setHeight(25)
	title:assumeScrollbar(scrollbar)
	scrollbar:addItem(title)
	
	for key, data in ipairs(advertisement.registered) do
		if data:isAvailable(self) then
			local selection = gui.create("AdvertisementSelectionButton")
			
			selection:setFont(fonts.get("pix20"))
			selection:setProject(self)
			selection:setAdvertData(data)
			selection:setHeight(65)
			title:addItem(selection)
		end
	end
	
	frameController:push(frame)
	events:fire(gameProject.EVENTS.ADVERT_MENU_OPENED, self, frame)
end

function gameProject:getScrapRepLoss()
	local pop = self.popularity + self.momentPopularity - gameProject.REPUTATION_DECREASE_MINIMUM_POPULARITY
	
	if pop > 0 then
		return math.floor(pop * gameProject.REPUTATION_LOSS_PER_POP_POINT)
	end
	
	return 0
end

function gameProject:scrap()
	complexProject.scrap(self)
	self.owner:removeGame(self)
	
	if not self:isStageDone(1) then
		self:recoupPaidDesiredFeatureCost()
	end
	
	for key, employee in ipairs(self.owner:getEmployees()) do
		employee:onProjectScrapped(self)
	end
	
	self.owner:setFact(gameProject.SCRAPPED_GAMES_FACT, (self.owner:getFact(gameProject.SCRAPPED_GAMES_FACT) or 0) + 1)
	
	local repLoss = self:getScrapRepLoss()
	
	if repLoss > 0 then
		local event = scheduledEvents:instantiateEvent("cancelled_game_disappointment")
		
		event:setGameName(self:getName())
		event:setActivationDate(math.floor(timeline.curTime + timeline.DAYS_IN_WEEK))
		event:setReputationDrop(repLoss)
	end
	
	if self.publisher then
		self.publisher:onScrapProject(self)
	end
	
	if self.sequelTo then
		self.sequelTo:removeRelatedGame(self)
	end
	
	for key, adId in ipairs(self.activeAdvertisements) do
		advertisement.registeredByID[adId]:onScrapped(gameProj)
		
		self.activeAdvertisements[key] = nil
	end
end

local taskList = {
	finished = {},
	inProgress = {}
}

gameProject.popularityDescriptionText = {
	{
		font = "pix20",
		wrapWidth = 500,
		iconH = 20,
		iconW = 20,
		lineSpace = 0,
		icon = "question_mark",
		text = _T("POPULARITY_DESC_1", "Popularity is gained by advertising & revealing games.")
	},
	{
		font = "bh18",
		wrapWidth = 500,
		lineSpace = 0,
		text = _T("POPULARITY_DESC_2", "Each popularity point is a single possible copy of the game being sold, which is then affected by multiple factors.")
	}
}
gameProject.momentPopularityDescriptionText = {
	{
		font = "pix20",
		wrapWidth = 500,
		iconH = 20,
		iconW = 20,
		lineSpace = 0,
		icon = "question_mark",
		text = _T("HYPE_DESC_1", "Hype is gained when popularity increases.")
	},
	{
		font = "bh18",
		wrapWidth = 500,
		lineSpace = 10,
		text = _T("HYPE_DESC_2", "It affects game sales the exact same way as popularity does, but wears off over time if the game is not being advertised for a long time.")
	},
	{
		font = "bh18",
		wrapWidth = 500,
		lineSpace = 0,
		text = _T("HYPE_DESC_3", "Hype also wears off when people buy the game.")
	}
}

function gameProject:getMaxPlatformUsers()
	local max = 0
	
	for key, platformID in ipairs(self.platforms) do
		max = max + platformShare:getPlatformByID(platformID):getMarketShare()
	end
	
	return max
end

function gameProject:createRenamingPopup()
	local frame = gui.create("Frame")
	
	frame:setSize(440, 105)
	frame:setFont("pix24")
	frame:setTitle(_T("RENAME_GAME_TITLE_TITLE", "Rename Game"))
	
	local textbox = gui.create("ProjectRenamingTextbox", frame)
	
	textbox:setSize(430, 30)
	textbox:setPos(_S(5), _S(35))
	textbox:setFont("pix20")
	textbox:setProject(self)
	textbox:setAutoAdjustFonts(fonts.GENERIC_TEXT_AUTO_ADJUST_FONTS)
	
	local confirmButton = gui.create("ProjectRenamingConfirmButton", frame)
	
	confirmButton:setSize(212, 30)
	confirmButton:setPos(textbox.x, textbox.y + textbox.h + _S(5))
	confirmButton:setFont("pix24")
	confirmButton:setText(_T("RENAME", "Rename"))
	confirmButton:setProject(self)
	confirmButton:setTextbox(textbox)
	textbox:setConfirmButton(confirmButton)
	
	local cancelButton = gui.create("GenericFrameControllerPopButton", frame)
	
	cancelButton:setSize(212, 30)
	cancelButton:setPos(confirmButton.x + confirmButton.w + _S(5), confirmButton.y)
	cancelButton:setFont("pix24")
	cancelButton:setText(_T("CANCEL", "Cancel"))
	frame:center()
	frameController:push(frame)
end

function gameProject:createQualityPointDisplay(frame)
	local qualityPointList = gui.create("TitledList")
	
	qualityPointList:setFont("pix24")
	qualityPointList:setTitle(_T("QUALITY_TITLE", "Quality"))
	qualityPointList:setBasePoint(frame.x - _S(10), frame.y)
	qualityPointList:setAlignment(gui.SIDES.LEFT, nil)
	qualityPointList:setDepth(1000)
	qualityPointList:tieVisibilityTo(frame)
	
	local width, height = _S(80), _S(24)
	
	for key, qualityData in ipairs(gameQuality.registered) do
		local qualityDisplay = gui.create("QualityPointDisplay", qualityPointList)
		
		qualityDisplay:setSize(width, height)
		qualityDisplay:setProject(self)
		qualityDisplay:setData(qualityData, self:getQuality(qualityData.id))
	end
	
	qualityPointList:updateLayout()
	
	return qualityPointList
end

gameProject.MARKET_SATURATION_HOVER_TEXT = {
	{
		font = "bh18",
		icon = "question_mark",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("GAME_MARKET_SATURATION_DESCRIPTION", "The total amount of people from the entire gaming customer pool that have purchased this game.")
	}
}
gameProject.COPY_PRICE_HOVER_TEXT = {
	{
		icon = "question_mark",
		font = "bh18",
		iconWidth = 22,
		iconHeight = 22
	}
}
gameProject.GAME_SCALE_HOVER_TEXT = {
	{
		font = "bh18",
		icon = "question_mark",
		iconHeight = 22,
		iconWidth = 22,
		text = _T("GAME_SCALE_DESCRIPTION_1", "The size of this product. Higher game prices require a greater game scale to not suffer a loss of sales, due to the ratio of price-to-content not being favorable towards players.")
	}
}
gameProject.GAME_RATING_HOVER_TEXT = {
	{
		font = "bh18",
		icon = "question_mark",
		iconHeight = 22,
		lineSpace = 6,
		iconWidth = 22,
		text = _T("GAME_RATING_DESCRIPTION_1", "The average game rating of all reviews.")
	},
	{
		font = "bh18",
		iconHeight = 22,
		icon = "exclamation_point",
		lineSpace = 6,
		iconWidth = 22
	},
	{
		font = "pix18",
		text = _T("GAME_RATING_DESCRIPTION_2", "Game ratings influence the game sales, so naturally they are very important. What people really think of your games might differ from reviews, especially if you've bribed reviewers. This disparity can lead to suspicion from your playerbase and ultimately a loss of Reputation and Opinion.")
	}
}
gameProject.PIRACY_HOVER_TEXT = {
	{
		font = "bh20",
		icon = "question_mark",
		iconHeight = 22,
		lineSpace = 6,
		iconWidth = 22,
		text = _T("PIRACY_DESCRIPTION_1", "Pirated game copies do not equate to lost sales.")
	},
	{
		font = "pix18",
		text = _T("PIRACY_DESCRIPTION_2", "Even people that did pirate your game may come around and purchase your game later on. The severity of piracy depends on your Opinion level, the game rating, and whether you're using any sort of Digital Rights Management.")
	}
}

function gameProject:fillGameInfoScroller(scroller)
	local statsCat = gui.create("Category")
	
	statsCat:setFont("bh24")
	statsCat:setText(_T("GAME_PROJECT_BASIC_INFO", "Info"))
	statsCat:assumeScrollbar(scroller)
	scroller:addItem(statsCat)
	
	local w, h = scroller:getSize()
	local ownerIsPlayer = self.owner:isPlayer()
	
	w = w - 20
	
	statsCat:addItem(self:_createTextPanel("project_stuff", "bh24", w, 24, nil, 26, self.name))
	
	local gameTypeText
	
	if self:isNewGame() then
		local prequel = self.sequelTo
		
		if prequel then
			gameTypeText = _format(_T("SEQUEL_TO", "Sequel to 'GAME'"), "GAME", prequel:getName())
		end
	else
		local prequel = self.sequelTo
		
		if prequel then
			gameTypeText = _format(_T("EXPANSION_PACK_FOR", "Expansion pack for 'EXPANSION'"), "EXPANSION", prequel:getName())
		end
	end
	
	if gameTypeText then
		statsCat:addItem(self:_createTextPanel("related_games", "bh22", w, 22, nil, 0, gameTypeText))
	end
	
	local releaseDate = self.releaseDate
	
	statsCat:addItem(self:_createTextPanel(genres:getData(self.genre).icon, "pix22", w, 22, nil, 24, self:getProjectTypeText()))
	
	local scaleElem = self:_createTextPanel("game_scale", "pix22", w, 22, nil, 24, _format(_T("GAME_SCALE", "Game scale: xSCALE"), "SCALE", math.round(self.scale, 2)))
	
	scaleElem:setHoverText(gameProject.GAME_SCALE_HOVER_TEXT)
	statsCat:addItem(scaleElem)
	
	if not releaseDate then
		if self:wasAnnounced() then
			statsCat:addItem(self:_createTextPanel("exclamation_point", "bh22", w, 24, nil, 0, _T("PROJECT_WAS_ANNOUNCED", "Project announced"), game.UI_COLORS.LIGHT_BLUE))
		else
			statsCat:addItem(self:_createTextPanel("question_mark", "bh22", w, 24, nil, 0, _T("PROJECT_NOT_ANNOUNCED", "Project not yet announced")))
		end
	end
	
	statsCat:addItem(self:_createTextPanel("clock_full", "pix22", w, 22, nil, 24, releaseDate and _format(_T("GAME_RELEASED_ON", "Released on YEAR/MONTH"), "YEAR", timeline:getYear(releaseDate), "MONTH", timeline:getMonth(releaseDate)) or _T("NOT_RELEASED_YET", "Not released yet")))
	
	if ownerIsPlayer then
		local days = self.daysWorkedOn
		
		statsCat:addItem(self:_createTextPanel("clock_full", "pix22", w, 22, nil, 24, days == 1 and _T("DAY_WORKED_ON_PROJECT", "Worked on for 1 day") or _format(_T("DAYS_WORKED_ON_PROJECT", "Worked on for DAYS"), "DAYS", timeline:getTimePeriodText(days))))
	end
	
	if releaseDate then
		if ownerIsPlayer then
			if #self.reviews > 0 then
				local elem = self:_createTextPanel("star", "bh22", w, 22, nil, 0, _format(_T("GAME_RATING_DISPLAY", "RATING/MAX average rating"), "RATING", math.round(self.rating, 1), "MAX", review.maxRating), game.UI_COLORS.LIGHT_BLUE)
				local high, low = -math.huge, math.huge
				
				for key, reviewObj in ipairs(self.reviews) do
					local rat = reviewObj:getRating()
					
					high = math.max(high, rat)
					low = math.min(low, rat)
				end
				
				gameProject.GAME_RATING_HOVER_TEXT[2].text = _format(_T("GAME_RATING_DESCRIPTION_3", "Highest rating: HIGHEST/MAX\nLowest rating: LOWEST/MAX"), "HIGHEST", high, "LOWEST", low, "MAX", review.maxRating)
				
				elem:setHoverText(gameProject.GAME_RATING_HOVER_TEXT)
				statsCat:addItem(elem)
			else
				statsCat:addItem(self:_createTextPanel("star", "bh22", w, 22, nil, 0, _T("NO_REVIEWS_YET", "No reviews yet"), game.UI_COLORS.LIGHT_BLUE))
			end
		else
			statsCat:addItem(self:_createTextPanel("star", "bh22", w, 22, nil, 0, _format(_T("GAME_REVIEW_RATING", "RATING/MAX average rating"), "RATING", math.round(self.rating, 1), "MAX", review.maxRating), game.UI_COLORS.LIGHT_BLUE))
		end
	end
	
	local financialCat = gui.create("Category")
	
	financialCat:setFont("bh24")
	financialCat:setText(_T("GAME_PROJECT_FINANCIAL_INFO", "Financial Stats"))
	financialCat:assumeScrollbar(scroller)
	scroller:addItem(financialCat)
	
	local copyPrice = self:_createTextPanel("game_copy_price", "pix20", w, 22, nil, 24, _format(_T("COST_PER_SALE", "$PRICE/copy (TAX% tax)"), "PRICE", self.price, "TAX", math.round((1 - gameProject.SALE_POST_TAX_PERCENTAGE) * 100, 1)))
	
	gameProject.COPY_PRICE_HOVER_TEXT[1].text = _format(_T("GAME_PRICE_DESCRIPTION", "The price this product sells for.\nThe post-tax earnings you get per each game copy is $MONEY."), "MONEY", math.round(self.price * gameProject.SALE_POST_TAX_PERCENTAGE, 2))
	
	copyPrice:setHoverText(gameProject.COPY_PRICE_HOVER_TEXT)
	financialCat:addItem(copyPrice)
	financialCat:addItem(self:_createTextPanel("game_copies_sold", "pix20", w, 22, nil, 24, _format(_T("GAME_SALE_AMOUNT", "COPIES copies sold"), "COPIES", string.roundtobignumber(self.totalSales))))
	
	local saturation = self:_createTextPanel("platform_interest", "pix20", w, 22, nil, 24, _format(_T("GAME_SALE_PERCENTAGE", "Market saturation: SATURATION%"), "SATURATION", math.round(math.min(1, self.totalSales / self:getMaxPlatformUsers()) * 100, 1)))
	
	saturation:setHoverText(gameProject.MARKET_SATURATION_HOVER_TEXT)
	financialCat:addItem(saturation)
	
	if ownerIsPlayer then
		financialCat:addItem(self:_createTextPanel("money_made", "bh20", w, 22, nil, 24, _format(_T("GAME_CASH_EARNED", "CASH earned"), "CASH", string.roundtobigcashnumber(self:getMoneyMade(nil))), game.UI_COLORS.GREEN))
		
		local moneySpent = self.moneySpent
		
		if moneySpent >= 0 then
			financialCat:addItem(self:_createTextPanel("money_lost", "bh20", w, 22, nil, 24, _format(_T("GAME_DEVELOPMENT_COSTS", "Development costs: COST"), "COST", string.roundtobigcashnumber(moneySpent)), game.UI_COLORS.LIGHT_RED))
		else
			financialCat:addItem(self:_createTextPanel("money_made", "bh20", w, 22, nil, 24, _format(_T("GAME_DEVELOPMENT_FUNDING", "Funding: COST"), "COST", string.roundtobigcashnumber(math.abs(moneySpent)))))
		end
		
		local net = self.totalRealMoneyMade - self.moneySpent
		local textColor = net >= 0 and game.UI_COLORS.GREEN or game.UI_COLORS.LIGHT_RED
		
		financialCat:addItem(self:_createTextPanel("money_made", "bh20", w, 22, nil, 24, _format(_T("GAME_FUNDS_NET_CHANGE", "Net change: COST"), "COST", string.roundtobigcashnumber(net)), textColor))
		
		if releaseDate and self:canPirate() then
			local piracyDisplay = self.totalSales > 0 and math.round(self.piratedCopies / self.totalSales * 100, 1) or 0
			local piracy = self:_createTextPanel("piracy", "bh20", w, 22, nil, 24, _format(_T("GAME_PIRACY_RATE", "Piracy rate: PIRACY%"), "PIRACY", piracyDisplay, game.UI_COLORS.LIGHT_RED))
			
			financialCat:addItem(piracy)
			piracy:setHoverText(gameProject.PIRACY_HOVER_TEXT)
		end
		
		if self.piracyStarted then
			local piracy = self:_createTextPanel("exclamation_point_red", "bh20", w, 24, nil, 0, _format(_T("GAME_CRACKED_ON", "Cracked TIME_PERIOD ago"), "TIME_PERIOD", timeline:getTimePeriodText(timeline.curTime - self.piracyStarted), game.UI_COLORS.LIGHT_RED))
			
			financialCat:addItem(piracy)
			piracy:setHoverText(gameProject.CRACKED_HOVER_TEXT)
		end
		
		local editSales = gui.create("Category")
		
		editSales:setFont("bh24")
		editSales:setText(_T("GAME_PROJECT_EDITION_SALES", "Edition Sales"))
		editSales:assumeScrollbar(scroller)
		scroller:addItem(editSales)
		
		local genre = self.genre
		
		for key, edit in ipairs(self.editions) do
			edit:updateIcon()
			
			local saleCount = self:_createTextPanel(edit:getIcon(), "bh20", w, 24, nil, 0, _format(_T("GAME_EDITION_SALES", "EDITION - SALES sales (PRICE)"), "EDITION", edit:getName(), "SALES", string.roundtobignumber(edit:getSales()), "PRICE", string.roundtobigcashnumber(edit:getPrice())), nil)
			
			edit:fillGameProjectDescbox(saleCount, self)
			editSales:addItem(saleCount)
		end
	end
	
	events:fire(gameProject.EVENTS.FILL_GAME_INFO_SCROLLER, self, scroller, statsCat, financialCat)
end

function gameProject:_createTextPanel(icon, font, baseW, iconW, iconH, backdropSize, text, color)
	local elem = gui.create("GradientIconPanel")
	
	elem:setIcon(icon)
	elem:setFont(font)
	elem:setBaseSize(baseW, 0)
	
	if backdropSize == 0 then
		elem:setBackdropVisible(false)
		
		backdropSize = iconW
	end
	
	elem:setIconSize(iconW, iconH, backdropSize)
	elem:setText(text)
	
	if color then
		elem:setTextColor(color)
	end
	
	return elem
end

function gameProject:createProjectInfoPopup()
	local frame = gui.create("Frame")
	
	frame:setSize(500, 570)
	frame:setFont(fonts.get("pix24"))
	frame:setTitle(_T("PROJECT_INFO_TITLE", "Project Info"))
	
	frame.lists = {}
	
	local hoverDescbox
	
	if not self.releaseDate and self:getOverallCompletion() < 1 then
		hoverDescbox = gui.create("WorkAmountDisplay")
		
		hoverDescbox:setProject(self)
		hoverDescbox:showDisplay()
		hoverDescbox:bringUp()
		hoverDescbox:tieVisibilityTo(frame)
	end
	
	local baseInfoPanel = gui.create("Panel", frame)
	
	baseInfoPanel:setPos(_S(5), _S(33))
	baseInfoPanel:setSize(490, 531)
	
	baseInfoPanel.shouldDraw = false
	
	local gameInfoScroll = gui.create("ScrollbarPanel", baseInfoPanel)
	
	gameInfoScroll:setSize(baseInfoPanel.rawW, 300)
	gameInfoScroll:setAdjustElementPosition(true)
	gameInfoScroll:setSpacing(3)
	gameInfoScroll:setPadding(3, 3)
	gameInfoScroll:addDepth(50)
	self:fillGameInfoScroller(gameInfoScroll)
	
	local progressBar = gui.create("GameCompletionProgressBar", baseInfoPanel)
	
	progressBar:setSize(baseInfoPanel.rawW, 44)
	progressBar:setPos(0, gameInfoScroll.h + _S(5))
	progressBar:setProject(self)
	progressBar:setHoverDescbox(hoverDescbox)
	progressBar:setDescboxOnHover(false)
	
	local scrollerY = progressBar.y + _S(15)
	local scrollerHeight = _US(baseInfoPanel.h - scrollerY)
	local platformsScrollbar = gui.create("ScrollbarPanel", baseInfoPanel)
	
	platformsScrollbar:setPos(0, scrollerY)
	platformsScrollbar:setSize(baseInfoPanel.rawW * 0.5 - 2, scrollerHeight)
	platformsScrollbar:setAdjustElementPosition(true)
	platformsScrollbar:setSpacing(3)
	platformsScrollbar:setPadding(3, 3)
	platformsScrollbar:addDepth(100)
	
	local saleCategory = gui.create("Category")
	
	saleCategory:setHeight(30)
	saleCategory:setFont(fonts.get("bh22"))
	saleCategory:setText(_T("SUPPORTED_PLATFORMS", "Supported platforms"))
	saleCategory:assumeScrollbar(platformsScrollbar)
	platformsScrollbar:addItem(saleCategory)
	
	for key, platformID in ipairs(self.platforms) do
		local platformElement = gui.create("GamePlatformSalesDisplay")
		
		platformElement:setSize(platformsScrollbar.rawW - 14, 65)
		platformElement:setPlatformProject(platformID, self)
		saleCategory:addItem(platformElement)
	end
	
	local reviewsScrollbar = gui.create("ScrollbarPanel", baseInfoPanel)
	
	reviewsScrollbar:setPos(baseInfoPanel.w * 0.5 + _S(2), scrollerY)
	reviewsScrollbar:setSize(baseInfoPanel.rawW * 0.5 - _S(2), scrollerHeight)
	reviewsScrollbar:setAdjustElementPosition(true)
	reviewsScrollbar:setSpacing(3)
	reviewsScrollbar:setPadding(3, 3)
	reviewsScrollbar:addDepth(150)
	
	local reviewCategory = gui.create("Category")
	
	reviewCategory:setHeight(30)
	reviewCategory:setFont(fonts.get("bh22"))
	reviewCategory:setText(_T("GAME_REVIEWS", "Game reviews"))
	reviewCategory:assumeScrollbar(reviewsScrollbar)
	reviewsScrollbar:addItem(reviewCategory)
	
	for key, reviewObj in ipairs(self.reviews) do
		local reviewElement = gui.create("GameReviewDisplay")
		
		reviewElement:setReviewProject(reviewObj, self)
		reviewCategory:addItem(reviewElement)
	end
	
	frame:center()
	
	if hoverDescbox then
		hoverDescbox:setPos(frame.x + _S(10) + frame.w, frame.y)
	end
	
	frame.lists[#frame.lists + 1] = self:createQualityPointDisplay(frame)
	
	local width, height = _S(80), _S(24)
	
	if self.owner:isPlayer() then
		local prevElement = frame.lists[#frame.lists]
		local issueList = gui.create("TitledList")
		
		issueList:setFont("pix24")
		issueList:setTitle(_T("ISSUES_TITLE", "Issues"))
		issueList:setBasePoint(prevElement.x + prevElement.w, prevElement.y + prevElement.h + _S(5))
		issueList:setAlignment(gui.SIDES.LEFT, nil)
		issueList:setDepth(1000)
		issueList:tieVisibilityTo(frame)
		table.insert(frame.lists, issueList)
		
		for key, issueData in ipairs(issues.registered) do
			local issueDisplay = gui.create("IssueDisplay", issueList)
			
			issueDisplay:setSize(width, height)
			issueDisplay:setData(issueData, self:getIssueCount(issueData.id))
		end
		
		issueList:updateLayout()
		
		local prevElement = frame.lists[#frame.lists]
		local popularityList = gui.create("TitledList")
		
		popularityList:setFont("pix22")
		popularityList:setTitle(_T("INTEREST_TITLE", "Interest"))
		popularityList:setBasePoint(prevElement.x + prevElement.w, prevElement.y + prevElement.h + _S(5))
		popularityList:setAlignment(gui.SIDES.LEFT, nil)
		popularityList:setDepth(1000)
		popularityList:tieVisibilityTo(frame)
		table.insert(frame.lists, popularityList)
		
		local popDisplay = gui.create("GenericPointDisplay", popularityList)
		
		popDisplay:setSize(width, height)
		popDisplay:setAutoAdjustFonts(fonts.BOLD_AUTO_ADJUST_FONTS)
		popDisplay:setText(string.roundtobignumber(self.popularity))
		popDisplay:setIcon("game_interest")
		popDisplay:setHoverText(gameProject.popularityDescriptionText)
		
		local momentPopDisplay = gui.create("GenericPointDisplay", popularityList)
		
		momentPopDisplay:setSize(width, height)
		momentPopDisplay:setAutoAdjustFonts(fonts.BOLD_AUTO_ADJUST_FONTS)
		momentPopDisplay:setText(string.roundtobignumber(self.momentPopularity))
		momentPopDisplay:setIcon("hype")
		momentPopDisplay:setHoverText(gameProject.momentPopularityDescriptionText)
		popularityList:updateLayout()
		
		local progress = self:getQAProgress()
		
		if progress then
			local prevElement = frame.lists[#frame.lists]
			local qaDisplayFrame = gui.create("QAProgressFrame")
			
			qaDisplayFrame:setPos(prevElement.x, prevElement.y + _S(5) + prevElement.h)
			qaDisplayFrame:setSize(prevElement.w, _S(50))
			qaDisplayFrame:setData(progress)
			qaDisplayFrame:tieVisibilityTo(frame)
			table.insert(frame.lists, qualityPointList)
		end
		
		if self.releaseDate and self.logicPieces then
			for key, logic in ipairs(self.logicPieces) do
				if logic.onOpenProjectsMenu then
					logic:onOpenProjectsMenu(frame)
				end
			end
		end
	end
	
	frameController:push(frame)
end

function gameProject:announce(quietAnnounce)
	self:setFact(gameProject.ANNOUNCED_FACT, true)
	
	if quietAnnounce then
		self:setFact(gameProject.REACTED_TO_ANNOUNCEMENT, true)
	else
		events:fire(gameProject.EVENTS.ANNOUNCED, self)
	end
end

function gameProject:wasAnnounced()
	return self.facts[gameProject.ANNOUNCED_FACT]
end

function gameProject:extendWorkPeriod()
	local stage = self.stages[gameProject.POLISHING_STAGE]
	local requiresReassignment = false
	local wasProjectDone = self:areAllStagesDone()
	local totalWork = 0
	
	for key, taskObj in ipairs(stage:getTasks()) do
		local taskTypeData = taskObj:getTaskTypeData()
		local old = taskObj:getRequiredWork()
		
		taskObj:setRequiredWork(old + taskTypeData.workAmount)
		
		local delta = taskObj:getRequiredWork() - old
		
		self:addRequiredWork(taskObj:getWorkField(), delta)
		
		totalWork = totalWork + delta
	end
	
	stage:addRequiredWork(totalWork)
	
	local team = self.team or self.lastAssignedTeam and self.owner:getTeamByUniqueID(self.lastAssignedTeam)
	local membersWithATask = 0
	
	if team then
		for key, member in ipairs(team) do
			if member:getTask() then
				membersWithATask = membersWithATask + 1
			end
		end
		
		if membersWithATask < #team:getMembers() or wasProjectDone then
			if team and not team:getProject() then
				team:setProject(self)
			elseif team and team:getProject() then
				team:reassignEmployees()
			end
		end
	end
	
	self.workExtends = self.workExtends + 1
	
	events:fire(gameProject.EVENTS.WORK_PERIOD_EXTENDED, self)
end

function gameProject:canReleaseGame()
	if self.releaseDate then
		return false
	end
	
	for key, stage in ipairs(gameProject.MANDATORY_STAGES_TO_COMPLETE) do
		for key, taskObject in ipairs(self.stages[stage].tasks) do
			if not taskObject:isWorkOnDone() then
				return false
			end
		end
	end
	
	return true
end

function gameProject:setScale(scale)
	scale = self.contractData and self.contractData:getScale() or scale
	
	engine.setScale(self, scale)
	events:fire(gameProject.EVENTS.SCALE_CHANGED, self, scale)
end

function gameProject:createConventionSelectionMenu(skipProjectSet)
	local frame = gui.create("Frame")
	
	frame:setSize(450, 600)
	frame:setFont("pix24")
	frame:setTitle(_T("EXPO_BOOKING_TITLE", "Expo Booking"))
	
	local scroller = gui.create("ScrollbarPanel", frame)
	
	scroller:setPos(_S(5), _S(33))
	scroller:setSize(frame.rawW - 10, frame.rawH - 38)
	scroller:setAdjustElementPosition(true)
	scroller:setPadding(3, 3)
	scroller:setSpacing(3)
	
	for key, conventionData in ipairs(gameConventions.availableConventions) do
		local button = gui.create("GameConventionSelectionButton", scroller)
		
		button:setSize(100, 110)
		
		if not skipProjectSet then
			button:setProject(self)
		end
		
		button:setConventionData(conventionData)
		scroller:addItem(button)
	end
	
	frame:center()
	frameController:push(frame)
end

gameProject.employeeParticipantsExplanationHoverText = {
	{
		font = "pix20",
		wrapWidth = 400,
		lineSpace = 5,
		text = _T("EMPLOYEE_EXPO_PARTICIPANTS_EXPLANATION_1", "Select employees that will present games at the expo.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		lineSpace = 5,
		textColor = game.UI_COLORS.IMPORTANT_2,
		text = _T("EMPLOYEE_EXPO_PARTICIPANTS_EXPLANATION_2", "Employees with high charisma and public speaking knowledge will be able to attract more people to the booth.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		textColor = game.UI_COLORS.IMPORTANT_1,
		text = _T("EMPLOYEE_EXPO_PARTICIPANTS_EXPLANATION_3", "Missing employees will be replaced with paid external staff, which bring no bonuses and require payment for their employment.")
	}
}
gameProject.employeeParticipantsNoBoothExplanationHoverText = {
	{
		font = "pix20",
		textColor = game.UI_COLORS.IMPORTANT_1,
		text = _T("EMPLOYEE_EXPO_PARTICIPANTS_SELECT_BOOTH", "You must first select a booth size before selecting employees that will participate in this expo.")
	}
}
gameProject.expoPresentedGamesHoverText = {
	{
		font = "pix20",
		wrapWidth = 400,
		lineSpace = 5,
		text = _T("EXPO_PRESENTED_GAMES_EXPLANATION_1", "Select games to present at the expo.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		lineSpace = 5,
		textColor = game.UI_COLORS.IMPORTANT_2,
		text = _T("EXPO_PRESENTED_GAMES_EXPLANATION_2", "The amount of people your games attract depends on the quality of your presented games.")
	},
	{
		font = "pix18",
		wrapWidth = 400,
		textColor = game.UI_COLORS.GREEN_2,
		text = _T("EXPO_PRESENTED_GAMES_EXPLANATION_3", "Presenting multiple good games can have a positive effect on the amount of people that will visit the same expo next year.")
	}
}
gameProject.expoPresentedGamesNoBoothHoverText = {
	{
		font = "pix20",
		textColor = game.UI_COLORS.IMPORTANT_1,
		text = _T("EXPO_PRESENTED_GAMES_NO_BOOTH", "You must first select a booth size before selecting games to present in this expo.")
	}
}

function gameProject:createCompletionDisplay(list, font, skipHoverText)
	local display = gui.create("GradientIconPanel", list)
	
	display:setIcon("game_scale")
	display:setFont(font)
	display:setText(string.easyformatbykeys(_T("PROJECT_COMPLETION_DISPLAY", "COMPLETION% complete"), "COMPLETION", math.round(self:getOverallCompletion() * 100)))
	
	return display
end

function gameProject:createRatingDisplay(list, font, skipHoverText)
	local display = gui.create("GradientIconPanel", list)
	
	display:setIcon("star")
	display:setFont(font)
	display:setText(_format(_T("GAME_REVIEW_RATING", "RATING/MAX average rating"), "RATING", math.round(self:getReviewRating(), 1), "MAX", review.maxRating))
	
	return display
end

function gameProject:createTotalIssueDisplay(list, font, skipHoverText)
	local display = gui.create("GradientIconPanel", list)
	
	display:setIcon("issue_p1")
	display:setFont(font)
	display:setText(string.easyformatbykeys(_T("TOTAL_PROJECT_ISSUES_DISPLAY", "ISSUES issues"), "ISSUES", self:getTotalIssueCount()))
	
	return display
end

function gameProject:createQualityPointsDisplay(list, font, skipHoverText)
	local display = gui.create("GradientIconPanel", list)
	
	display:setIcon("quality_graphics")
	display:setFont(font)
	display:setText(string.easyformatbykeys(_T("TOTAL_PROJECT_QUALITY_DISPLAY", "QUALITY total quality"), "QUALITY", string.comma(self:getTotalQuality())))
	
	return display
end

function gameProject:canStartQA()
	return not self:getFact(gameProject.QA_SESSION_START_TIME) and not self.releaseDate
end

function gameProject:finishQA()
	self:setFact(gameProject.QA_SESSION_START_TIME, nil)
	self:setFact(gameProject.QA_SESSION_END_TIME, nil)
	
	local popup = gui.create("DescboxPopup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("QA_OVER_TITLE", "QA Over"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setWidth(600)
	
	local left, right, extra = popup:getDescboxes()
	local issuesPresent = false
	
	for issueID, amount in pairs(self.discoveredQAIssues) do
		if amount > 0 then
			issuesPresent = true
			
			break
		end
	end
	
	local issuesText
	
	if issuesPresent then
		issuesText = _T("QA_OVER_ISSUES", "The Quality Assurance firm you hired to perform testing on your 'GAME' project has finished their work. Here are their findings:")
	else
		issuesText = _T("QA_OVER_NO_ISSUES", "The Quality Assurance firm you hired to perform testing on your 'GAME' project has finished their work. Throughout the entire period they have found no issues.")
	end
	
	popup:setText(_format(issuesText, "GAME", self.name))
	
	if issuesPresent then
		left:addText(_T("QA_FOUND_ISSUES", "Found issues:"), "bh24", nil, 4, 290)
		right:addText(_T("QA_TOTAL_ISSUES", "Remaining unfixed issues:"), "bh24", nil, 4, 290)
		
		local baseText = _T("ISSUE_COUNTER_QA_POPUP", "TYPE - AMOUNT")
		local issuesPresent = false
		
		for key, data in ipairs(issues.registered) do
			left:addText(_format(baseText, "TYPE", data.display, "AMOUNT", self.discoveredQAIssues[data.id] or 0), "pix20", nil, 0, 290, {
				{
					width = 24,
					icon = "generic_backdrop"
				},
				{
					width = 20,
					x = 2,
					height = 20,
					icon = data.icon
				}
			}, 24, 24)
			
			local unfixedCount = self:getDiscoveredUnfixedIssueCount(data.id) or 0
			
			right:addText(_format(baseText, "TYPE", data.display, "AMOUNT", unfixedCount), "pix20", nil, 0, 290, {
				{
					width = 24,
					icon = "generic_backdrop"
				},
				{
					width = 20,
					x = 2,
					height = 20,
					icon = data.icon
				}
			}, 24, 24)
			
			if unfixedCount > 0 then
				issuesPresent = true
			end
		end
		
		if not self.team and issuesPresent then
			local text = self.releaseDate and _T("ASSIGN_TEAM_TO_PATCH", "Assign team & make patch") or _T("ASSIGN_TEAM_TO_FIX_ISSUES", "Assign team & fix issues")
			local button = popup:addButton("pix20", text, gameProject.createPatchCallback)
			
			button.project = self
		end
	end
	
	popup:addOKButton("pix20")
	popup:center()
	frameController:push(popup)
	events:fire(gameProject.EVENTS.QA_OVER, self)
	table.clear(self.discoveredQAIssues)
	table.clear(self.currentQAIssues)
end

gameProject.foundDiscoveredIssues = {}

function gameProject:createCompletionWarningPopup()
	local completion = self:getOverallCompletion()
	
	if completion >= 1 then
		return false
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("RELEASE_UNFINISHED_GAME_TITLE", "Release Unfinished Game?"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setWidth(600)
	popup:setText(_format(_T("RELEASE_UNFINISHED_GAME_CONTENT", "'GAME' is currently COMPLETION% complete, are you sure you want to release it in its current state? Finishing a game entirely yields extra quality points."), "GAME", self.name, "COMPLETION", math.round(completion * 100)))
	
	local left, right, extra = popup:getDescboxes()
	local button = popup:addButton("pix20", _T("RELEASE_AS_IT_IS", "Release as it is"), gameProject.releaseGameCallback)
	
	button.project = self
	
	if not self.team then
		local button = popup:addButton("pix20", _T("ASSIGN_TEAM_AND_FINISH_GAME", "Assign team & finish game"), gameProject.assignTeamCallback)
		
		button.project = self
	else
		extra:addText(_format(_T("TEAM_CURRENTLY_FINISHING_GAME_PROJECT", "Team 'TEAM' is currently working on the project. Give them some time to finish the game."), "TEAM", self.team:getName()), "bh20", nil, 0, popup.rawW - 20, "question_mark", 24, 24)
	end
	
	local button = popup:addButton("pix20", _T("CANCEL", "Cancel"))
	
	popup:center()
	frameController:push(popup)
	
	return true
end

function gameProject:createPostTestIssuePopup()
	if not interactionRestrictor:canPerformAction("generic_project_interaction") then
		return false
	end
	
	local issuesPresent = false
	
	for key, data in ipairs(issues.registered) do
		local count = self:getDiscoveredUnfixedIssueCount(data.id)
		
		gameProject.foundDiscoveredIssues[data.id] = count
		
		if count > 0 then
			issuesPresent = true
		end
	end
	
	if not issuesPresent then
		return false
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("POST_TEST_ISSUE_POPUP_TITLE", "Testing Results"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setWidth(600)
	popup:setText(_format(_T("POST_TEST_ISSUE_POPUP_DESCRIPTION", "Some issues were found in 'GAME' during testing. Would you like to assign a team to it and let them fix the issues present in the game?"), "GAME", self.name))
	
	local left, right, extra = popup:getDescboxes()
	
	left:addText(_T("REMAINING_UNFIXED_ISSUES", "Remaining unfixed issues:"), "bh24", nil, 4, 590)
	
	local baseText = _T("ISSUE_COUNTER_QA_POPUP", "TYPE - AMOUNT")
	
	for key, data in ipairs(issues.registered) do
		left:addText(_format(baseText, "TYPE", data.display, "AMOUNT", gameProject.foundDiscoveredIssues[data.id] or 0), "pix20", nil, 0, 590, {
			{
				width = 24,
				icon = "generic_backdrop"
			},
			{
				width = 20,
				x = 2,
				height = 20,
				icon = data.icon
			}
		}, 24, 24)
	end
	
	if not self.team then
		local button = popup:addButton("pix20", _T("ASSIGN_TEAM_AND_FIX_ISSUES", "Assign team & fix issues"), gameProject.assignTeamCallback)
		
		button.project = self
	else
		extra:addText(_format(_T("TEAM_CURRENTLY_WORKING_ON_GAME_PROJECT", "Team 'TEAM' is currently working on the project. Give them some time to fix the bugs."), "TEAM", self.team:getName()), "bh20", nil, 0, popup.rawW - 20, "question_mark", 24, 24)
	end
	
	local button = popup:addButton("pix20", _T("DO_NOTHING", "Do nothing"))
	
	popup:center()
	frameController:push(popup)
	
	return true
end

function gameProject:createIssueWarningPopup()
	if not interactionRestrictor:canPerformAction("generic_project_interaction") then
		return false
	end
	
	local issuesPresent = false
	
	for key, data in ipairs(issues.registered) do
		local count = self:getDiscoveredUnfixedIssueCount(data.id)
		
		gameProject.foundDiscoveredIssues[data.id] = count
		
		if count > 0 then
			issuesPresent = true
		end
	end
	
	if not issuesPresent then
		return false
	end
	
	local popup = gui.create("DescboxPopup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("RELEASE_WITH_ISSUES_TITLE", "Release With Issues?"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setWidth(600)
	popup:setText(_format(_T("RELEASE_WITH_ISSUES_CONTENT", "'GAME' has unfixed issues, are you sure you want to release it that way? Unfixed issues negatively affect the review score."), "GAME", self.name))
	
	local left, right, extra = popup:getDescboxes()
	
	left:addText(_T("REMAINING_UNFIXED_ISSUES", "Remaining unfixed issues:"), "bh24", nil, 4, 590)
	
	local baseText = _T("ISSUE_COUNTER_QA_POPUP", "TYPE - AMOUNT")
	
	for key, data in ipairs(issues.registered) do
		left:addText(_format(baseText, "TYPE", data.display, "AMOUNT", gameProject.foundDiscoveredIssues[data.id] or 0), "pix20", nil, 0, 590, {
			{
				width = 24,
				icon = "generic_backdrop"
			},
			{
				width = 20,
				x = 2,
				height = 20,
				icon = data.icon
			}
		}, 24, 24)
	end
	
	local button = popup:addButton("pix20", _T("RELEASE_AS_IT_IS", "Release as it is"), gameProject.releaseGameCallback)
	
	button.project = self
	
	if not self.team then
		local button = popup:addButton("pix20", _T("ASSIGN_TEAM_AND_FIX_ISSUES", "Assign team & fix issues"), gameProject.assignTeamCallback)
		
		button.project = self
	else
		extra:addText(_format(_T("TEAM_CURRENTLY_WORKING_ON_GAME_PROJECT", "Team 'TEAM' is currently working on the project. Give them some time to fix the bugs."), "TEAM", self.team:getName()), "bh20", nil, 0, popup.rawW - 20, "question_mark", 24, 24)
	end
	
	local button = popup:addButton("pix20", _T("CANCEL", "Cancel"))
	
	popup:center()
	frameController:push(popup)
	
	return true
end

local foundIssues = {}

function gameProject:performQA()
	local discoverAttempts = math.random(gameProject.QA_DISCOVER_ATTEMPTS[1], gameProject.QA_DISCOVER_ATTEMPTS[2])
	local issuesFound = false
	local chanceDivider, minChance, maxChance = gameProject.QA_ISSUE_DISCOVER_CHANCE_DIVIDER, gameProject.QA_ISSUE_DISCOVER_MIN_CHANCE, gameProject.QA_ISSUE_DISCOVER_MAX_CHANCE
	local curIssues = self.currentQAIssues
	local totalDiscoveredIssues = self.totalDiscoveredQAIssues
	local discoveredQAIssues = self.discoveredQAIssues
	local issueTypes = issues.registered
	local stages = self.stages
	
	for key, stageID in ipairs(gameProject.MANDATORY_STAGES_TO_COMPLETE) do
		for key, task in ipairs(stages[stageID]:getTasks()) do
			if task:canHaveIssues() then
				local totalUndiscovered = 0
				
				for key, issueType in ipairs(issueTypes) do
					totalUndiscovered = totalUndiscovered + task:getUndiscoveredUnfixedIssueCount(issueType.id)
				end
				
				for i = 1, discoverAttempts do
					local discoverChance = math.clamp(totalUndiscovered / chanceDivider, minChance, maxChance)
					local result = issues:attemptDetectIssueQA(task, discoverChance)
					
					if result == nil then
						break
					elseif result then
						if not foundIssues[result] then
							curIssues[result] = 0
						end
						
						totalUndiscovered = totalUndiscovered - 1
						curIssues[result] = curIssues[result] + 1
						totalDiscoveredIssues[result] = (totalDiscoveredIssues[result] or 0) + 1
						discoveredQAIssues[result] = (discoveredQAIssues[result] or 0) + 1
						issuesFound = true
					end
					
					foundIssues[result] = true
				end
			end
		end
	end
	
	table.clear(foundIssues)
	
	if timeline.curTime >= self:getFact(gameProject.QA_SESSION_END_TIME) then
		self:finishQA()
	else
		events:fire(gameProject.EVENTS.QA_PROGRESSED, self)
	end
end

function gameProject:getFoundQAIssues()
	return self.discoveredQAIssues, self.currentQAIssues
end

function gameProject:getQASessionCount()
	return self.totalQASessions
end

function gameProject:addToFundingCosts(amount)
	self.contractorFunding = self.contractorFunding + amount
end

function gameProject:changeMoneySpent(spent)
	project.changeMoneySpent(self, spent)
	
	if not self.contractor then
		events:fire(gameProject.EVENTS.UPDATE_SALE_DISPLAY, self)
	end
end

function gameProject:getPaidEditionCost()
	return self.paidEditionCost
end

function gameProject:payDesiredFeaturesCost(cost)
	self:changeMoneySpent(cost)
	
	self.paidDesiredFeaturesCost = cost
	self.paidEditionCost = self.editionPayment
	
	if self.contractor then
		self:addToFundingCosts(cost)
	else
		self.owner:deductFunds(cost, nil, "game_projects")
	end
end

function gameProject:getFundingCosts()
	return self.contractorFunding
end

function gameProject:startQA(cost)
	self:changeMoneySpent(cost)
	self:setFact(gameProject.QA_SESSION_START_TIME, timeline.curTime)
	self:setFact(gameProject.QA_SESSION_END_TIME, timeline.curTime + self:getQASessionTime())
	self:setFact(gameProject.QA_SESSIONS_FACT, (self:getFact(gameProject.QA_SESSIONS_FACT) or 0) + 1)
	
	self.totalQASessions = self.totalQASessions + 1
	
	self.owner:setFact(self.owner.TOTAL_QA_SESSIONS, (self.owner:getFact(self.owner.TOTAL_QA_SESSIONS) or 0) + 1)
	
	if self.contractor then
		self.contractorFunding = self.contractorFunding + cost
	elseif self.publisher then
		self.contractorFunding = self.contractorFunding + cost
	else
		self.owner:deductFunds(cost, nil, "game_projects")
	end
	
	self:createQADisplay()
end

function gameProject:getQACost(duration)
	local baseCost = gameProject.QA_BASE_COST + gameProject.QA_COST_PER_DAY * duration
	
	return math.round((baseCost + baseCost * gameProject.QA_COST_SCALE_MULTIPLIER * (self.scale - 1)) / gameProject.QA_COST_ROUNDING_SEGMENT) * gameProject.QA_COST_ROUNDING_SEGMENT
end

function gameProject:getQAProgress()
	local startTime = self:getFact(gameProject.QA_SESSION_START_TIME)
	
	if not startTime then
		return nil
	end
	
	local time = timeline.curTime
	
	return (time - startTime) / (self:getFact(gameProject.QA_SESSION_END_TIME) - startTime)
end

function gameProject:getQASessionTime()
	return gameProject.BASE_QA_TIME + self.scale * gameProject.SCALE_TO_EXTRA_QA_TIME
end

function gameProject:createQAConfirmationPopup()
	local popup = gui.create("DescboxPopup")
	
	popup:setFont(fonts.get("pix24"))
	popup:setTitle(_T("QUALITY_ASSURANCE_TITLE", "Quality Assurance"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setWidth(600)
	
	local duration = self:getQASessionTime()
	local cost = self:getQACost(duration)
	local costText = string.comma(cost)
	
	popup:setText(string.easyformatbykeys(_T("QA_CONFIRMATION_DESCRIPTION", "QA (Quality Assurance) is the process of extensive testing of a product in order to find issues within the product for the developer to fix.\n\nThe session will last TIME and will cost you $MONEY. The team in charge of testing will attempt to find issues every day and you will get a report on how many issues were found each day.\n\nWould you like to pay the fee and continue?"), "TIME", timeline:getTimePeriodText(duration), "MONEY", costText))
	
	local left, right, extra = popup:getDescboxes()
	local text
	
	if self.contractor then
		text = _T("CONFIRM_QA_NO_CHARGE", "Start the QA session")
		
		extra:addSpaceToNextText(10)
		extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, _S(20), "weak_gradient_horizontal")
		extra:addText(_T("QA_CONTRACTOR_PAYS", "QA costs covered by the contractor"), "bh20", nil, 0, popup.rawW - 20, "exclamation_point", 22, 22)
	else
		text = _format(_T("CONFIRM_QA", "Pay $MONEY and start the QA session"), "MONEY", costText)
	end
	
	extra:addSpaceToNextText(5)
	extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, _S(20), "weak_gradient_horizontal")
	extra:addText(_format(_T("TOTAL_QA_SESSIONS_TEXT", "Total QA sessions held for this project: COUNT"), "COUNT", self.totalQASessions), "bh20", nil, 0, popup.rawW - 20, "question_mark", 22, 22)
	
	local confirmButton = popup:addButton(fonts.get("pix20"), text, gameProject.attemptConfirmQACallback)
	
	confirmButton.project = self
	confirmButton.cost = cost
	
	popup:addButton(fonts.get("pix20"), _T("GO_BACK", "Go back"))
	popup:center()
	frameController:push(popup)
end

function gameProject:getTotalIssueCount()
	local unfixed = 0
	
	for index, stage in ipairs(self.stages) do
		for key, task in ipairs(stage:getTasks()) do
			for key, issueData in ipairs(issues.registered) do
				unfixed = unfixed + task:getDiscoveredUnfixedIssueCount(issueData.id)
			end
		end
	end
	
	return unfixed
end

local unfixedIssues, undiscoveredIssues = {}, {}

function gameProject:getIssueCount(issueType)
	if issueType then
		return self:getDiscoveredUnfixedIssueCount(issueType), self:getUndiscoveredUnfixedIssueCount(issueType)
	end
	
	for key, issueData in ipairs(issues.registered) do
		unfixedIssues[issueData.id] = self:getDiscoveredUnfixedIssueCount(issueData.id)
		undiscoveredIssues[issueData.id] = self:getUndiscoveredUnfixedIssueCount(issueData.id)
	end
	
	return unfixedIssues, undiscoveredIssues
end

function gameProject:onCreateIssue(issueType)
	self.totalIssues[issueType] = self.totalIssues[issueType] + 1
end

function gameProject:onDiscoverIssue(issueType, taskObject)
	project.onDiscoverIssue(self, issueType, taskObject)
	
	self.discoveredIssues[issueType] = self.discoveredIssues[issueType] + 1
	
	if self.team and self.stage == gameProject.POLISHING_STAGE then
		self.queuedBugFixAssignment = true
		
		if not self.tasksWithIssuesMap[taskObject] then
			self.tasksWithIssues[#self.tasksWithIssues + 1] = taskObject
			self.tasksWithIssuesMap[taskObject] = true
		end
	end
	
	events:fire(gameProject.EVENTS.ISSUE_DISCOVERED, self, issueType)
end

function gameProject:onFixIssue(issueType, taskObject)
	project.onFixIssue(self, issueType, taskObject)
	
	self.fixedIssues[issueType] = self.fixedIssues[issueType] + 1
	
	if self.currentPatchID then
		self.patches[self.currentPatchID]:onFixIssue(issueType)
	end
	
	events:fire(gameProject.EVENTS.ISSUE_FIXED, self, issueType)
end

function gameProject:getDiscoveredUnfixedIssueCount(type)
	return self.discoveredIssues[type] - self.fixedIssues[type]
end

function gameProject:getUndiscoveredUnfixedIssueCount(type)
	return self.totalIssues[type] - self.discoveredIssues[type]
end

function gameProject:progress(dt, pt)
	project.progress(self, dt, pt)
	
	if self.queuedBugFixAssignment and self.team and self.queuedBugFixAssignment then
		for key, taskObj in ipairs(self.tasksWithIssues) do
			if not taskObj:getAssignee() and not taskObj:areAllIssuesFixed() then
				for key, employee in ipairs(self.team:getMembers()) do
					if not employee:getTask() and employee:canAssignToTask() and taskObj:canAssign(employee) then
						employee:setTask(taskObj)
						
						break
					end
				end
			end
			
			self.tasksWithIssues[key] = nil
			self.tasksWithIssuesMap[taskObj] = nil
		end
		
		self.queuedBugFixAssignment = false
	end
end

function gameProject:getCurrentPatch()
	if self.currentPatchID then
		return self.patches[self.currentPatchID]
	end
	
	return nil
end

function gameProject:beginCreatingPatch(targetTeam)
	if self.currentPatchID then
		targetTeam:setProject(self.patches[self.currentPatchID], 1, nil)
	else
		local patchObject = patchProject.new(self.owner)
		
		patchObject:setPatchedProject(self)
		targetTeam:setProject(patchObject, 1, nil)
		table.insert(self.patches, patchObject)
		
		self.currentPatchID = #self.patches
	end
end

function gameProject:canFireFinishedEvent()
	return not self.unfinishedStageIndex
end

function gameProject:finish()
	self:setStage(gameProject.POLISHING_STAGE)
	
	local unfinishedStage = self:getUnfinishedStage()
	
	self.unfinishedStageIndex = unfinishedStage
	
	project.finish(self)
	
	if unfinishedStage then
		self:setStage(unfinishedStage)
	end
end

function gameProject:regainIssueOpinion(issueMap)
	local opinionChange = 0
	
	for key, data in ipairs(issues.registered) do
		local fixes = issueMap[data.id]
		
		if fixes and fixes > 0 then
			opinionChange = opinionChange + data.opinionRegain * fixes
		end
	end
	
	self.owner:changeOpinion(opinionChange)
end

function gameProject:finishCreatingPatch()
	if not self.releaseDate then
		table.removeObject(self.patches, self.currentPatchID)
	end
	
	self:regainIssueOpinion(self.patches[self.currentPatchID]:getFixedIssues())
	
	self.currentPatchID = nil
	self.canEvaluateIssues = true
	
	if self.releaseDate then
		self:updateRealGameRating()
		
		self.issueSaleAffector = self:calculateIssueSaleAffector()
	end
end

function gameProject:cancelPatch()
	table.remove(self.patches, self.currentPatchID)
	
	self.currentPatchID = nil
end

function gameProject:canCreatePatch()
	return not self:getFact(gameProject.REMOVED_FROM_EVENT_RECEIVING) and self.stages[2]:hasAtLeastOneDiscoveredIssue()
end

function gameProject:getMergedRating()
	return (self.rating + self.realRating) * 0.5
end

gameProject.validEmployees = {}

function gameProject:verifyPricingDialogue()
	if self.contractor then
		return false
	end
	
	if not self:getFact(gameProject.PRICING_MANAGER_DIALOGUE) then
		local bestPrice = self:calculateIdealPriceForScale()
		
		if bestPrice < self.price or bestPrice > self.price then
			for key, employee in ipairs(studio:getEmployees()) do
				if employee:getRole() == "manager" and employee:isAvailable() then
					gameProject.validEmployees[#gameProject.validEmployees + 1] = employee
				end
			end
			
			if #gameProject.validEmployees > 0 then
				local manager = gameProject.validEmployees[math.random(1, #gameProject.validEmployees)]
				
				table.clearArray(gameProject.validEmployees)
				
				local id = bestPrice < self.price and "manager_game_high_price_1" or "manager_game_low_price_1"
				local dialogueObject = dialogueHandler:addDialogue(id, nil, manager)
				
				dialogueObject:setFact("game", self)
				self:setFact(gameProject.PRICING_MANAGER_DIALOGUE, true)
				
				return true
			end
		end
	end
	
	return false
end

function gameProject:verifyServerCapacityDialogue()
	if self.contractor then
		return false
	end
	
	if not self.facts[gameProject.MMO_CAPACITY_DIALOGUE] and self.owner:getServerUse() / self.owner:getRealServerCapacity() >= gameProject.MMO_CAPACITY_USE_PERCENTAGE then
		for key, employee in ipairs(studio:getEmployees()) do
			if employee:getRole() == "software_engineer" and employee:isAvailable() then
				gameProject.validEmployees[#gameProject.validEmployees + 1] = employee
			end
		end
		
		if #gameProject.validEmployees > 0 then
			local engie = gameProject.validEmployees[math.random(1, #gameProject.validEmployees)]
			
			table.clearArray(gameProject.validEmployees)
			
			local dialogueObject = dialogueHandler:addDialogue("mmo_capacity_warning_1", nil, engie)
			
			dialogueObject:setFact("game", self)
			
			self.facts[gameProject.MMO_CAPACITY_DIALOGUE] = true
			
			return true
		end
	end
	
	return false
end

function gameProject.openRentingMenuCallback()
	serverRenting:createMenu()
end

function gameProject:createServerWarning()
	if self.curDevType ~= gameProject.DEVELOPMENT_TYPE.MMO or not self.owner:isPlayer() then
		return false
	end
	
	if self.owner:getRealServerCapacity() == 0 then
		local popup = game.createPopup(500, _T("NO_SERVERS_SETUP", "No Servers Setup"), _T("NO_SERVERS_SETUP_DESCRIPTION", "You do not have any server racks in your office or any rented ones.\n\nYou are not able to release this MMO game project until you've set up at least one server rack, or rented at least one server."), "pix24", "pix20", true)
		
		popup:addButton("pix20", _T("OPEN_SERVER_MANAGEMENT", "Open server management"), gameProject.openRentingMenuCallback)
		popup:addOKButton("pix20")
		frameController:push(popup)
		
		return true
	end
	
	if self:verifyServerCapacityDialogue() then
		return true
	end
	
	return false
end

function gameProject:attemptConfirmQACallback()
	if self.project:getContractData() or self.project:getOwner():hasFunds(self.cost) then
		self.project:startQA(self.cost)
	else
		game.createNotEnoughFundsPopup(self.cost, _T("NOT_ENOUGH_FUNDS_FOR_QA", "You do not have enough funds to begin QA.\n\nYou are lacking $MISSING."))
	end
end

function gameProject:advertiseCallback()
	if not self.project:wasAnnounced() then
		local popup = game.createPopup(600, _T("GAME_NOT_ANNOUNCED_TITLE", "Game Not Announced"), _format(_T("GAME_NOT_ANNOUNCED_DESCRIPTION", "You must first announce 'GAME' before advertising it."), "GAME", self.project:getName()), "pix24", "pix20")
		
		frameController:push(popup)
		
		return 
	end
	
	self.project:createProjectAdvertisementPopup()
end

function gameProject:announceCallback()
	self.project:announce()
end

function gameProject:projectInfoCallback()
	self.project:createProjectInfoPopup()
end

function gameProject:changePricePointCallback()
	self.project:createPricePointComboBox(self.tree.baseButton, 100)
end

function gameProject:releaseGameCallback()
	self.project:release()
end

function gameProject:verifyGameReleaseCallback()
	events:fire(gameProject.EVENTS.PRE_RELEASE_VERIFICATION, self.project)
	
	if self.project:verifyPricingDialogue() then
		return 
	end
	
	if self.project:createCompletionWarningPopup() then
		return 
	end
	
	if self.project:createIssueWarningPopup() then
		return 
	end
	
	if self.project:createServerWarning() then
		return 
	end
	
	self.project:release()
end

function gameProject:extendWorkPeriodCallback()
	self.project:extendWorkPeriod()
end

function gameProject:assignTeamCallback()
	self.project:createTeamAssignmentMenu(nil, _T("APPLY_TEAM_CHANGE", "Apply team change"), self.titleText)
end

function gameProject:startQACallback()
	self.project:createQAConfirmationPopup()
end

function gameProject:createPatchCallback()
	self.project:createTeamAssignmentMenu("GamePatchTeamSelectionConfirmation", _T("BEGIN_PATCH_DEVELOPMENT", "Begin patch development"))
end

function gameProject:gameConventionsCallback()
	self.project:createConventionSelectionMenu()
end

function gameProject:lookForPublisherCallback()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 500)
	frame:setFont("pix24")
	frame:setTitle(_T("SELECT_PUBLISHER_TITLE", "Select Publisher"))
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(35))
	scrollbar:setSize(390, 460)
	scrollbar:setAdjustElementSize(true)
	scrollbar:setAdjustElementPosition(true)
	
	for key, contractor in ipairs(contractWork:getContractors()) do
		local contractorSelect = gui.create("PublisherSelectionButton")
		
		contractorSelect:setProject(self.project)
		contractorSelect:setContractor(contractor)
		scrollbar:addItem(contractorSelect)
	end
	
	frame:center()
	frameController:push(frame)
end

function gameProject:scrapProjectCallback()
	local project = self.project
	
	if not self.project:canScrap() then
		local popup = gui.create("DescboxPopup")
		
		popup:setWidth(500)
		popup:setFont(fonts.get("pix24"))
		popup:setTextFont(fonts.get("pix20"))
		popup:setTitle(_T("CANNOT_SCRAP_GAME_TITLE", "Can't Scrap Game"))
		popup:setText(_T("CANNOT_SCRAP_GAME_DESC", "This game project can not be scrapped at the moment, as it is being presented at a game convention."))
		popup:addOKButton("pix20")
		popup:center()
		frameController:push(popup)
		
		return 
	end
	
	local cost = project:getPaidDesiredFeatureCost()
	local popup = gui.create("DescboxPopup")
	
	popup:setWidth(500)
	popup:setFont(fonts.get("pix24"))
	popup:setTextFont(fonts.get("pix20"))
	popup:setTitle(_T("SCRAP_PROJECT_TITLE", "Scrap Project?"))
	
	if project:wasAnnounced() then
		popup:setText(_T("WANT_TO_SCRAP_PROJECT_WARNING", "Are you sure you want to scrap this project? All progress will be lost.\n\nScrapping announced and especially heavily advertised games can negatively impact your reputation."))
	else
		popup:setText(_T("WANT_TO_SCRAP_PROJECT", "Are you sure you want to scrap this project? All progress will be lost."))
	end
	
	local wrapW = popup.rawW - 25
	
	if cost > 0 then
		local left, right, extra = popup:getDescboxes()
		
		extra:addSpaceToNextText(10)
		
		if not project:isStageDone(1) then
			extra:addTextLine(popup.w - _S(20), game.UI_COLORS.LIGHT_BLUE, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("INITIAL_PAYMENTS_PRICE_RECOUP_AVAILABLE", "You will get back the $MONEY you spent on features when setting up the project."), "MONEY", string.comma(cost)), "bh20", nil, 0, wrapW, "exclamation_point", 22, 22)
		else
			extra:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
			extra:addText(_format(_T("INITIAL_PAYMENTS_PRICE_RECOUP_UNAVAILABLE", "Getting back the $MONEY you spent on features when setting up the project is not possible, since the first stage has already been finished."), "MONEY", string.roundtobignumber(cost)), "bh18", nil, 0, wrapW, "exclamation_point_red", 22, 22)
		end
	end
	
	local convention = gameConventions:getTargetConventionForGame(project)
	
	if convention then
		local left, right, extra = popup:getDescboxes()
		
		left:addTextLine(popup.w - _S(20), game.UI_COLORS.RED, nil, "weak_gradient_horizontal")
		left:addText(_format(_T("GAME_BOOKED_FOR_PRESENTATION_SCRAP", "This game is booked for presentation at 'CONVENTION'."), "CONVENTION", convention:getName()), "bh20", nil, 0, wrapW, "exclamation_point_red", 24, 24)
	end
	
	local button = popup:addButton(fonts.get("pix20"), "Yes", engine.finishProjectScrapCallback)
	
	button.project = project
	
	popup:addButton(fonts.get("pix20"), "No")
	popup:center()
	frameController:push(popup)
end

function gameProject:renameCallback()
	self.project:createRenamingPopup()
end

function gameProject:testProjectCallback()
	local curTeam = self.project:getTeam()
	
	if not curTeam then
		self.project:createTeamAssignmentMenu("GameTestingTeamSelectionConfirm", _T("SELECT_TESTER_TEAM", "Select tester team"))
	else
		self.project:testProject(curTeam)
	end
end

function gameProject:goOffmarketCallbackDEBUG()
	self.project:onRanOutMarketTime()
end

function gameProject:returnToMarketCallbackDEBUG()
	self.project:returnToMarket()
end

eventBoxText:registerNew({
	id = "price_research_started",
	getText = function(self, data)
		return _format(_T("PRICE_RESEARCH_STARTED", "MANAGER is now researching the best price-point for 'PROJECT'"), "MANAGER", names:getFullName(data.name[1], data.name[2], data.name[3], data.name[4]), "PROJECT", data.projectName)
	end
})

function gameProject:priceResearchCallback()
	local bestManager, bestSkill = nil, -math.huge
	
	for key, manag in ipairs(self.managerList) do
		local skill = manag:getSkillLevel("management")
		
		if bestSkill < skill then
			bestManager = manag
			bestSkill = skill
		end
	end
	
	if bestManager then
		bestManager:getRoleData():beginPricingResearch(bestManager, self.project)
		game.addToEventBox("price_research_started", {
			name = {
				bestManager:getNameConfig()
			},
			projectName = self.project:getName()
		}, 1)
	end
end

function gameProject:createDemoCallback()
	self.project:createDemoTask()
end

function gameProject:testProject(teamObj)
	for key, member in ipairs(teamObj:getMembers()) do
		local memberTask = member:getTask()
		
		if not memberTask or memberTask and memberTask:canReassign(member) then
			member:setTask(self:createTestTask())
		end
	end
	
	self.desiredTeam = nil
end

function gameProject:onEmployeesReassigned(recentlyFinishedEmployees)
	if self.stage == gameProject.POLISHING_STAGE then
		local devStage = self.stages[gameProject.DEVELOPMENT_STAGE]
		
		if not devStage:areIssuesFixed() then
			local stageTasks = devStage:getTasks()
			
			for key, employee in ipairs(recentlyFinishedEmployees) do
				if not employee:getTask() and employee:canAssignToTask() then
					local taskWasFound = false
					
					for key, taskObj in ipairs(stageTasks) do
						if not taskObj:getAssignee() and not taskObj:areAllIssuesFixed() and taskObj:canAssign(employee) then
							employee:setTask(taskObj)
							
							taskWasFound = true
							
							break
						end
					end
					
					if not taskWasFound then
						employee:setTask(self:createTestTask())
					end
				end
				
				recentlyFinishedEmployees[key] = nil
			end
		else
			for key, employee in ipairs(recentlyFinishedEmployees) do
				if not employee:getTask() then
					employee:setTask(self:createTestTask())
				end
				
				recentlyFinishedEmployees[key] = nil
			end
		end
		
		return true
	end
	
	return false
end

function gameProject:createTestTask()
	local testTask = task.new("test_project_task")
	
	testTask:setProject(self)
	testTask:setStage(2)
	testTask:setTestSessions(gameProject.TESTING_SESSIONS)
	
	return testTask
end

function gameProject:changeTesters(change)
	self.testers = self.testers + change
	
	if self.testers == 0 and not self.team and not self.scrapped then
		self:createPostTestIssuePopup()
	end
end

function gameProject:markSubEvent(subEvent)
	self.performedSubEvents[subEvent.id] = true
end

function gameProject:canPerformSubEvent(id)
	return not self.performedSubEvents[id]
end

function gameProject:getPerformedSubEvents()
	return self.performedSubEvents
end

function gameProject:fillInteractionComboBox(comboBox, hideProjectInfo)
	if not hideProjectInfo then
		local option = comboBox:addOption(0, 0, 0, 24, _T("PROJECT_INFO", "Project info"), fonts.get("pix20"), gameProject.projectInfoCallback)
		
		option.project = self
	end
	
	if not self.owner:isPlayer() then
		return 
	end
	
	local genericProjectInteraction = interactionRestrictor:canPerformAction("generic_project_interaction")
	
	if not self.contractor and not self.publisher and not self.offMarket then
		local option = comboBox:addOption(0, 0, 0, 24, _T("ADVERTISE_GAME", "Advertise game..."), fonts.get("pix20"), gameProject.advertiseCallback)
		
		option.project = self
		
		if not genericProjectInteraction or not interactionRestrictor:canPerformAction("advertise_game") then
			option:setCanClick(false)
		end
		
		if not self.returnedToMarket and #gameConventions:getAvailableConventions() > 0 then
			local option = comboBox:addOption(0, 0, 0, 24, _T("GAME_CONVENTIONS", "Game conventions..."), fonts.get("pix20"), gameProject.gameConventionsCallback)
			
			option.project = self
			
			if not genericProjectInteraction or not interactionRestrictor:canPerformAction("game_conventions") then
				option:setCanClick(false)
			end
		end
	end
	
	if DEBUG_MODE then
		local opt = comboBox:addOption(0, 0, 0, 24, "return to market", fonts.get("pix20"), gameProject.returnToMarketCallbackDEBUG)
		
		opt.project = self
		
		local option = comboBox:addOption(0, 0, 0, 24, "go off market", fonts.get("pix20"), gameProject.goOffmarketCallbackDEBUG)
		
		option.project = self
	end
	
	if not self.releaseDate then
		if not self:getFact(gameProject.ANNOUNCED_FACT) and not self.contractor then
			local option = comboBox:addOption(0, 0, 0, 24, _T("ANNOUNCE_GAME", "Announce game"), fonts.get("pix20"), gameProject.announceCallback)
			
			option.project = self
			
			if not genericProjectInteraction then
				option:setCanClick(false)
			end
		end
		
		if not self.knownIdealPrice and not self.contractor then
			local managers = studio:getManagers()
			local rIdx = 1
			
			for i = 1, #managers do
				local manag = managers[rIdx]
				
				if not manag:isAvailable() then
					table.remove(managers, rIdx)
				else
					rIdx = rIdx + 1
				end
			end
			
			if #managers > 0 then
				local option = comboBox:addOption(0, 0, 0, 24, _T("OPTION_GAME_PRICE_RESEARCH", "Price research"), fonts.get("pix20"), gameProject.priceResearchCallback)
				
				option.project = self
				option.managerList = managers
				
				if not genericProjectInteraction then
					option:setCanClick(false)
				end
			end
		end
		
		if self.stages[gameProject.DEVELOPMENT_STAGE]:isWorkFinished() and self.workExtends < gameProject.MAX_WORK_PERIOD_EXTENDS and self.stage == gameProject.POLISHING_STAGE then
			local option = comboBox:addOption(0, 0, 0, 24, _T("EXTEND_WORK_PERIOD", "Extend work period"), fonts.get("pix20"), gameProject.extendWorkPeriodCallback)
			
			option.project = self
			
			if not genericProjectInteraction then
				option:setCanClick(false)
			end
		end
	end
	
	if self.releaseDate and self:canCreatePatch() and self.stages[2]:hasAtLeastOneDiscoveredIssue() and (not self.currentPatchID or self.currentPatchID and not self.patches[self.currentPatchID]:getTeam()) then
		local option = comboBox:addOption(0, 0, 0, 24, _T("CREATE_PATCH", "Create patch..."), fonts.get("pix20"), gameProject.createPatchCallback)
		
		option.project = self
		
		if not genericProjectInteraction then
			option:setCanClick(false)
		end
	end
	
	if self:canStartQA() then
		comboBox:addOption(0, 0, 0, 24, _T("BEGIN_QA", "Begin QA..."), fonts.get("pix20"), gameProject.startQACallback).project = self
	end
	
	if not self.offMarket and not self:getFact(gameProject.REMOVED_FROM_EVENT_RECEIVING) then
		comboBox:addOption(0, 0, 0, 24, _T("TEST_PROJECT", "Test project"), fonts.get("pix20"), gameProject.testProjectCallback).project = self
		
		for key, data in ipairs(advertisement.registered) do
			data:fillInteractionComboBox(comboBox, self)
		end
	end
	
	if not self.releaseDate then
		if not self.team then
			local option = comboBox:addOption(0, 0, 0, 24, _T("ASSIGN_TEAM", "Assign team"), fonts.get("pix20"), gameProject.assignTeamCallback)
			
			option.project = self
			
			if not genericProjectInteraction then
				option:setCanClick(false)
			end
		else
			local option = comboBox:addOption(0, 0, 0, 24, _T("CHANGE_TEAM", "Change team"), fonts.get("pix20"), gameProject.assignTeamCallback)
			
			option.project = self
			
			if not genericProjectInteraction then
				option:setCanClick(false)
			end
		end
		
		if not self.publisher and not self.contractor and gameProject.PUBLISHABLE_GAME_TYPES[self.curDevType] then
			local option = comboBox:addOption(0, 0, 0, 24, _T("LOOK_FOR_PUBLISHER", "Look for a publisher"), fonts.get("pix20"), gameProject.lookForPublisherCallback)
			
			option.project = self
			
			if not genericProjectInteraction or not interactionRestrictor:canPerformAction("look_for_publisher") then
				option:setCanClick(false)
			end
		end
		
		self:addDemoCreationOption(comboBox)
		
		comboBox:addOption(0, 0, 0, 24, _T("RENAME_GAME", "Change name"), fonts.get("pix20"), gameProject.renameCallback).project = self
		
		local genericInteraction = interactionRestrictor:canPerformAction("generic_game_interaction")
		
		if not self.contractor then
			local option = comboBox:addOption(0, 0, 0, 24, _T("CHANGE_PRICE", "Change price"), fonts.get("pix20"), gameProject.changePricePointCallback)
			
			option.project = self
		end
		
		if self:canReleaseGame() then
			local option = comboBox:addOption(0, 0, 0, 24, _T("RELEASE_GAME", "Release game"), fonts.get("pix20"), gameProject.verifyGameReleaseCallback)
			
			option.project = self
			
			if not genericInteraction then
				option:setCanClick(false)
			else
				self:adjustReleaseGameClickability(option)
			end
			
			option:setID(gameProject.RELEASE_GAME_BUTTON_ID)
		end
		
		if not self.contractor and self:canScrap() then
			local option = self:addScrapProjectOption(comboBox, _T("SCRAP_GAME", "Scrap game"))
			
			if not genericInteraction or not interactionRestrictor:canPerformAction("scrap_game") then
				option:setCanClick(false)
			end
		end
	end
	
	events:fire(gameProject.EVENTS.OPENED_INTERACTION_MENU, self, comboBox)
end

gameProject.PLAYER_PLATFORM_UNRELEASED_TEXT = {
	{
		icon = "exclamation_point_yellow",
		font = "bh18",
		iconWidth = 22,
		iconHeight = 22
	}
}

function gameProject:adjustReleaseGameClickability(option)
	for key, platformID in ipairs(self.platforms) do
		local obj = platformShare:getPlatformByID(platformID)
		
		if obj.PLAYER and not obj:isReleased() then
			option:setCanClick(false)
			
			gameProject.PLAYER_PLATFORM_UNRELEASED_TEXT[1].text = _format(_T("GAME_CANT_RELEASE_PLAYER_PLATFORM", "Can't release this game until your 'PLATFORM' platform is released."), "PLATFORM", obj:getName())
			
			option:setHoverText(gameProject.PLAYER_PLATFORM_UNRELEASED_TEXT)
			
			return 
		end
	end
end

function gameProject:canScrap()
	if gameConventions:isGameActivelyPresented(self) then
		return false
	end
	
	return true
end

function gameProject:increaseMomentPopularity(amount)
	self.momentPopularity = math.max(0, self.momentPopularity + amount)
end

function gameProject:setMomentPopularity(amount)
	self.momentPopularity = amount
end

function gameProject:getMomentPopularity()
	return self.momentPopularity
end

function gameProject:updatePrequelSaleAffector()
	if not self.prequelSaleAffector then
		self.prequelSaleAffector = self:calculatePrequelSaleAffector()
	end
end

function gameProject:calculateIssueSaleAffector()
	local totalAffector = 1
	local totalIssues = self.totalIssues
	local fixedIssues = self.fixedIssues
	
	for key, issueData in ipairs(issues.registered) do
		local count = totalIssues[issueData.id] - fixedIssues[issueData.id]
		
		if count > 0 then
			totalAffector = totalAffector + math.max((count * issueData.salesImpact)^issueData.salesImpactExponent, issueData.salesImpact)
		end
	end
	
	return totalAffector
end

function gameProject:calculatePrequelSaleAffector()
	if self.sequelTo then
		local prequel = self.sequelTo
		local prequelRating = prequel:getReviewRating()
		local ownRating = self.realRating
		local prevGameSaleBoostDelta = gameProject.PREVIOUS_GAME_EXTRA_SALES_RATING_CUTOFF + prequelRating
		local curPrevGameRatingDelta = (ownRating or prequelRating) - prequelRating
		local maxrating = review.maxRating
		local minrating = review.minRating
		local normalizedmax = maxrating - minrating
		local scoreAffector = (curPrevGameRatingDelta + prevGameSaleBoostDelta) / 2 / maxrating
		local finalMultiplier = math.max(1, 1 + scoreAffector)
		local timeDelta = self:getReleaseDate() - prequel:getReleaseDate()
		local timeMultiplier = 1
		
		if timeDelta < gameProject.MINIMUM_TIME_TO_SEQUEL then
			timeMultiplier = gameProject.SEQUEL_LOW_TIME_PENALTY
		else
			timeMultiplier = math.min(math.max(gameProject.MIN_SEQUEL_TIME_BONUS_MULTIPLIER, timeDelta^gameProject.TIME_DIFFERENCE_EXPONENT / gameProject.TIME_DIFFERENCE_DIVIDER), math.max(1, gameProject.MAX_SEQUEL_TIME_BONUS_MULTIPLIER - (gameProject.MAX_SEQUEL_TIME_BONUS_MULTIPLIER - 1) * (1 - ((prequelRating - minrating) / normalizedmax * 0.5 + (ownRating - minrating) / normalizedmax * 0.5))))
		end
		
		return finalMultiplier * timeMultiplier
	end
	
	return 1
end

function gameProject:canGenerateSales()
	if self.isMMO then
		return true
	end
	
	return (self.facts[gameProject.LOWEST_RATING_SALE_MULTIPLIER_DAYS_FACT] or 0) < gameProject.SALE_ATTEMPTS_UNTIL_NO_SALES or #self.activeAdvertisements > 0
end

function gameProject:isProjectTypeValid()
	if not gameProject.SEQUEL_DEV_TYPES[self.curDevType] and not self.sequelTo then
		return false
	end
	
	return true
end

function gameProject:setKnownIdealPrice(state)
	self.knownIdealPrice = state
end

function gameProject:isIdealPriceKnown()
	return self.knownIdealPrice
end

function gameProject:calculateMaxPriceScale()
	return platformShare:getMaxGameScale()
end

function gameProject:getScaleIdealPriceAffector(maxCurScale, scale)
	local priceValue = scale / (maxCurScale or platformShare:getMaxGameScale()) * gameProject.MAX_PRICE
	local finalPrice = gameProject.PRICE_POINTS[1]
	
	for key, price in ipairs(gameProject.PRICE_POINTS) do
		if price < priceValue and finalPrice < price then
			finalPrice = price
		end
	end
	
	return finalPrice
end

function gameProject:calculateIdealPriceForScale(maxCurScale, scale)
	local finalPrice = self:getScaleIdealPriceAffector(maxCurScale, scale or self.scale)
	
	return math.min(self:getMaxPriceFeatureLimiter(), finalPrice)
end

function gameProject:getScalePriceRelationAffector()
	local priceDelta = (self.price - gameProject.MIN_PRICE) / (gameProject.MAX_PRICE - gameProject.MIN_PRICE)
	local idealScale = priceDelta * self.maxPriceScale
	local distance = self.scale - idealScale - 1
	local realDistance = distance + gameProject.MAX_SCALE_OFFSET
	local scalePriceAffector = 1
	
	if distance > 0 then
		return math.min(scalePriceAffector + distance * gameProject.SALE_BOOST_PER_POSITIVE_SCALE_PRICE_RELATION, gameProject.MAX_EXTRA_SALES_FROM_SCALING)
	elseif realDistance < 0 then
		scalePriceAffector = scalePriceAffector / (1 + math.pow(-realDistance, gameProject.SALE_SCALE_DROP_EXPONENT))
		
		return math.max(scalePriceAffector, gameProject.MIN_SALE_MULTIPLIER_FROM_SCALING)
	end
	
	return 1
end

function gameProject:getScalePriceAffector()
	return math.lerp(1, gameProject.MINIMUM_SALE_MULTIPLIER_FROM_PRICE, (self.price - gameProject.MIN_PRICE) / (gameProject.MAX_PRICE - gameProject.MIN_PRICE))
end

function gameProject:calculateExpansionSaleAffector()
	self.expansionSaleAffector = 1
	
	if gameProject.CONTENT_POINTS_ON_DEV_TYPE[self.curDevType] then
		local minimumContent = self.price / gameProject.PRICE_POINTS[1] * gameProject.CONTENT_TO_PRICE_RELATION
		local delta = self.totalContentPoints - minimumContent
		
		if delta < 0 then
			self.contentPriceAffector = math.max(gameProject.CONTENT_TO_PRICE_MAXIMUM_PENALTY, 1 - math.abs(delta) * gameProject.CONTENT_DELTA_TO_PENALTY)
		else
			self.contentPriceAffector = 1
		end
		
		self.contentVarietyAffector = 1
		
		local expansionPackCount = #self.sequelTo:getExpansionPacks()
		
		if expansionPackCount > 1 then
			local totalScale = self.sequelTo:getExpansionPackScale() / expansionPackCount
			local leastContent, mostContent = math.huge, -math.huge
			local leastID, mostID
			local expansionContent = self.sequelTo:getExpansionContent()
			local devType = self.curDevType
			
			for key, contentData in ipairs(contentPoints.registered) do
				if not contentData.devType or contentData.devType[devType] then
					local amount = expansionContent[contentData.id] or 0
					
					if amount < leastContent then
						leastContent = amount
						leastID = contentData.id
					end
					
					if mostContent < amount then
						mostContent = amount
						mostID = contentData.id
					end
				end
			end
			
			local delta = mostContent - leastContent
			
			if delta > gameProject.MIN_DELTA_FOR_PENALTY then
				local scalar = leastContent / mostContent
				
				if scalar < gameProject.VARIETY_PENALTY_MIN_DELTA then
					local penalty = math.min(1, scalar / gameProject.VARIETY_PENALTY_MIN_DELTA)
					
					self.contentVarietyAffector = math.lerp(1, gameProject.MAXIMUM_VARIETY_PENALTY, penalty)
				end
			end
		end
		
		self.expansionSaleAffector = self.contentPriceAffector * self.contentVarietyAffector
	end
end

function gameProject:getExpansionSaleAffector()
	return self.expansionSaleAffector
end

function gameProject:calculateExpansionSaleDivider()
	if self.sequelTo and not self:isNewGame() then
		if self.sequelTo.isMMO then
			self.expansionSaleDivider = 1
		else
			local delta = timeline:getTime() - self.sequelTo:getReleaseDate() - gameProject.EXPANSION_SALE_DROP_OFF_TIME_PERIOD
			
			if delta > 0 then
				self.expansionSaleDivider = math.min(gameProject.MAX_EXPANSION_SALE_DROP_OFF, (1 + delta / gameProject.EXPANSION_SALE_DROP_OFF_TIME_SPEED)^gameProject.EXPANSION_SALE_DROP_OFF_EXPONENT)
			else
				self.expansionSaleDivider = 1
			end
		end
	else
		self.expansionSaleDivider = 1
	end
end

function gameProject:getExpansionSaleDivider()
	return self.expansionSaleDivider
end

function gameProject:getContentPriceAffector()
	return self.contentPriceAffector
end

function gameProject:getContentVarietyAffector()
	return self.contentVarietyAffector
end

function gameProject:getScorePopularityAffector()
	local total = self:getAverageRating()
	local index = 1
	
	for key, data in ipairs(gameProject.POPULARITY_SCORE_AFFECTOR) do
		if total >= data.minScore and total <= data.maxScore then
			index = key
		end
	end
	
	local data = gameProject.POPULARITY_SCORE_AFFECTOR[index]
	
	return math.lerp(data.start, data.finish, (total - data.minScore) / (data.maxScore - data.minScore))
end

function gameProject:setRealReviewStandard(standard)
	self.realReviewStandard = standard
end

function gameProject:getRealReviewStandard()
	return self.realReviewStandard
end

function gameProject:updateTrendContribution()
	self.trendContribution = trends:getContribution(self)
	
	events:fire(gameProject.EVENTS.TREND_CONTRIBUTION_UPDATED, self)
end

function gameProject:getTrendContribution()
	return self.trendContribution
end

function gameProject:generateSales()
	if not self.realReviewStandard then
		review:setupRealReviewStandard(self)
	end
	
	local gametypeSaleAffector, timeSaleAff = 1, 1
	local callback = gameProject.GAME_TYPE_SALE_AFFECTOR[self.curDevType]
	
	if callback then
		gametypeSaleAffector, timeSaleAff = callback(self)
	end
	
	local time = timeline.curTime
	
	if self.saleTimestamp then
		self.timeSaleAffector = self.timeSaleAffector + (time - self.saleTimestamp) * gameProject.TIME_SALE_AFFECTOR_MULTIPLIER * timeSaleAff * gameProject.TIME_SALE_AFFECTOR_CHANGE_MULTIPLIER
	end
	
	self.saleTimestamp = time
	
	local scale = self.scale
	local platCount = #self.platforms
	local popularity = self:getPopularity() / self:getTimeSaleMultReduction(21) / platCount
	local hype = self.momentPopularity / (gameProject.PLATFORM_HYPE_BASE_DIVIDER + (platCount - 1) * gameProject.PLATFORM_HYPE_DIVIDER)
	local rep = self.owner:getReputation()
	local trendMultiplier = self.trendContribution
	local audienceMatching = audience:getGenreMatching(self)
	local scalePriceAffector = self.scalePriceAffector
	local basePossibleSaleAmount = game.BASE_SALE_AMOUNT
	local prequelAffector = self.prequelSaleAffector
	local totalSales = 0
	local realMoneyMade = 0
	local moneyMade = self.moneyMade
	local isPlayer = self.owner:isPlayer()
	local avgRatingScalar, avgRating
	
	if isPlayer then
		avgRating = (self.realRating + self.rating) / 2
		avgRatingScalar = avgRating / review.maxRating
	else
		avgRating = self.realRating
		avgRatingScalar = avgRating / review.maxRating
	end
	
	local scoreMultiplier, baseMult, dayAffector = self:getSaleMultiplierFromScore(popularity, avgRating)
	local relatedGameSales = math.huge
	local isExpansionPack = not self:isNewGame()
	local themeSaleAffector = self.genreMatchBase * hype * gameProject.THEME_SALE_AFFECTOR_MULTIPLIER / self.repetitivenessSaleAffector
	local baseGameSales
	
	if isExpansionPack then
		baseGameSales = self.sequelTo:getSalesByPlatform()
	end
	
	local popularityAffector = self.scorePopAffector
	local expansionAffector = self.expansionSaleAffector
	local possibleSaleAffector = 1 - gameProject.MAX_SALES_PER_PLATFORM * avgRatingScalar
	local priceSaleAffector = self.priceSaleAffector
	local hasIAPs = self:hasFeature("in_app_purchases")
	local staticPurchasingPowerLoss = gameProject.STATIC_PURCHASING_POWER_LOSS
	local dynamicPurchasingPowerLoss = gameProject.DYNAMIC_PURCHASING_POWER_LOSS
	local purchasingPowerLossPerSale = platformShare.PURCHASING_POWER_LOSS_PER_SALE
	local maxPrice = gameProject.MAX_PRICE
	local hypeToExtraSales = gameProject.HYPE_TO_EXTRA_SALES
	local overallSaleMult = gameProject.OVERALL_SALE_MULTIPLIER
	local extraReputationPopularitySales = gameProject.EXTRA_REPUTATION_POPULARITY_SALES
	local popularityToExtraSales = gameProject.POPULARITY_TO_EXTRA_SALES
	local maxOfPlatformUsersToSale = gameProject.MAX_OF_PLATFORM_USERS_TO_SALE
	local timeSaleMultReduction = self:getTimeSaleMultReduction(7)
	local repSaleAffector = rep * gameProject.REPUTATION_SALE_MULTIPLIER
	local issueSaleAffector = self.issueSaleAffector
	local piracy = self:calculatePiracyValue()
	local generalMultiplier = scoreMultiplier / timeSaleMultReduction * prequelAffector * trendMultiplier * audienceMatching * scalePriceAffector * priceSaleAffector * expansionAffector * overallSaleMult * gametypeSaleAffector / self.repetitivenessSaleAffector / self.expansionSaleDivider * self.featureCountSaleAffector * SALE_MULTIPLIER
	local baseSaleCount = basePossibleSaleAmount + themeSaleAffector + (repSaleAffector + hype + popularity + math.min(hype * popularityToExtraSales + popularity * hypeToExtraSales, rep) * extraReputationPopularitySales) * popularityAffector * self.editionSaleBoost
	local canPirate = self.timeUntilPiracy <= 0 and self.canPirate
	local edits, editSalePerc = self.editions, self.editionSaleMult
	local editCount = #edits
	local salesByPlat = self.salesByPlatform
	
	for key, platformID in ipairs(self.platforms) do
		local platformObject = platformShare:getOnMarketPlatformByID(platformID)
		
		if platformObject then
			local platformMatch = platformObject:getGenreMatch()[self.genre]
			local platformOwners = platformObject:getMarketShare()
			local purchasePower = math.max(0, platformObject:getPurchasingPower() / platformOwners)
			local realPlatformOwnersValue
			local currentPlatformSales = salesByPlat[platformID] or 0
			
			if isExpansionPack then
				realPlatformOwnersValue = math.min(baseGameSales[platformID] or 0, platformOwners)
			else
				realPlatformOwnersValue = platformOwners
			end
			
			local shareDelta = realPlatformOwnersValue - currentPlatformSales
			local possibleSales = math.max(0, math.min(math.round(baseSaleCount * (hasIAPs and platformObject:getFrustrationSaleAffector(self) or 1) * generalMultiplier * platformObject:getMarketSaturationSaleAffector(self) * purchasePower * platformMatch / issueSaleAffector), shareDelta, realPlatformOwnersValue * maxOfPlatformUsersToSale))
			
			if canPirate and platformObject:canPirateGames() then
				local piratedCopies = math.floor(possibleSales * piracy)
				
				possibleSales = possibleSales - piratedCopies
				self.piratedCopies = self.piratedCopies + piratedCopies
			end
			
			if not isExpansionPack then
				possibleSales = math.round(possibleSales - possibleSales * (currentPlatformSales * possibleSaleAffector / shareDelta))
			end
			
			if possibleSales > 0 then
				local actualSales = possibleSales
				
				if actualSales > 0 then
					local remEditSales = actualSales
					
					totalSales = totalSales + actualSales
					self.highestSales = math.max(self.highestSales, actualSales)
					
					local platformMoney = 0
					local realSalePrice = 0
					
					for i = 1, editCount do
						local editSales = math.ceil(math.max(0, actualSales * editSalePerc[i]))
						
						remEditSales = remEditSales - editSales
						
						local edition = edits[i]
						
						realSalePrice = realSalePrice + edition:modulatePrice(editSales)
						
						edition:changeSales(editSales)
					end
					
					realSalePrice = realSalePrice / editCount
					platformMoney = platformMoney + self:trackSoldCopies(platformObject, actualSales, true, realSalePrice)
					realMoneyMade = realMoneyMade + platformMoney
					salesByPlat[platformID] = (salesByPlat[platformID] or 0) + actualSales
					
					platformObject:changePurchasingPower(-actualSales * (staticPurchasingPowerLoss + dynamicPurchasingPowerLoss * purchasingPowerLossPerSale * (platformMoney / actualSales / maxPrice)))
					
					if isPlayer then
						platformObject:changeMoneyMade(platformMoney)
					end
				end
			end
		end
	end
	
	self.momentPopularity = math.floor(self.momentPopularity / (self:getTimeSaleMultReduction(14) * review.maxRating / avgRating))
	
	self:sellCopies(realMoneyMade, self.moneyMade - moneyMade, totalSales)
	
	self.totalSales = self.totalSales + totalSales
	self.totalSalesThisMonth = self.totalSalesThisMonth + totalSales
	self.lastSales = totalSales
	self.lastMoneyMade = self.moneyMade - moneyMade
	self.totalRealMoneyMade = self.totalRealMoneyMade + realMoneyMade
	self.realMoneyMade = realMoneyMade
	self.salesByWeek[#self.salesByWeek + 1] = totalSales
	
	if not self.saleStamp then
		self.saleStamp = totalSales
	end
	
	if isPlayer then
		if canPirate then
			if self.piratedCopies / self.totalSales >= gameProject.PIRACY.dialogueThreshold and not studio:getFact(gameProject.PIRACY.dialogueFact) then
				self:attemptPiracyDialogue()
				studio:setFact(gameProject.PIRACY.dialogueFact, true)
			end
		else
			local prevTime = self.timeUntilPiracy
			
			if prevTime <= 0 and self.timeUntilPiracy > 0 then
				self.piracyStarted = timeline.curTime
			end
			
			self.timeUntilPiracy = self.timeUntilPiracy - 1
		end
		
		if not self:getFact(gameProject.SOLD_GAME_COPIES_FACT) then
			self:setFact(gameProject.SOLD_GAME_COPIES_FACT, true)
			sound:play("sold_game_copies", nil, nil, nil)
		end
		
		if not self.facts[gameProject.TALKED_ABOUT_OUTSELLING_DEV_COSTS_FACT] and self.totalRealMoneyMade > self.moneySpent * gameProject.OUTSOLD_DEV_COSTS_AMOUNT and not conversations:canTalkAboutTopic(gameProject.OUTSOLD_DEV_COSTS_TOPIC) then
			conversations:addTopicToTalkAbout(gameProject.OUTSOLD_DEV_COSTS_TOPIC, self.uniqueID)
		end
	end
	
	local perc
	
	if self.returnedToMarket then
		perc = gameProject.PERCENTAGE_OF_INITIAL_SALES_ON_MARKET_RETURN
	else
		perc = gameProject.PERCENTAGE_OF_INITIAL_SALES_ON_MARKET
	end
	
	if perc >= totalSales / self.saleStamp or totalSales <= gameProject.MIN_SALES_OFFMARKET_INCREASE then
		local fact = gameProject.LOWEST_RATING_SALE_MULTIPLIER_DAYS_FACT
		
		self:setFact(fact, (self:getFact(fact) or 0) + 1)
		
		if not self:canGenerateSales() then
			self:onRanOutMarketTime()
		end
	else
		self:setFact(gameProject.LOWEST_RATING_SALE_MULTIPLIER_DAYS_FACT, 0)
	end
	
	if not self.offMarket then
		events:fire(gameProject.EVENTS.COPIES_SOLD, self, totalSales)
	end
	
	return totalSales
end

function gameProject:attemptPiracyDialogue()
	local own = self.owner
	
	if own:getEmployeeCountByRole("manager") > 0 then
		for key, dev in ipairs(own:getEmployees()) do
			if dev:getRole() == "manager" then
				local dialogueObj = dialogueHandler:addDialogue("piracy_explanation_1", nil, dev)
				
				dialogueObj:setFact("game", self)
				
				break
			end
		end
	end
end

function gameProject:getSalesByPlatform()
	return self.salesByPlatform
end

function gameProject:addShareMoney(money)
	self.shareMoney = self.shareMoney + money
	self.lastShareMoney = money
end

function gameProject:getShareMoney()
	return self.shareMoney, self.lastShareMoney
end

function gameProject:getLastSales()
	return self.lastSales, self.lastMoneyMade
end

function gameProject:getThemeGenreText()
	local text = _T("THEME_GENRE_TEXT", "THEME_ GENRE_SUFFIX_")
	local genreData = genres.registeredByID[self.genre]
	
	return string.easyformatbykeys(text, "THEME_", themes.registeredByID[self.theme].display, "GENRE_", genreData.display, "SUFFIX_", genreData.noSuffix and "" or " " .. _T("GAME", "Game"))
end

function gameProject:getStatusText()
	local statusText = ""
	local relDate = self.releaseDate
	
	if relDate then
		statusText = string.easyformatbykeys(_T("RELEASE_DATE_TEMPLATE", "Released on YEAR/MONTH/DAY"), "YEAR", timeline:getYear(relDate), "MONTH", timeline:getMonth(relDate), "DAY", timeline:getDay(relDate))
	elseif self:getFact(gameProject.ANNOUNCED_FACT) then
		statusText = _T("ANNOUNCED_NOT_RELEASED_YET", "Announced, not released yet")
	else
		statusText = _T("UNANNOUNCED", "Unannounced")
	end
	
	local massAdvert = advertisement:getData("mass_advertisement")
	
	if self:getFact(massAdvert.dataFact) then
		statusText = table.concatEasy(", ", statusText, _T("MASS_ADVERT_IN_PROGRESS", "mass advert in progress"))
	end
	
	return statusText
end

function gameProject:isPlatformSelected(id)
	return table.find(self.platforms, id)
end

function gameProject:setupCutsPerSale()
	self.cutsPerSale = {}
	
	for key, platformID in ipairs(self.platforms) do
		local platformObj = platformShare:getOnMarketPlatformByID(platformID)
		
		if platformObj then
			if platformObj.PLAYER then
				self.cutsPerSale[platformID] = 1 * gameProject.SALE_POST_TAX_PERCENTAGE
			else
				self.cutsPerSale[platformID] = (1 - platformObj:getCutPerSale(self)) * gameProject.SALE_POST_TAX_PERCENTAGE
			end
		end
	end
end

function gameProject:getSaleRevenue(sales, platformObject, priceMult, price)
	local mult = platformObject and self.cutsPerSale[platformObject:getID()] or gameProject.SALE_POST_TAX_PERCENTAGE
	local final = sales * mult
	
	if priceMult then
		final = final * price
	end
	
	return math.round(final)
end

function gameProject:increaseRealMoneyMade(real)
	self.totalRealMoneyMade = self.totalRealMoneyMade + real
end

function gameProject:getMoneyMade(platform)
	return platform and (self.moneyMadeByPlatform[platform] or 0) or self.moneyMade
end

function gameProject:checkFeatureRequirement(featureData, missingRequirements)
	if not self:isNewGame() then
		local change = self.sequelTo:checkFeatureRequirement(featureData, missingRequirements)
		
		if change == 0 then
			return change
		end
	end
	
	return complexProject.checkFeatureRequirement(self, featureData, missingRequirements)
end

function gameProject:changeMoneyMade(change)
	self.moneyMade = self.moneyMade + change
end

function gameProject:trackSoldCopies(platformObject, amount, priceMult, price)
	local moneyMade = self:getSaleRevenue(amount, platformObject, priceMult, price)
	
	self.moneyMade = self.moneyMade + moneyMade
	
	if platformObject then
		self.moneyMadeByPlatform[platformObject:getID()] = (self.moneyMadeByPlatform[platformObject:getID()] or 0) + moneyMade
	end
	
	if self.contractor then
		moneyMade = self.contractor:getShareFromMoney(moneyMade, self.contractData)
	end
	
	return moneyMade
end

function gameProject:sellCopies(ourMoney, totalMoney, saleAmount)
	if self.contractor then
		self.contractor:addSaleMoney(totalMoney, saleAmount, self)
	elseif self.publisher then
		self.publisher:addSaleMoney(totalMoney, saleAmount, self)
	else
		self.owner:addFunds(ourMoney, nil, "game_projects", not self:getFact(gameProject.SOLD_GAME_COPIES_FACT))
	end
end

function gameProject:getSales(platform)
	return platform and (self.salesByPlatform[platform] or 0) or self.totalSales
end

function gameProject:setScore(score)
	self.score = score
end

function gameProject:getScore()
	return self.score
end

function gameProject:postSetDesiredFeature(taskType, state)
	local category = taskTypes.registeredByID[taskType].category
	
	if category then
		if state then
			self.selectedTasksByCategory[category] = (self.selectedTasksByCategory[category] or 0) + 1
		else
			self.selectedTasksByCategory[category] = self.selectedTasksByCategory[category] - 1
		end
	end
	
	if not self._minimalEffort then
		self:verifyPerspectiveState()
	end
end

function gameProject:getSelectedTasksByCategory()
	return self.selectedTasksByCategory
end

function gameProject:verifyPerspectiveState()
	local found = false
	
	for key, taskTypeData in ipairs(taskTypes:getTasksByCategory(gameProject.PERSPECTIVE_CATEGORY)) do
		if self.desiredFeatures[taskTypeData.id] then
			found = true
		end
	end
	
	self.perspectiveSelected = found or self:getFact("perspective")
end

function gameProject:increaseHypeCounter()
	if not self.hypeCounter then
		self.hypeCounter = gameProject.HYPE_COUNTER_INCREASE
		
		return true
	else
		local old = self.hypeCounter
		
		self.hypeCounter = math.min(gameProject.MAX_HYPE_COUNTERS, self.hypeCounter + gameProject.HYPE_COUNTER_INCREASE)
		
		return old < gameProject.MAX_HYPE_COUNTERS
	end
	
	return false
end

function gameProject:getHypeCounter()
	return self.hypeCounter
end

function gameProject:hasAtLeastOneDesiredFeature()
	local feats = taskTypes.registeredByID
	
	for featureID, state in pairs(self.desiredFeatures) do
		if state then
			local data = feats[featureID]
			
			if not data.doesNotCountAsFeature then
				return true
			end
		end
	end
	
	return false
end

function gameProject:clearDesiredFeatures()
	complexProject.clearDesiredFeatures(self)
	
	self.selectedContent = 0
	
	table.clearArray(self.invalidTasks)
end

function gameProject:getMissingSelectionTextTable()
	local missingStuff = engine.getMissingSelectionTextTable(self)
	
	if not self:getEngine() then
		table.insert(missingStuff, _T("NO_ENGINE_SELECTED", "No engine selected."))
	end
	
	if not self.perspectiveSelected then
		table.insert(missingStuff, _T("NO_PERSPECTIVE_SELECTED", "No perspective selected."))
	end
	
	if gameProject.CONTENT_POINTS_ON_DEV_TYPE[self.curDevType] and self.selectedContent == 0 then
		table.insert(missingStuff, _T("NO_CONTENT_SELECTED", "No new content selected."))
	end
	
	if self.curDevType and not self:isProjectTypeValid() then
		table.insert(missingStuff, _T("NO_RELATED_GAME_SELECTED", "The current game type requires you to select a related game."))
	end
	
	if not self:hasPlatforms() then
		table.insert(missingStuff, _T("NO_PLATFORM_SELECTED", "No platform selected."))
	end
	
	if self.curDevType == gameProject.DEVELOPMENT_TYPE.MMO and not self:arePlatformsValid() then
		table.insert(missingStuff, _T("MORE_THAN_2_PLATFORMS_SELECTED", "More than 2 platforms selected."))
	end
	
	if not self:getPrice() then
		table.insert(missingStuff, _T("NO_PRICE_SELECTED", "No price selected."))
	end
	
	if not self:getGenre() then
		table.insert(missingStuff, _T("NO_GENRE_SELECTED", "No genre selected."))
	end
	
	if not self:getTheme() then
		table.insert(missingStuff, _T("NO_THEME_SELECTED", "No theme selected."))
	end
	
	if not self:getAudience() then
		table.insert(missingStuff, _T("NO_AUDIENCE_SELECTED", "No audience selected."))
	end
	
	if not self:hasEnoughFunds() then
		table.insert(missingStuff, _T("NOT_ENOUGH_FUNDS_PROJECT", "Not enough funds."))
	end
	
	if not gameProject.CONTENT_POINTS_ON_DEV_TYPE[self.curDevType] and not self:hasSelectedTaskInCategories() then
		table.insert(missingStuff, _T("MUST_SELECT_AT_LEAST_1_TASK_IN_CATEGORIES", "Must select at least 1 task in each category."))
	end
	
	for featureID, state in pairs(self.desiredFeatures) do
		taskTypes.registeredByID[featureID]:getInvalidityText(self, missingStuff)
	end
	
	return missingStuff
end

function gameProject:setPublisher(publisher)
	self.publisher = publisher
	
	if not self.contractorFunding then
		self.contractorFunding = 0
	end
	
	events:fire(gameProject.EVENTS.PUBLISHER_SET, self)
end

function gameProject:getPublisher()
	return self.publisher
end

function gameProject:setRating(rating)
	self.realRating = rating
	
	self:updateScorePopularityAffector()
end

function gameProject:getRealRating()
	return self.realRating
end

function gameProject:getSaleMultiplierFromScore(popularity, rating)
	if not self.rating then
		return 1
	end
	
	baseMult = rating^gameProject.RATING_SALE_MULTIPLIER_EXPONENT
	
	local dayAffector = 1 + math.max(self.timeSaleAffector - gameProject.FULL_SALE_POWER_TIME, 0)^gameProject.RATING_SALE_TIME_REDUCTION_EXPONENT * gameProject.RATING_SALE_TIME_REDUCTION_MULTIPLIER
	
	baseMult = math.max(1, math.min(gameProject.MAX_SCORE_SALE_MULTIPLIER, baseMult * gameProject.SCORE_SALE_MULTIPLIER, 1 + popularity / gameProject.QUALITY_SALE_MULT_INTEREST_REQUIREMENT))
	
	return math.max(baseMult / dayAffector, gameProject.MINIMUM_RATING_SALE_MULTIPLIER), baseMult, dayAffector
end

function gameProject:getDaysSinceRelease()
	return math.ceil(timeline.curTime - self.releaseDate)
end

function gameProject:getTimeSaleMultReduction(divider)
	divider = divider or 3
	
	return 1 + self.timeSaleAffector / divider
end

eventBoxText:registerNew({
	id = "game_ready_for_release",
	getText = function(self, data)
		return _format(_T("GAME_FINISHED_CAN_RELEASE", "'GAME' is now finished and can be released!"), "GAME", data)
	end
})

function gameProject:onFinish()
	project.onFinish(self)
	
	if not self.unfinishedStageIndex then
		self:unassignTeam()
		
		if self.owner:isPlayer() then
			local element = game.addToEventBox("game_ready_for_release", self:getName(), 1, nil, "exclamation_point")
			
			if preferences:get("stop_time_on_game_finish") then
				element:setFlash(true, true)
			end
			
			events:fire(gameProject.EVENTS.INITIAL_FINISH, self)
		end
	end
end

function gameProject:addFeature(feature)
	self.features[feature] = true
	
	self:removePreviousOptionCategoryTask(feature)
end

function gameProject:getDevelopmentSpeedMultiplier()
	return self.developmentSpeedMultiplier
end

gameProject.skillMap = {}

function gameProject:inheritSetup(otherGame)
	self._minimalEffort = true
	
	local featuresByID = taskTypes.registeredByID
	
	for feat, state in pairs(self.features) do
		featuresByID[feat]:setDesiredFeature(self, false)
	end
	
	for i = 1, #self.platforms do
		self:setPlatformState(self.platforms[1], false)
	end
	
	local rIdx = 1
	
	for i = 1, #self.editions do
		local edit = self.editions[rIdx]
		
		if edit:getDeletable() then
			table.remove(self.editions, rIdx)
		else
			rIdx = rIdx + 1
		end
	end
	
	self:setGenre(otherGame:getGenre())
	
	local subGenre = otherGame:getSubgenre()
	
	if subGenre then
		self:setSubgenre(subGenre)
	end
	
	self:setTheme(otherGame:getTheme())
	self:setAudience(otherGame:getAudience())
	self:setEngine(nil, otherGame:getEngine())
	self:setScale(otherGame:getScale())
	self:setPrice(otherGame:getPrice())
	self:setGameType(otherGame:getGameType())
	
	local featureMap = otherGame:getFeatures()
	local teamList = studio:getTeams()
	local teamCount = #teamList
	local skillMap = gameProject.skillMap
	local skillList = skills.registered
	local skillCount = #skillList
	local bestTeam
	
	for id, priority in pairs(otherGame:getCategoryPriorities()) do
		self:setCategoryPriority(id, priority)
	end
	
	if teamCount > 1 then
		for key, data in ipairs(skillList) do
			skillMap[data.id] = -math.huge
		end
		
		for feat, state in pairs(featureMap) do
			local data = featuresByID[feat]
			
			if not data.invisible and data.workField and data.minimumLevel then
				skillMap[data.workField] = math.max(skillMap[data.workField], data.minimumLevel)
			end
		end
		
		local highestScore = -math.huge
		
		for key, obj in ipairs(teamList) do
			local completableTypes = 0
			local skillLevels = obj:getHighestSkillLevels()
			
			for key, data in ipairs(skillList) do
				if skillLevels[data.id] >= skillMap[data.id] then
					completableTypes = completableTypes + 1
				end
			end
			
			if completableTypes == skillCount then
				local theirScore = obj:getTotalHighestSkillLevel()
				
				if highestScore < theirScore then
					highestScore = theirScore
					bestTeam = obj
				end
			end
		end
	else
		bestTeam = teamList[1]
	end
	
	if bestTeam then
		self:setDesiredTeam(bestTeam)
		
		local teamSkills = bestTeam:getHighestSkillLevels()
		
		for feat, state in pairs(featureMap) do
			local data = featuresByID[feat]
			
			if not data.invisible then
				if data.minimumLevel and data.workField then
					if teamSkills[data.workField] >= data.minimumLevel then
						data:setDesiredFeature(self, true)
					end
				else
					data:setDesiredFeature(self, true)
				end
			end
		end
	end
	
	for key, edit in ipairs(otherGame:getEditions()) do
		if edit:getDeletable() then
			local edition = gameEditions:instantiate(self)
			
			edition:setPrice(edit:getPrice())
			edition:setName(edit:getName())
			
			for key, partData in ipairs(edit:getParts()) do
				edition:addPart(partData)
			end
			
			self:addEdition(edition)
		end
	end
	
	for key, platformID in ipairs(otherGame:getTargetPlatforms()) do
		local platObj = platformShare:getOnMarketPlatformByID(platformID)
		
		if platObj and not platObj:hasExpired() then
			self:setPlatformState(platformID, true)
		end
	end
	
	self._minimalEffort = false
	
	self:verifyPerspectiveState()
	self:calculateDesiredFeaturesCost()
	self:calculatePlatformWorkAmountAffector()
	events:fire(gameProject.EVENTS.INHERITED_PROJECT_SETUP, self)
end

function gameProject:setEngine(engineUID, engineObj)
	if self.engine and engineObj ~= self.engine then
		self.engineRevision = nil
	end
	
	if engineUID then
		self.engine = self.owner:getEngineByUniqueID(engineUID)
		self.engineUID = engineUID
	else
		self.engine = engineObj
		self.engineUID = engineObj:getUniqueID()
	end
	
	self.engineRevision = self.engineRevision or self.engine:getRevision()
	
	if not self.offMarket then
		self.engineRevisionFeatures = table.copyOver(self.engine:getRevisionFeatures(self.engineRevision), {})
		self.developmentSpeedMultiplier = self.engine:calculateDevelopmentSpeedMultiplier(self.engineRevisionFeatures)
		
		self:recalculateQualityPoints()
	end
	
	events:fire(gameProject.EVENTS.ENGINE_CHANGED, self)
end

function gameProject:getEngineRevisionFeatures()
	return self.engineRevisionFeatures or self.engine:getRevisionFeatures(self.engineRevision)
end

function gameProject:getEngineRevision()
	return self.engineRevision
end

function gameProject:getEngineRevisionStats()
	return self.engine:getRevisionStats(self.engineRevision)
end

function gameProject:recalculateQualityPoints()
	for statID, amount in pairs(self.qualityPoints) do
		self.qualityPoints[statID] = (self.employeeStatContribution[statID] or 0) + (self.featureStatContribution[statID] or 0)
	end
	
	for featureID, state in pairs(self.engineRevisionFeatures) do
		if state then
			local data = taskTypes:getData(featureID)
			
			if data and not data.implementation then
				local quality = data:getGameQualityPointIncrease()
				
				if quality then
					for qualityID, amount in pairs(quality) do
						self:addQualityPoint(qualityID, amount, false, true)
					end
				end
			end
		end
	end
end

function gameProject:getTotalQuality()
	local totalQuality = 0
	
	for qualityID, amount in pairs(self.qualityPoints) do
		totalQuality = totalQuality + amount
	end
	
	return totalQuality
end

function gameProject:getEngine()
	return self.engine, self.engineUID
end

function gameProject:engineHasFeature(feature)
	local allFeatures = self.engineRevisionFeatures
	
	return allFeatures[feature] ~= nil
end

function gameProject:setupPointContribution(taskID)
	if not self.qualityByTasks[taskID] then
		self.qualityByTasks[taskID] = {
			employee = {},
			feature = {}
		}
	end
end

function gameProject:getQualityByTasks()
	return self.qualityByTasks
end

function gameProject:addQualityPoint(category, amount, employeeContribution, skipAdditionToLists, taskID)
	self.qualityPoints[category] = (self.qualityPoints[category] or 0) + amount
	
	if not skipAdditionToLists then
		if employeeContribution then
			self.employeeStatContribution[category] = (self.employeeStatContribution[category] or 0) + amount
			
			if taskID then
				local list = self.qualityByTasks[taskID].employee
				
				list[category] = (list[category] or 0) + amount
			end
		else
			self.featureStatContribution[category] = (self.featureStatContribution[category] or 0) + amount
			
			if taskID then
				local list = self.qualityByTasks[taskID].feature
				
				list[category] = (list[category] or 0) + amount
			end
		end
	end
end

function gameProject:formatPopularityBonusText(amount)
	return _format(_T("POPULARITY_BONUS", "Bonus Popularity points: BONUS pts."), "BONUS", string.roundtobignumber(amount))
end

function gameProject:addKnowledgeQuality(qualityID, knowledgeID, amount)
	if amount == 0 then
		return 
	end
	
	local map = self.knowledgeStatContribution
	
	if not map[knowledgeID] then
		map[knowledgeID] = {}
	end
	
	map[knowledgeID][qualityID] = (map[knowledgeID][qualityID] or 0) + amount
	self.qualityFromKnowledge[qualityID] = (self.qualityFromKnowledge[qualityID] or 0) + amount
end

function gameProject:getKnowledgeQuality()
	return self.knowledgeStatContribution, self.qualityFromKnowledge
end

function gameProject:getEmployeeQualityContribution(category)
	return self.employeeStatContribution[category]
end

function gameProject:getFeatureQualityContribution(category)
	return self.featureStatContribution[category]
end

function gameProject:getQualityPoints()
	return self.qualityPoints
end

function gameProject:getQuality(pointCategory)
	return self.qualityPoints[pointCategory] or 0
end

function gameProject:logNewStandard(qualityID, standardLevel)
	self.newStandards = self.newStandards or {}
	self.newStandards[qualityID] = standardLevel
end

function gameProject:getNewStandards()
	return self.newStandards
end

eventBoxText:registerNew({
	id = "review_published",
	getText = function(self, data)
		return _format(_T("REVIEWER_HAS_REVIEWED_LAYOUT", "'REVIEWER' has published a review of 'GAME_PROJECT'"), "REVIEWER", data.review:getReviewer():getName(), "GAME_PROJECT", data.game:getName())
	end,
	saveData = function(self, data)
		return {
			reviewer = data.review:getReviewer():getID(),
			game = data.game:getUniqueID()
		}
	end,
	loadData = function(self, targetElement, data)
		local gameObj = studio:getGameByUniqueID(data.game)
		local review = gameObj:getReviewObject(data.reviewer)
		
		targetElement:setReview(review)
		
		return {
			review = review,
			game = gameObj
		}
	end
})

function gameProject:addReview(reviewObj, reviewer)
	table.insert(self.reviews, reviewObj)
	
	self.reviewedBy[reviewer:getID()] = true
	
	if self.owner:isPlayer() then
		local element = game.addToEventBox("review_published", {
			review = reviewObj,
			game = self
		}, 5, "EventBoxReviewElement", "project_stuff")
		
		element:setReview(reviewObj)
		element:setFlash(true)
		
		if not conversations:canTalkAboutTopic(gameProject.REVIEW_CONVERSATION_TOPIC) then
			conversations:addTopicToTalkAbout(gameProject.REVIEW_CONVERSATION_TOPIC, self.uniqueID)
		end
	end
	
	self:updateGameRating()
	
	local opiChange = self:getOpinionChange(reviewObj)
	
	self.owner:changeOpinion(opiChange)
	self:addReviewRatingReputation(reviewObj:getRating(), 1)
	self:updateTrendContribution()
	self:updateScorePopularityAffector()
	events:fire(gameProject.EVENTS.NEW_REVIEW, self, reviewObj)
end

function gameProject:getOpinionChange(reviewObj)
	local opi = gameProject.OPINION
	local gain = opi.baseGain
	local repReduct = opi.reductionRep
	local minRep = repReduct[1]
	local rep = self.owner:getReputation()
	local repModifier = 0
	
	if minRep <= rep then
		local maxRep = repReduct[2] - repReduct[1]
		
		repModifier = math.lerp(0, 1, math.min(1, (rep - minRep) / maxRep))
		gain = gain - opi.maxReduction * repModifier
	end
	
	local realRating = math.lerp(self.realRating, reviewObj:getRating(), opi.opinionReviewLerp)
	local minRating = review.minRating
	local maxGainRating = opi.maxGainRating
	local minGainRating = opi.minGainRating
	local final = gain
	local drmMult = 1
	
	if realRating <= minRating then
		final = math.round(opi.maxOpinionLoss * (1 + repModifier), opi.round)
	elseif realRating <= opi.minGainRating then
		local progress = math.lerp(0, 1, 1 - (realRating - minRating) / (minGainRating - minRating))
		
		final = math.round(opi.maxOpinionLoss * progress, opi.round)
		drmMult = math.lerp(1, opi.drmPenaltyMultiplier, progress)
	elseif realRating <= maxGainRating then
		local progress = 1 - (realRating - minGainRating) / (maxGainRating - minGainRating)
		
		final = math.round(gain * math.lerp(1, 0, progress), opi.round)
		drmMult = math.lerp(1, opi.drmPenaltyMultiplier, progress)
	end
	
	if self.drmValue > 0 then
		final = final - opi.drmPenalty * self.drmValue * drmMult
	end
	
	return final
end

function gameProject:calculateReviewRatingReputationMultiplier()
	local dist = gameProject.REVIEW_REPUTATION_GAIN_PER_SCALE_POINT * self.scale - studio:getReputation()
	
	if dist < 0 then
		local delta = math.min(1, -dist / gameProject.REVIEW_REPUTATION_CUTOFF * gameProject.REVIEW_REPUTATION_CUTOFF_PENALTY_MULTIPLIER)
		
		return math.lerp(gameProject.REVIEW_REPUTATION_MAX_REP_GAIN, gameProject.REVIEW_REPUTATION_MIN_REP_GAIN, delta)
	end
	
	return 1
end

function gameProject:addReviewRatingReputation(reviewRating, multiplier)
	local rating = (self.realRating + reviewRating) * 0.5 - gameProject.NEGATIVE_REPUTATION_CUTOFF
	local delta = rating > 0 and rating / (review.maxRating - gameProject.NEGATIVE_REPUTATION_CUTOFF) or rating / gameProject.NEGATIVE_REPUTATION_CUTOFF
	
	if delta ~= 0 then
		local change = delta + math.randomf(gameProject.REVIEW_REPUTATION_CHANGE_RANDOM[1], gameProject.REVIEW_REPUTATION_CHANGE_RANDOM[2])
		local repChange = change * gameProject.BASE_REPUTATION_PER_REVIEW
		local repMult = self.contractor and gameProject.REPUTATION_GAIN_FROM_POPULARITY_WITH_CONTRACTOR or 1
		
		self.owner:increaseReputation(math.round(repChange * repMult) * multiplier * self.reviewRatingRepMult * self.reviewRepGainScaler)
	end
end

function gameProject:getReview(reviewerID)
	return self.reviewedBy[reviewerID]
end

function gameProject:getReviewObject(reviewerID)
	for key, review in ipairs(self.reviews) do
		if review:getReviewer():getID() == reviewerID then
			return review
		end
	end
end

function gameProject:isFinished()
	if self.releaseDate then
		return true, 1
	end
	
	local completion = self:getOverallCompletion()
	
	return completion >= 1, completion
end

function gameProject:updateGameRating()
	if self.owner == studio then
		self.rating = self:calculateAverageRating()
	else
		self.rating = review:getCurrentGameVerdict(self)
	end
end

function gameProject:updateRealGameRating(wasLoad)
	local rating, score = review:getCurrentGameVerdict(self)
	
	self:setScore(score)
	self:setRating(rating)
	
	if not wasLoad then
		self.subEvents:onRatingChanged(self)
	end
end

function gameProject:getReviewRating()
	return self.rating
end

function gameProject:calculateAverageRating()
	local total = 0
	
	for key, reviewObj in ipairs(self.reviews) do
		total = total + reviewObj:getRating()
	end
	
	return math.max(0, total / #self.reviews)
end

function gameProject:calculateRealRating()
	return review:calculateRating(review:calculateScore(self, nil), self, nil)
end

function gameProject:getReviewerScore(reviewer)
	for key, reviewObj in ipairs(self.reviews) do
		if reviewObj:getReviewer() == reviewer then
			return reviewObj:getRating()
		end
	end
	
	return nil
end

function gameProject:getReviews()
	return self.reviews
end

function gameProject:hasTheme()
	return self.theme and string.withoutspaces(self.theme) ~= ""
end

function gameProject:hasGenre()
	return self.genre and string.withoutspaces(self.genre) ~= ""
end

function gameProject:hasEngine()
	return self.engine ~= nil
end

function gameProject:hasPlatforms()
	return #self.platforms > 0
end

function gameProject:arePlatformsValid()
	if self.curDevType == gameProject.DEVELOPMENT_TYPE.MMO and #self.platforms > 2 then
		return false
	end
	
	return true
end

function gameProject:hasPrice()
	return self.price ~= nil
end

function gameProject:changeSelectedContentAmount(amount)
	self.selectedContent = self.selectedContent + amount
end

function gameProject:getTaskCategoryList()
	if self.curDevType == gameProject.DEVELOPMENT_TYPE.NEW then
		return gameProject.DEVELOPMENT_CATEGORIES
	elseif self.curDevType == gameProject.DEVELOPMENT_TYPE.MMO then
		return gameProject.MMO_DEVELOPMENT_CATEGORIES
	end
	
	return gameProject.CONTENT_DEVELOPMENT_CATEGORIES
end

function gameProject:hasSelectedTaskInCategories()
	local optCats = gameProject.OPTIONAL_DEVELOPMENT_CATEGORIES
	local selectedByCat = self.selectedTasksByCategory
	
	for key, category in ipairs(self:getTaskCategoryList()) do
		if not optCats[category] and (not selectedByCat[category] or selectedByCat[category] == 0) then
			return false
		end
	end
	
	return true
end

function gameProject:canBeginWorkOn()
	local canBegin = complexProject.canBeginWorkOn(self) and self:hasTheme() and self:hasGenre() and self:hasEngine() and self:hasPlatforms() and self:arePlatformsValid() and self.price and self.curDevType and self:isProjectTypeValid() and self.perspectiveSelected and self.audience and #self.invalidTasks == 0 and self:hasName()
	
	if gameProject.CONTENT_POINTS_ON_DEV_TYPE[self.curDevType] then
		return canBegin and self.selectedContent > 0
	end
	
	if not self:hasSelectedTaskInCategories() then
		return false
	end
	
	return canBegin
end

function gameProject:hasEnoughFunds()
	if self.contractor then
		return true
	end
	
	return complexProject.hasEnoughFunds(self)
end

gameProject.ENGINE_INFO_DESCBOX_ID = "engine_info_descbox"

function gameProject:createEngineSelectionPopup()
	local frame = gui.create("Frame")
	
	frame:setSize(400, 500)
	frame:setFont("pix24")
	frame:setTitle(_T("SELECT_ENGINE_TITLE", "Select Engine"))
	
	local scrollbar = gui.create("ScrollbarPanel", frame)
	
	scrollbar:setPos(_S(5), _S(30))
	scrollbar:setSize(390, 490)
	scrollbar:setAdjustElementPosition(true)
	scrollbar:setPadding(3, 3)
	scrollbar:setSpacing(3)
	
	local elemW = 380
	local category = gui.create("Category")
	
	category:setHeight(25)
	category:setFont(fonts.get("pix24"))
	category:setText(_T("IN_HOUSE_ENGINES", "In-house engines"))
	category:assumeScrollbar(scrollbar)
	scrollbar:addItem(category)
	
	for key, engineObj in ipairs(self.owner:getEngines()) do
		local element = self:_createEngineSelectionElement(engineObj, elemW)
		
		element:setBasePanel(frame)
		category:addItem(element)
	end
	
	local category = gui.create("Category")
	
	category:setHeight(25)
	category:setFont(fonts.get("pix24"))
	category:setText(_T("LICENSED_ENGINES", "Licensed engines"))
	category:assumeScrollbar(scrollbar)
	scrollbar:addItem(category)
	
	for key, engineObj in ipairs(self.owner:getPurchasedEngines()) do
		local element = self:_createEngineSelectionElement(engineObj, elemW)
		
		element:setBasePanel(frame)
		category:addItem(element)
	end
	
	frame:center()
	
	local x, y = frame:getPos(true)
	local descbox = gui.create("GenericDescbox")
	
	descbox:tieVisibilityTo(frame)
	descbox:setFadeInSpeed(0)
	descbox:setPos(x + frame.w + _S(10), y)
	descbox:setID(gameProject.ENGINE_INFO_DESCBOX_ID)
	descbox:hide()
	frameController:push(frame)
end

function gameProject:_createEngineSelectionElement(engineObj, width)
	local element = gui.create("GameEngineSelectionElement")
	
	element:setWidth(width)
	element:setGame(self)
	element:setEngine(engineObj)
	
	return element
end

function gameProject:getUnfinishedStage()
	for key, stage in ipairs(self.stages) do
		if not stage:isDone() then
			return key
		end
	end
end

function gameProject:addPendingLogicPiece(taskID)
	if not self.pendingLogicPieces then
		self.pendingLogicPieces = {}
		
		table.insert(self.pendingLogicPieces, taskID)
	elseif not table.find(self.pendingLogicPieces, taskID) then
		table.insert(self.pendingLogicPieces, taskID)
	end
end

function gameProject:createLogicPieces()
	if self.pendingLogicPieces then
		for key, taskID in ipairs(self.pendingLogicPieces) do
			local taskData = taskTypes.registeredByID[taskID]
			
			if taskData then
				taskData:verifyLogicPiece(self)
			end
			
			self.pendingLogicPieces[key] = nil
		end
		
		self.pendingLogicPieces = nil
	end
end

function gameProject:addLogicPiece(pieceObj)
	if not self.logicPieces then
		self.logicPieces = {}
	end
	
	table.insert(self.logicPieces, pieceObj)
end

function gameProject:removeLogicPiece(piece)
	table.removeObject(self.logicPieces, piece)
end

function gameProject:getLogicPiece(id)
	if self.logicPieces then
		for key, piece in ipairs(self.logicPieces) do
			if piece:getID() == id then
				return piece
			end
		end
	end
	
	return nil
end

function gameProject:initContentPoints()
	if not self.contentPoints then
		self.contentPoints = {}
		self.totalContentPoints = 0
	end
end

function gameProject:getContentPoints()
	return self.contentPoints, self.totalContentPoints
end

function gameProject:addContentPoints(type, amount)
	self.contentPoints[type] = (self.contentPoints[type] or 0) + amount
	self.totalContentPoints = self.totalContentPoints + amount
end

function gameProject:getTotalContentPoints()
	return self.totalContentPoints
end

function gameProject:addExpansionPack(pack)
	self.expansionPacks = self.expansionPacks or {}
	self.contentFromExpansions = self.contentFromExpansions or {}
	self.expansionPackScale = (self.expansionPackScale or 0) + pack:getScale()
	
	table.insert(self.expansionPacks, pack)
	
	for pointID, amount in pairs(pack:getContentPoints()) do
		self.contentFromExpansions[pointID] = (self.contentFromExpansions[pointID] or 0) + amount
	end
end

function gameProject:getExpansionPackScale()
	return self.expansionPackScale
end

function gameProject:getExpansionPacks()
	return self.expansionPacks
end

function gameProject:getExpansionContent()
	return self.contentFromExpansions
end

gameProject.seenThemes, gameProject.seenGenres = {}, {}
gameProject.repetitivenessByGenre, gameProject.repetitivenessByTheme = {}, {}

function gameProject:calculateRepetitivenessSaleAffector()
	if not self:isNewGame() then
		return self.sequelTo:getRepetitivenessSaleAffector()
	end
	
	local games = self.owner:getReleasedGames()
	local repeatingGenres, repeatingThemes, uniqueGenres, uniqueThemes = 0, 0, 0, 0
	local time = timeline.curTime
	local repByGenre = gameProject.repetitivenessByGenre
	local seenGenres = gameProject.seenGenres
	local repByTheme = gameProject.repetitivenessByTheme
	local seenThemes = gameProject.seenThemes
	
	for i = #games, 1, -1 do
		local gameObject = games[i]
		
		if time - gameObject:getReleaseDate() <= gameProject.MAX_TIME_DIFFERENCE and gameObject:isNewGame() then
			local genre, theme = gameObject:getGenre(), gameObject:getTheme()
			local subgenre = gameObject:getSubgenre()
			
			if subgenre then
				if not table.find(seenGenres, subgenre) then
					repByGenre[subgenre] = 0
					seenGenres[#seenGenres + 1] = subgenre
					uniqueGenres = uniqueGenres + 1
				else
					repByGenre[subgenre] = repByGenre[subgenre] + 1
					repeatingGenres = repeatingGenres + 1
				end
			end
			
			if not table.find(seenGenres, genre) then
				repByGenre[genre] = 0
				seenGenres[#seenGenres + 1] = genre
				uniqueGenres = uniqueGenres + 1
			else
				repByGenre[genre] = repByGenre[genre] + 1
				repeatingGenres = repeatingGenres + 1
			end
			
			if not table.find(seenThemes, theme) then
				repByTheme[theme] = 0
				seenThemes[#seenThemes + 1] = theme
				uniqueThemes = uniqueThemes + 1
			else
				repByTheme[theme] = repByTheme[theme] + 1
				repeatingThemes = repeatingThemes + 1
			end
		end
	end
	
	local uniqueRating = uniqueGenres + uniqueThemes - 2
	local finalAffector = 1
	
	if uniqueRating >= gameProject.UNIQUE_REPETITIVENESS_PREVENTION then
		finalAffector = 1
	else
		local repetitivenessValue = math.max(0, (repByGenre[self.genre] or 0) + (repByTheme[self.theme] or 0))
		
		if repetitivenessValue > gameProject.MIN_REPETITIVENESS_FOR_PENALTY then
			finalAffector = finalAffector + (repetitivenessValue - gameProject.MIN_REPETITIVENESS_FOR_PENALTY) * gameProject.REPETITIVENESS_PENALTY_TO_DIVIDER
		end
	end
	
	for key, theme in ipairs(seenThemes) do
		repByTheme[theme] = nil
		seenThemes[key] = nil
	end
	
	for key, genre in ipairs(seenGenres) do
		repByGenre[genre] = nil
		seenGenres[key] = nil
	end
	
	return finalAffector
end

function gameProject:getRepetitivenessSaleAffector()
	return self.repetitivenessSaleAffector
end

function gameProject:getFullWorkCost()
	return self:getProjectStartCost()
end

function gameProject:beginWork(stage, devType, ...)
	stage = self:getUnfinishedStage() or stage
	devType = devType or self.curDevType
	
	self:addEventReceiver()
	
	if gameProject.CONTENT_POINTS_ON_DEV_TYPE[devType] then
		self:initContentPoints()
	end
	
	if gameProject.CREATE_TASKS_ON_DEV_TYPE[devType] then
		for feature, state in pairs(self.desiredFeatures) do
			if state then
				local taskData = taskTypes:getData(feature)
				local taskStage = taskData.stage or 1
				
				projectTypes:createAndAddStageTask(self, feature, taskStage)
			end
			
			self.desiredFeatures[feature] = nil
		end
	elseif devType == gameProject.DEVELOPMENT_TYPE.PATCH then
		self:setStage(2)
	end
	
	if not self.startOfWork then
		self.owner:setFact(gameProject.STARTED_GAMES_FACT, (self.owner:getFact(gameProject.STARTED_GAMES_FACT) or 0) + 1)
		
		self.startOfWork = timeline.curTime
		
		if self.owner:isPlayer() then
			self.owner:getStats():changeStat("games_developed", 1)
		end
	end
	
	engine.beginWork(self, stage, devType, ...)
	self.owner:addGame(self)
	events:fire(gameProject.EVENTS.BEGAN_WORK, self)
end

function gameProject:createStageTasks()
	project.createStageTasks(self)
	self:createPolishTasks()
end

function gameProject:createPolishTasks()
	if #self.stages[3]:getTasks() > 0 then
		return 
	end
	
	local stageTasks = self.stages[2]:getTasks()
	
	for key, taskObj in ipairs(stageTasks) do
		local taskType = taskObj:getTaskType()
		local task = projectTypes:createAndAddStageTask(self, taskType, 3, "polish_project_task")
	end
end

function gameProject:getScaleBounds(devType)
	return gameProject.SCALE[devType or self.curDevType]
end

function gameProject:getGameType()
	return self.curDevType
end

function gameProject:setGameType(gameType)
	gameType = self.contractor and self.contractor:getDesiredGameType() or gameType
	self.curDevType = gameType
	
	if not gameProject.SEQUEL_DEV_TYPES[self.curDevType] then
		self:setEngine(nil, self.sequelTo:getEngine())
		self:setGenre(self.sequelTo:getGenre())
		self:setTheme(self.sequelTo:getTheme())
		
		local baseGamePlatforms = self.sequelTo:getTargetPlatforms()
		local platformList = self.platforms
		local index = 1
		
		for i = 1, #platformList do
			local platformID = platformList[index]
			
			if not table.find(baseGamePlatforms, platformID) then
				self:setPlatformState(platformID, false)
			else
				index = index + 1
			end
		end
		
		for key, platformID in ipairs(baseGamePlatforms) do
			if not table.find(self.platforms, platformID) then
				self:setPlatformState(platformID, true)
			end
		end
	elseif self.curDevType == gameProject.DEVELOPMENT_TYPE.MMO then
		local platformList = self.platforms
		
		for i = #platformList, 1, -1 do
			self:setPlatformState(platformList[i], false)
		end
	end
	
	self:updatePirateableState()
	events:fire(gameProject.EVENTS.DEVELOPMENT_TYPE_CHANGED, self, gameType)
end

function gameProject:getGameTypeText(devType)
	return gameProject.DEVELOPMENT_TYPE_TEXT[devType or self.curDevType]
end

eventBoxText:registerNew({
	id = "game_off_market",
	getText = function(self, data)
		return _format(_T("GAME_NOW_OFF_MARKET", "'GAME' is now off-market."), "GAME", data:getName())
	end,
	saveData = function(self, data)
		return data:getUniqueID()
	end,
	loadData = function(self, targetElement, data)
		return studio:getGameByUniqueID(data)
	end
})

function gameProject:canReturnToMarket()
	return gameProject.RETURNABLE_TO_MARKET[self.curDevType]
end

function gameProject:returnToMarket()
	self.saleStamp = nil
	self.saleTimestamp = nil
	self.offMarket = false
	self.returnedToMarket = true
	self.facts[gameProject.LOWEST_RATING_SALE_MULTIPLIER_DAYS_FACT] = 0
	
	self:updateSaleAffectors()
	self:updateTrendContribution()
	self:setupCutsPerSale()
	self:createSaleDisplay()
	self:calculateEditionPurchasePercentages()
	self:addEventReceiver()
end

function gameProject:wasReturnedToMarket()
	return self.returnedToMarket
end

function gameProject:onRanOutMarketTime()
	self:removeEventReceiver()
	
	local removedFromEvent = self:getFact(gameProject.REMOVED_FROM_EVENT_RECEIVING)
	local requiresAdvertRemoval = self.returnedToMarket or not removedFromEvent
	
	if not removedFromEvent then
		if self.owner:isPlayer() then
			if self.rating >= 10 then
				studio:getStats():changeStat("10_of_10_games_released", 1)
				achievements:attemptSetAchievement(achievements.ENUM.TEN_OUT_OF_TEN)
			elseif math.floor(self.rating) <= 1 then
				studio:getStats():changeStat("1_of_10_games_released", 1)
				achievements:attemptSetAchievement(achievements.ENUM.ONE_OUT_OF_TEN)
			end
			
			if self.publisher then
				studio:getStats():changeStat("games_published", 1)
			end
			
			game.addToEventBox("game_off_market", self, 1, nil, "exclamation_point")
		end
		
		if self.isMMO then
			local sleeping = serverRenting:isSleeping()
			
			serverRenting:removeActiveMMO(self)
			
			if not sleeping and serverRenting:isSleeping() then
				local popup = game.createPopup(500, _T("MMO_SERVER_SERVICES_FROZEN_TITLE", "Server Services Frozen"), _format(_T("MMO_SERVER_SERVICES_FROZEN", "You've shutdown the last MMO that you had on-market.\n\nAll server-related services have been frozen, meaning you don't have to pay for any rented servers or customer support services until you release a new MMO."), "PROJECT", self:getName()), fonts.get("pix24"), fonts.get("pix20"))
				
				popup:setShowSound("generic_jingle")
				popup:hideCloseButton()
				frameController:push(popup)
			end
		end
		
		self.owner:onGameOffMarket(self)
	end
	
	if requiresAdvertRemoval then
		local advertData = advertisement.registeredByID
		
		for key, id in ipairs(self.activeAdvertisements) do
			advertData[id]:onOffMarket(self)
			
			self.activeAdvertisements[key] = nil
		end
	end
	
	if self.currentPatchID then
		self.patches[self.currentPatchID]:cancel()
	end
	
	self.momentPopularity = 0
	self.offMarket = true
	
	self:setFact(gameProject.REMOVED_FROM_EVENT_RECEIVING, true)
	
	self.cutsPerSale = nil
	
	events:fire(gameProject.EVENTS.GAME_OFF_MARKET, self)
end

function gameProject:getStartOfWorkDay()
	return self.startOfWork
end

function gameProject:getDaysSinceStartOfWork()
	return timeline.curTime - self.startOfWork
end

function gameProject:shouldSaveTasks()
	return not self:getFact(gameProject.REMOVED_FROM_EVENT_RECEIVING)
end

function gameProject:shouldLoadTasks()
	return not self:getFact(gameProject.REMOVED_FROM_EVENT_RECEIVING)
end

function gameProject:save()
	local saved = engine.save(self)
	
	saved.qualityPoints = self.qualityPoints
	saved.genre = self.genre
	saved.theme = self.theme
	saved.subgenre = self.subgenre
	saved.price = self.price
	saved.releaseDate = self.releaseDate
	saved.engineID = self.engineID
	saved.engineUID = self.engine:getUniqueID()
	saved.startOfWork = self.startOfWork
	saved.popularity = self.popularity
	saved.momentPopularity = self.momentPopularity
	saved.platforms = self.platforms
	saved.salesByPlatform = self.salesByPlatform
	saved.reviewedBy = self.reviewedBy
	saved.advertisements = self.advertisements
	saved.sales = self.sales
	saved.sequelTo = self.sequelTo and self.sequelTo:getUniqueID() or nil
	saved.engineRevision = self.engineRevision
	saved.employeeStatContribution = self.employeeStatContribution
	saved.featureStatContribution = self.featureStatContribution
	saved.totalSales = self.totalSales
	saved.totalSalesThisMonth = self.totalSalesThisMonth
	saved.moneyMade = self.moneyMade
	saved.moneyMadeByPlatform = self.moneyMadeByPlatform
	saved.curDevType = self.curDevType
	saved.contractor = self.contractor and self.contractor:getID() or nil
	saved.workExtends = self.workExtends
	saved.discoveredQAIssues = self.discoveredQAIssues
	saved.totalDiscoveredQAIssues = self.totalDiscoveredQAIssues
	saved.currentQAIssues = self.currentQAIssues
	saved.totalQASessions = self.totalQASessions
	saved.deadline = self.deadline
	saved.removedFromMarket = self.removedFromMarket
	saved.offeredInterviews = self.offeredInterviews
	saved.shownInterviews = self.shownInterviews
	saved.currentPatchID = self.currentPatchID
	saved.canEvaluateIssues = self.canEvaluateIssues
	saved.issueDiscoveryProgress = self.issueDiscoveryProgress
	saved.allIssuesDiscovered = self.allIssuesDiscovered
	saved.audience = self.audience
	saved.offMarket = self.offMarket
	saved.salesByWeek = self.salesByWeek
	saved.highestSales = self.highestSales
	saved.lastSales = self.lastSales
	saved.lastMoneyMade = self.lastMoneyMade
	saved.shareMoney = self.shareMoney
	saved.lastShareMoney = self.lastShareMoney
	saved.realMoneyMade = self.realMoneyMade
	saved.totalRealMoneyMade = self.totalRealMoneyMade
	saved.interviewsOfferedByReviewer = self.interviewsOfferedByReviewer
	saved.lastInterviewTime = self.lastInterviewTime
	saved.interviewCooldown = self.interviewCooldown
	saved.knowledgeStatContribution = self.knowledgeStatContribution
	saved.qualityFromKnowledge = self.qualityFromKnowledge
	saved.newStandards = self.newStandards
	saved.recoupAmount = self.recoupAmount
	saved.contractorFunding = self.contractorFunding
	saved.contentPoints = self.contentPoints
	saved.totalContentPoints = self.totalContentPoints
	saved.expansionSaleAffector = self.expansionSaleAffector
	saved.contentFromExpansions = self.contentFromExpansions
	saved.contentPriceAffector = self.contentPriceAffector
	saved.contentVarietyAffector = self.contentVarietyAffector
	saved.totalIssues = self.totalIssues
	saved.discoveredIssues = self.discoveredIssues
	saved.fixedIssues = self.fixedIssues
	saved.accumulatedIssues = self.accumulatedIssues
	saved.realRating = self.realRating
	saved.rating = self.rating
	saved.platformCount = self.platformCount
	saved.repetitivenessSaleAffector = self.repetitivenessSaleAffector
	saved.activeAdvertisements = self.activeAdvertisements
	saved.popularityFade = self.popularityFade
	saved.popularityFadeSpeed = self.popularityFadeSpeed
	saved.popularityDecreaseSpeed = self.popularityDecreaseSpeed
	saved.timeSaleAffector = self.timeSaleAffector
	saved.saleTimestamp = self.saleTimestamp
	saved.qualityByTasks = self.qualityByTasks
	saved.initialSales = self.initialSales
	saved.knownIdealPrice = self.knownIdealPrice
	saved.hypeCounter = self.hypeCounter
	saved.reviewRepGainScaler = self.reviewRepGainScaler
	saved.prequelSaleAffector = self.prequelSaleAffector
	saved.mmoTasks = self.mmoTasks
	saved.returnedToMarket = self.returnedToMarket
	saved.saleStamp = self.saleStamp
	saved.lostReputationOverhype = self.lostReputationOverhype
	saved.piratedCopies = self.piratedCopies
	saved.timeUntilPiracy = self.timeUntilPiracy
	saved.timeUntilPiracyCalculated = self.timeUntilPiracyCalculated
	saved.drmValue = self.drmValue
	saved.piracyStarted = self.piracyStarted
	saved.performedSubEvents = self.performedSubEvents
	saved.evaluatingDemo = self.evaluatingDemo
	saved.evaluatedDemo = self.evaluatedDemo
	saved.paidEditionCost = self.paidEditionCost
	
	local editions = {}
	
	for key, edit in ipairs(self.editions) do
		editions[key] = edit:save()
	end
	
	saved.editions = editions
	
	if self.logicPieces then
		local logicPieces = {}
		
		saved.logicPieces = logicPieces
		
		for key, piece in ipairs(self.logicPieces) do
			logicPieces[#logicPieces + 1] = piece:save()
		end
	end
	
	if self.relatedGames then
		local relatedGames = {}
		
		saved.relatedGames = relatedGames
		
		for key, gameObj in ipairs(self.relatedGames) do
			relatedGames[#relatedGames + 1] = gameObj:getUniqueID()
		end
	end
	
	saved.pendingLogicPieces = self.pendingLogicPieces
	saved.categoryPriorities = self.categoryPriorities
	
	if self.expansionPacks then
		local expPacks = {}
		
		saved.expansionPacks = expPacks
		
		for key, pack in ipairs(self.expansionPacks) do
			table.insert(expPacks, pack:getUniqueID())
		end
	end
	
	if self.publisher then
		saved.publisher = self.publisher:getID()
	end
	
	if self.contractData then
		saved.contractData = self.contractData:save()
	end
	
	local patches = {}
	
	saved.patches = patches
	
	for key, patchObject in ipairs(self.patches) do
		table.insert(patches, patchObject:save())
	end
	
	local reviews = {}
	
	saved.reviews = reviews
	
	for key, reviewObj in ipairs(self.reviews) do
		table.insert(reviews, reviewObj:save())
	end
	
	return saved
end

function gameProject:load(data)
	self.platforms = data.platforms
	self.platformCount = data.platformCount or table.count(self.platforms)
	
	self:calculatePlatformWorkAmountAffector()
	self:countManufacturerConsoleAmount()
	engine.load(self, data)
	
	self.qualityPoints = data.qualityPoints
	self.genre = data.genre
	self.theme = data.theme
	self.subgenre = data.subgenre
	self.price = data.price
	self.releaseDate = data.releaseDate
	self.engineID = data.engineID
	self.startOfWork = data.startOfWork
	self.popularity = data.popularity
	self.momentPopularity = data.momentPopularity
	self.salesByPlatform = data.salesByPlatform or self.salesByPlatform
	self.reviewedBy = data.reviewedBy or self.reviewedBy
	self.advertisements = data.advertisements
	self.sales = data.sales
	
	if self.subgenre == self.genre then
		self.subgenre = nil
	end
	
	self:updateMMOState()
	
	self.engineRevision = data.engineRevision
	self.employeeStatContribution = data.employeeStatContribution
	self.featureStatContribution = data.featureStatContribution
	self.totalSales = data.totalSales or self.totalSales
	self.totalSalesThisMonth = data.totalSalesThisMonth or self.totalSalesThisMonth
	self.moneyMade = data.moneyMade or self.moneyMade
	self.moneyMadeByPlatform = data.moneyMadeByPlatform or self.moneyMadeByPlatform
	self.curDevType = data.curDevType
	self.contractor = data.contractor and contractWork:getContractorByID(data.contractor) or nil
	self.workExtends = data.workExtends or self.workExtends
	self.discoveredQAIssues = data.discoveredQAIssues or self.discoveredQAIssues
	self.totalDiscoveredQAIssues = data.totalDiscoveredQAIssues or self.totalDiscoveredQAIssues
	self.currentQAIssues = data.currentQAIssues or self.currentQAIssues
	self.totalQASessions = data.totalQASessions or self.totalQASessions
	self.deadline = data.deadline
	self.removedFromMarket = data.removedFromMarket
	self.offeredInterviews = data.offeredInterviews or 0
	self.shownInterviews = data.shownInterviews or 0
	self.currentPatchID = data.currentPatchID
	self.canEvaluateIssues = data.canEvaluateIssues
	self.issueDiscoveryProgress = data.issueDiscoveryProgress or self.issueDiscoveryProgress
	self.allIssuesDiscovered = data.allIssuesDiscovered
	self.audience = data.audience
	self.offMarket = data.offMarket
	self.salesByWeek = data.salesByWeek or self.salesByWeek
	self.highestSales = data.highestSales or self.highestSales
	self.lastSales = data.lastSales or self.lastSales
	self.lastMoneyMade = data.lastMoneyMade or self.lastMoneyMade
	self.shareMoney = data.shareMoney or self.shareMoney
	self.lastShareMoney = data.lastShareMoney or self.lastShareMoney
	self.realMoneyMade = data.realMoneyMade or self.realMoneyMade
	self.totalRealMoneyMade = data.totalRealMoneyMade or self.totalRealMoneyMade
	self.interviewsOfferedByReviewer = data.interviewsOfferedByReviewer or self.interviewsOfferedByReviewer
	self.lastInterviewTime = data.lastInterviewTime or self.lastInterviewTime
	self.interviewCooldown = data.interviewCooldown or self.interviewCooldown
	self.knowledgeStatContribution = data.knowledgeStatContribution or self.knowledgeStatContribution
	self.qualityFromKnowledge = data.qualityFromKnowledge or self.qualityFromKnowledge
	self.newStandards = data.newStandards
	self.recoupAmount = data.recoupAmount
	self.contractorFunding = data.contractorFunding
	self.expansionSaleAffector = data.expansionSaleAffector
	self.contentFromExpansions = data.contentFromExpansions
	self.contentPriceAffector = data.contentPriceAffector
	self.contentVarietyAffector = data.contentVarietyAffector
	self.totalIssues = data.totalIssues or self.totalIssues
	self.discoveredIssues = data.discoveredIssues or self.discoveredIssues
	self.fixedIssues = data.fixedIssues or self.fixedIssues
	self.accumulatedIssues = data.accumulatedIssues or self.accumulatedIssues
	self.realRating = data.realRating
	self.rating = data.rating
	self.repetitivenessSaleAffector = data.repetitivenessSaleAffector or 1
	self.activeAdvertisements = data.activeAdvertisements or self.activeAdvertisements
	self.pendingLogicPieces = data.pendingLogicPieces
	self.logicPiecesData = data.logicPieces
	self.categoryPriorities = data.categoryPriorities or self.categoryPriorities
	self.hypeCounter = data.hypeCounter
	self.prequelSaleAffector = data.prequelSaleAffector
	self.mmoTasks = data.mmoTasks
	self.returnedToMarket = data.returnedToMarket
	self.lostReputationOverhype = data.lostReputationOverhype
	self.timeUntilPiracy = data.timeUntilPiracy or 0
	self.timeUntilPiracyCalculated = data.timeUntilPiracyCalculated
	self.drmValue = data.drmValue or 0
	self.piracyStarted = data.piracyStarted
	self.performedSubEvents = data.performedSubEvents or self.performedSubEvents
	self.evaluatingDemo = data.evaluatingDemo
	self.evaluatedDemo = data.evaluatedDemo
	self.paidEditionCost = data.paidEditionCost
	self.popularityFade = data.popularityFade or self.popularityFade
	self.popularityFadeSpeed = data.popularityFadeSpeed or self.popularityFadeSpeed
	self.popularityDecreaseSpeed = data.popularityDecreaseSpeed or self.popularityDecreaseSpeed
	self.timeSaleAffector = data.timeSaleAffector or self.timeSaleAffector
	self.saleTimestamp = data.saleTimestamp
	self.qualityByTasks = data.qualityByTasks or self.qualityByTasks
	self.contentPoints = data.contentPoints
	self.totalContentPoints = data.totalContentPoints
	self.initialSales = data.initialSales
	self.saleStamp = data.saleStamp or data.initialSales
	self.knownIdealPrice = data.knownIdealPrice
	
	if data.publisher then
		self:setPublisher(contractWork:getContractorByID(data.publisher))
	end
	
	if data.contractData then
		local contractDataObject = contractData.new()
		
		contractDataObject:load(data.contractData)
		
		self.contractData = contractDataObject
	end
	
	for key, reviewData in ipairs(data.reviews) do
		local reviewObj = projectReview.new(reviewData.reviewer)
		
		reviewObj:load(reviewData, self)
		table.insert(self.reviews, reviewObj)
	end
	
	if data.editions then
		for key, editData in ipairs(data.editions) do
			local edition = gameEditions:instantiate(self)
			
			edition:setProject(self)
			edition:load(editData)
			self:addEdition(edition)
		end
	end
	
	if #self.editions == 0 then
		self:initFirstTimeEdition()
	end
	
	if self:getFact(gameProject.QA_SESSION_START_TIME) then
		self:createQADisplay()
	end
	
	if self.releaseDate then
		self.piratedCopies = data.piratedCopies or 0
		self.reviewRepGainScaler = data.reviewRepGainScaler or 1
		
		self:addToPlatforms()
	end
end

function gameProject:postLoad(data)
	local owner = self.owner
	
	self.sequelTo = data.sequelTo and self.owner:getGameByUniqueID(data.sequelTo) or nil
	
	self:updatePirateableState()
	
	if self.sequelTo then
		self:setSequelTo(self.sequelTo, true)
	end
	
	if data.patches then
		for key, patchData in ipairs(data.patches) do
			local object = projectLoader:load(patchData, owner)
			
			table.insert(self.patches, object)
			object:postLoad(data)
		end
	end
	
	if data.relatedGames then
		self.relatedGames = {}
		
		for key, gameID in ipairs(data.relatedGames) do
			self.relatedGames[#self.relatedGames + 1] = owner:getProjectByUniqueID(gameID)
		end
	end
	
	if self.currentPatchID then
		local patch = self.patches[self.currentPatchID]
		
		if not patch:getTeam() then
			events:fire(project.EVENTS.LOADED_PROJECT, patch)
		end
	end
	
	if data.expansionPacks then
		self.expansionPacks = {}
		
		for key, pack in ipairs(data.expansionPacks) do
			table.insert(self.expansionPacks, owner:getProjectByUniqueID(pack))
		end
	end
	
	self:setEngine(data.engineUID, owner:getEngineByUniqueID(data.engineUID))
	
	if not data.rating and self.releaseDate then
		self:updateGameRating()
		self:updateRealGameRating(true)
	end
	
	if not self.offMarket then
		if self.releaseDate then
			self:updateSaleAffectors()
			self:updateTrendContribution()
			self:setupCutsPerSale()
			self:calculateDRMAffectors()
			self:calculateEditionPurchasePercentages()
			
			if self.isMMO then
				serverRenting:addActiveMMO(self)
			end
		end
		
		self:updateEditionPayment()
		self:addEventReceiver()
	else
		self:onRanOutMarketTime()
	end
	
	if self.logicPiecesData then
		self.logicPieces = {}
		
		for key, savedData in ipairs(self.logicPiecesData) do
			local loaded = logicPieces:loadLogicPiece(savedData, self)
			
			if loaded then
				self.logicPieces[#self.logicPieces + 1] = loaded
				
				loaded:setProject(self)
			end
		end
		
		for key, data in ipairs(self.logicPieces) do
			data:postLoad()
		end
		
		self.logicPiecesData = nil
	end
end

function gameProject:onFinishLoad()
	if self:canReleaseGame() and not self.releaseDate then
		events:fire(project.EVENTS.LOADED_PROJECT, self)
	end
	
	self:createSaleDisplay()
	
	for key, id in ipairs(self.activeAdvertisements) do
		advertisement:getData(id):onLoad(self)
	end
end
