sounds = {}
sounds.volume = 0.3

sound:setVolumeLevel(sound.VOLUME_TYPES.SPEECH, 0.5)

local newSoundData = {}

newSoundData.name = "place_object"
newSoundData.sound = {
	"sounds/construction/place_object1.ogg",
	"sounds/construction/place_object2.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("place_object", 1)

local newSoundData = {}

newSoundData.name = "pickup_object"
newSoundData.sound = {
	"sounds/construction/pick_up_object.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("pickup_object", 1)

local newSoundData = {}

newSoundData.name = "place_floor"
newSoundData.sound = {
	"sounds/construction/place_floor.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("place_floor", 1)

local newSoundData = {}

newSoundData.name = "place_wall"
newSoundData.sound = {
	"sounds/construction/wallPlace.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("place_wall", 1)

local breakWall = {}

breakWall.name = "break_wall"
breakWall.sound = {
	"sounds/construction/removeWall.ogg",
	"sounds/construction/removeWall2.ogg"
}
breakWall.soundType = "static"
breakWall.looping = false
breakWall.volume = sounds.volume
breakWall.volumeType = sound.VOLUME_TYPES.EFFECTS
breakWall.playAlways = true

register.newSoundData(breakWall)
register.newSoundChannel("break_wall", 1)

local sellObject = {}

sellObject.name = "sell_object"
sellObject.sound = {
	"sounds/construction/sell_object.ogg"
}
sellObject.soundType = "static"
sellObject.looping = false
sellObject.volume = sounds.volume
sellObject.volumeType = sound.VOLUME_TYPES.EFFECTS
sellObject.playAlways = true

register.newSoundData(sellObject)
register.newSoundChannel("sell_object", 1)

local buyFloor = {}

buyFloor.name = "purchase_building_floor"
buyFloor.sound = {
	"sounds/construction/floor_purchase_1.ogg",
	"sounds/construction/floor_purchase_2.ogg",
	"sounds/construction/floor_purchase_3.ogg"
}
buyFloor.soundType = "static"
buyFloor.looping = false
buyFloor.volume = sounds.volume
buyFloor.volumeType = sound.VOLUME_TYPES.EFFECTS
buyFloor.playAlways = true

register.newSoundData(buyFloor)
register.newSoundChannel("purchase_building_floor", 1)

local newSoundData = {}

newSoundData.name = "click_release"
newSoundData.sound = {
	"sounds/ui/ui_clickRelease.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.noVolumeAdjust = true
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("click_release", 1)

local newSoundData = {}

newSoundData.name = "click_down"
newSoundData.sound = {
	"sounds/ui/ui_clickDown.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.noVolumeAdjust = true
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("click_down", 1)

local newSoundData = {}

newSoundData.name = "switch_tab"
newSoundData.sound = {
	"sounds/ui/switch_tab.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.noVolumeAdjust = true
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("switch_tab", 1)

local newSoundData = {}

newSoundData.name = "feature_selected"
newSoundData.sound = {
	"sounds/ui/feature_selected.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume * 0.5
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.noVolumeAdjust = true
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("feature_selected", 1)

local newSoundData = {}

newSoundData.name = "feature_deselected"
newSoundData.sound = {
	"sounds/ui/feature_deselected.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = sounds.volume
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS
newSoundData.noVolumeAdjust = true
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("feature_deselected", 1)

local hudShow = {}

hudShow.name = "hud_buttons_show"
hudShow.sound = {
	"sounds/ui/hud_up.ogg"
}
hudShow.soundType = "static"
hudShow.looping = false
hudShow.volume = sounds.volume
hudShow.volumeType = sound.VOLUME_TYPES.EFFECTS
hudShow.noVolumeAdjust = true
hudShow.playAlways = true

register.newSoundData(hudShow)
register.newSoundChannel("hud_buttons_show", 1)

local hudHide = {}

hudHide.name = "hud_buttons_hide"
hudHide.sound = {
	"sounds/ui/hud_down.ogg"
}
hudHide.soundType = "static"
hudHide.looping = false
hudHide.volume = sounds.volume
hudHide.volumeType = sound.VOLUME_TYPES.EFFECTS
hudHide.noVolumeAdjust = true
hudHide.playAlways = true

register.newSoundData(hudHide)
register.newSoundChannel("hud_buttons_hide", 1)

local genericJingle = {}

genericJingle.name = "generic_jingle"
genericJingle.sound = {
	"sounds/ui/misc_jingle.ogg"
}
genericJingle.soundType = "static"
genericJingle.looping = false
genericJingle.volume = sounds.volume * 0.5
genericJingle.volumeType = sound.VOLUME_TYPES.EFFECTS
genericJingle.noVolumeAdjust = true
genericJingle.playAlways = true

register.newSoundData(genericJingle)
register.newSoundChannel("generic_jingle", 1)

local badJingle = {}

badJingle.name = "bad_jingle"
badJingle.sound = {
	"sounds/ui/bad_event_1.ogg",
	"sounds/ui/bad_event_2.ogg",
	"sounds/ui/bad_event_3.ogg",
	"sounds/ui/bad_event_4.ogg"
}
badJingle.soundType = "static"
badJingle.looping = false
badJingle.volume = sounds.volume * 0.5
badJingle.volumeType = sound.VOLUME_TYPES.EFFECTS
badJingle.noVolumeAdjust = true
badJingle.playAlways = true

register.newSoundData(badJingle)
register.newSoundChannel("bad_jingle", 1)

local goodJingle = {}

goodJingle.name = "good_jingle"
goodJingle.sound = {
	"sounds/ui/good_event_1.ogg",
	"sounds/ui/good_event_2.ogg",
	"sounds/ui/good_event_3.ogg",
	"sounds/ui/good_event_4.ogg"
}
goodJingle.soundType = "static"
goodJingle.looping = false
goodJingle.volume = sounds.volume * 0.5
goodJingle.volumeType = sound.VOLUME_TYPES.EFFECTS
goodJingle.noVolumeAdjust = true
goodJingle.playAlways = true

register.newSoundData(goodJingle)
register.newSoundChannel("good_jingle", 1)

local fundChange = {}

fundChange.name = "fund_change"
fundChange.sound = {
	"sounds/interaction/fundChange.ogg"
}
fundChange.soundType = "static"
fundChange.looping = false
fundChange.volume = sounds.volume * 0.5
fundChange.volumeType = sound.VOLUME_TYPES.EFFECTS
fundChange.noVolumeAdjust = true
fundChange.playAlways = true

register.newSoundData(fundChange)
register.newSoundChannel("fund_change", 1)
register.newSoundData({
	soundType = "static",
	name = "floor_down",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/floor_switch_down.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("floor_down", 1)
register.newSoundData({
	soundType = "static",
	name = "floor_up",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/floor_switch_up.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("floor_up", 1)

local newSoundData = {}

newSoundData.name = "dialogue_spool"
newSoundData.sound = {
	"sounds/spool_text.ogg"
}
newSoundData.soundType = "static"
newSoundData.looping = false
newSoundData.volume = 0.1
newSoundData.volumeType = sound.VOLUME_TYPES.SPEECH
newSoundData.noVolumeAdjust = true
newSoundData.playAlways = true

register.newSoundData(newSoundData)
register.newSoundChannel("dialogue_spool", 1)

local newSoundData = {}

newSoundData.name = "keyboard_clicks"
newSoundData.sound = {
	"sounds/ambient/keyboard/keyboard_1.ogg",
	"sounds/ambient/keyboard/keyboard_2.ogg",
	"sounds/ambient/keyboard/keyboard_3.ogg"
}
newSoundData.soundType = "static"
newSoundData.maxDistance = 500
newSoundData.fadeDistance = 400
newSoundData.looping = false
newSoundData.volume = sounds.volume * 0.125
newSoundData.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(newSoundData)
register.newSoundChannel("keyboard_clicks", 8)

local useToilet = {}

useToilet.name = "use_toilet"
useToilet.sound = {
	"sounds/toilet_flush.ogg"
}
useToilet.soundType = "stream"
useToilet.maxDistance = 400
useToilet.fadeDistance = 400
useToilet.looping = false
useToilet.volume = sounds.volume
useToilet.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(useToilet)
register.newSoundChannel("use_toilet", 8)

local lightSwitch = {}

lightSwitch.name = "toggle_light"
lightSwitch.sound = {
	"sounds/ambient/light_switch.ogg"
}
lightSwitch.soundType = "static"
lightSwitch.maxDistance = 1000
lightSwitch.fadeDistance = 800
lightSwitch.looping = false
lightSwitch.volume = sounds.volume * 0.15
lightSwitch.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(lightSwitch)
register.newSoundChannel("toggle_light", 8)

local openDoor = {}

openDoor.name = "door_open"
openDoor.sound = {
	"sounds/doors/door_open_1.ogg"
}
openDoor.soundType = "static"
openDoor.maxDistance = 400
openDoor.fadeDistance = 400
openDoor.looping = false
openDoor.volume = sounds.volume
openDoor.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(openDoor)
register.newSoundChannel("door_open", 8)

local closeDoor = {}

closeDoor.name = "door_close"
closeDoor.sound = {
	"sounds/doors/door_close_1.ogg",
	"sounds/doors/door_close_2.ogg"
}
closeDoor.soundType = "static"
closeDoor.maxDistance = 400
closeDoor.fadeDistance = 400
closeDoor.looping = false
closeDoor.volume = sounds.volume
closeDoor.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(closeDoor)
register.newSoundChannel("door_close", 8)

local soldGameCopies = {}

soldGameCopies.name = "sold_game_copies"
soldGameCopies.sound = {
	"sounds/sold_game_copies.ogg"
}
soldGameCopies.soundType = "static"
soldGameCopies.looping = false
soldGameCopies.volume = 0.1
soldGameCopies.volumeType = sound.VOLUME_TYPES.EFFECTS
soldGameCopies.playAlways = true

register.newSoundData(soldGameCopies)
register.newSoundChannel("sold_game_copies", 1)

local cashChanged = {}

cashChanged.name = "cash_changed"
cashChanged.sound = {
	"sounds/cash_changed.ogg"
}
cashChanged.soundType = "static"
cashChanged.looping = false
cashChanged.playAlways = true
cashChanged.volume = 0.1
cashChanged.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(cashChanged)
register.newSoundChannel("cash_changed", 1)

local time1X = {}

time1X.name = "time_1x"
time1X.sound = {
	"sounds/ui/time_set_1.ogg"
}
time1X.soundType = "static"
time1X.looping = false
time1X.playAlways = true
time1X.volume = 0.1
time1X.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData({
	soundType = "static",
	name = "time_1x",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/time_set_1.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("time_1x", 1)
register.newSoundData({
	soundType = "static",
	name = "time_2x",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/time_set_2.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("time_2x", 1)
register.newSoundData({
	soundType = "static",
	name = "time_3x",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/time_set_3.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("time_3x", 1)
register.newSoundData({
	soundType = "static",
	name = "time_4x",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/time_set_4.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("time_4x", 1)
register.newSoundData({
	soundType = "static",
	name = "time_5x",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/time_set_5.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("time_5x", 1)
register.newSoundData({
	soundType = "static",
	name = "time_pause",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/time_pause.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("time_pause", 1)
register.newSoundData({
	soundType = "static",
	name = "popup_in",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/popup_1.ogg",
		"sounds/ui/popup_2.ogg",
		"sounds/ui/popup_3.ogg",
		"sounds/ui/popup_4.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("popup_in", 1)
register.newSoundData({
	soundType = "static",
	name = "zoom_in",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/zoom_in.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("zoom_in", 1)
register.newSoundData({
	soundType = "static",
	name = "zoom_out",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/ui/zoom_out.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("zoom_out", 1)

local birds = {}

birds.name = "ambient_birds"
birds.sound = {
	"sounds/ambient/environment/birds1.ogg",
	"sounds/ambient/environment/birds2.ogg",
	"sounds/ambient/environment/birds3.ogg",
	"sounds/ambient/environment/birds4.ogg",
	"sounds/ambient/environment/birds5.ogg"
}
birds.soundType = "static"
birds.looping = false
birds.volume = 0.12
birds.noVolumeAdjust = true
birds.volumeType = sound.VOLUME_TYPES.AMBIENT
birds.noStopping = true

register.newSoundData(birds)
register.newSoundChannel("ambient_birds", 1)

local wind = {}

wind.name = "ambient_wind"
wind.sound = {
	"sounds/ambient/environment/wind_day_1.ogg",
	"sounds/ambient/environment/wind_day_2.ogg",
	"sounds/ambient/environment/wind_day_3.ogg",
	"sounds/ambient/environment/wind_day_4.ogg",
	"sounds/ambient/environment/wind_day_5.ogg"
}
wind.soundType = "static"
wind.looping = false
wind.volume = 0.12
wind.noVolumeAdjust = true
wind.volumeType = sound.VOLUME_TYPES.AMBIENT
wind.noStopping = true

register.newSoundData(wind)
register.newSoundChannel("ambient_wind", 1)

local nightWind = {}

nightWind.name = "ambient_wind_night"
nightWind.sound = {
	"sounds/ambient/environment/wind_night_1.ogg",
	"sounds/ambient/environment/wind_night_2.ogg",
	"sounds/ambient/environment/wind_night_3.ogg",
	"sounds/ambient/environment/wind_night_4.ogg",
	"sounds/ambient/environment/wind_night_5.ogg"
}
nightWind.soundType = "static"
nightWind.looping = false
nightWind.volume = 0.12
nightWind.noVolumeAdjust = true
nightWind.volumeType = sound.VOLUME_TYPES.AMBIENT
nightWind.noStopping = true

register.newSoundData(nightWind)
register.newSoundChannel("ambient_wind_night", 1)

local crickets = {}

crickets.name = "ambient_crickets"
crickets.sound = {
	"sounds/ambient/environment/cricket_loop.ogg"
}
crickets.soundType = "static"
crickets.looping = true
crickets.volume = 0.12
crickets.noVolumeAdjust = true
crickets.volumeType = sound.VOLUME_TYPES.AMBIENT
crickets.noStopping = true

register.newSoundData(crickets)
register.newSoundChannel("ambient_crickets", 1)

local lightRain = {}

lightRain.name = "rain_light"
lightRain.sound = {
	"sounds/ambient/environment/rainLow.ogg"
}
lightRain.soundType = "static"
lightRain.looping = true
lightRain.volume = 0.12
lightRain.volumeType = sound.VOLUME_TYPES.AMBIENT
lightRain.noVolumeAdjust = true
lightRain.noStopping = true

register.newSoundData(lightRain)
register.newSoundChannel("rain_light", 1)

local moderateRain = {}

moderateRain.name = "rain_medium"
moderateRain.sound = {
	"sounds/ambient/environment/rainMed.ogg"
}
moderateRain.soundType = "static"
moderateRain.looping = true
moderateRain.volume = 0.12
moderateRain.volumeType = sound.VOLUME_TYPES.AMBIENT
moderateRain.noVolumeAdjust = true
moderateRain.noStopping = true

register.newSoundData(moderateRain)
register.newSoundChannel("rain_medium", 1)

local strongRain = {}

strongRain.name = "rain_strong"
strongRain.sound = {
	"sounds/ambient/environment/rainHeavy.ogg"
}
strongRain.soundType = "static"
strongRain.looping = true
strongRain.volume = 0.12
strongRain.volumeType = sound.VOLUME_TYPES.AMBIENT
strongRain.noVolumeAdjust = true
strongRain.noStopping = true

register.newSoundData(strongRain)
register.newSoundChannel("rain_strong", 1)

local lightning = {}

lightning.name = "rain_lightning"
lightning.sound = {
	"sounds/ambient/environment/thunder.ogg"
}
lightning.soundType = "static"
lightning.looping = false
lightning.volume = 0.12
lightning.volumeType = sound.VOLUME_TYPES.AMBIENT
lightning.noStopping = true
lightning.noVolumeAdjust = true

register.newSoundData(lightning)
register.newSoundChannel("rain_lightning", 1)

local placeLamp = {}

placeLamp.name = "place_lamp"
placeLamp.sound = {
	"sounds/construction/place_lamp.ogg"
}
placeLamp.soundType = "stream"
placeLamp.looping = false
placeLamp.playAlways = true
placeLamp.noVolumeAdjust = true
placeLamp.volume = 0.3
placeLamp.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(placeLamp)
register.newSoundChannel("place_lamp", 1)
require("game/sounds_main_menu")

local expandOffice = {}

expandOffice.name = "expand_building"
expandOffice.sound = {
	"sounds/interaction/expandBuilding.ogg"
}
expandOffice.soundType = "stream"
expandOffice.looping = false
expandOffice.playAlways = true
expandOffice.noVolumeAdjust = true
expandOffice.volume = 0.3
expandOffice.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(expandOffice)
register.newSoundChannel("expand_building", 1)
register.newSoundData({
	soundType = "static",
	name = "office_purchased",
	volume = 0.1,
	playAlways = true,
	looping = false,
	sound = {
		"sounds/construction/office_purchased_1.ogg",
		"sounds/construction/office_purchased_2.ogg",
		"sounds/construction/office_purchased_3.ogg",
		"sounds/construction/office_purchased_4.ogg"
	},
	volumeType = sound.VOLUME_TYPES.EFFECTS
})
register.newSoundChannel("office_purchased", 1)

local crowd_applause = {}

crowd_applause.name = "crowd_applause"
crowd_applause.sound = {
	"sounds/game_awards/applause_1.ogg",
	"sounds/game_awards/applause_2.ogg"
}
crowd_applause.soundType = "stream"
crowd_applause.looping = false
crowd_applause.playAlways = true
crowd_applause.noVolumeAdjust = true
crowd_applause.volume = 0.3
crowd_applause.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(crowd_applause)
register.newSoundChannel("crowd_applause", 1)

local crowd_applause_goty = {}

crowd_applause_goty.name = "crowd_applause_goty"
crowd_applause_goty.sound = {
	"sounds/game_awards/applause_goty.ogg"
}
crowd_applause_goty.soundType = "stream"
crowd_applause_goty.looping = false
crowd_applause_goty.playAlways = true
crowd_applause_goty.noVolumeAdjust = true
crowd_applause_goty.volume = 0.3
crowd_applause_goty.volumeType = sound.VOLUME_TYPES.EFFECTS

register.newSoundData(crowd_applause_goty)
register.newSoundChannel("crowd_applause_goty", 1)
