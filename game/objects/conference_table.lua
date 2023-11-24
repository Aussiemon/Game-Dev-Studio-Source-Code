local conferenceTable = {}

conferenceTable.tileWidth = 4
conferenceTable.tileHeight = 2
conferenceTable.class = "conference_table"
conferenceTable.objectType = "conference_desk"
conferenceTable.category = "office"
conferenceTable.display = _T("CONFERENCE_TABLE", "Conference table")
conferenceTable.description = _T("CONFERENCE_TABLE_DESCRIPTION", "Business men love these!\nA conference room can be created to hold motivational speeches in.\nMotivational speeches can boost your employees' Drive levels, resulting in higher efficiency and longer work time without vacation.")
conferenceTable.quad = quadLoader:load("conference_table")
conferenceTable.icon = "icon_conference_table"
conferenceTable.scaleX = 1
conferenceTable.scaleY = 1
conferenceTable.surroundingWidth = 1
conferenceTable.surroundingHeight = 1
conferenceTable.surroundingChairs = 3
conferenceTable.cost = 100
conferenceTable.minimumIllumination = 0.35
conferenceTable.preventsMovement = true
conferenceTable.X_OFFSET_TO_CHAIR = 24
conferenceTable.Y_OFFSET_TO_CHAIR = 24
conferenceTable.roomType = studio.ROOM_TYPES.CONFERENCE
conferenceTable.FORWARD_OFFSET_TO_CHAIR = -18
conferenceTable.foodSpritebatch = "object_atlas_2"
conferenceTable.objectAtlasBetweenWalls = "object_atlas_2_between_walls"

objects.registerNew(conferenceTable, "conference_object_base")
