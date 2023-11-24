local regularFont = "fonts/RobotoCondensed-Regular.ttf"

fonts.createNewFonts(regularFont, "pix", -4, nil, 12, 14, 15, 16, 18, 19, 20, 22, 24, 26, 28, 30, 32, 34, 36, 48)

local bhFile = "fonts/RobotoCondensed-Bold.ttf"

fonts.createNewFonts(bhFile, "bh", -4, nil, 12, 14, 15, 16, 18, 19, 20, 22, 24, 26, 28, 30, 32, 34, 36, 48)
fonts.createNewFont(regularFont, "pix_world18", 17, nil, true)
fonts.createNewFont(regularFont, "pix_world20", 19, nil, true)
fonts.createNewFont(regularFont, "pix_world22", 21, nil, true)
fonts.createNewFont(bhFile, "bh_world22", 21, nil, true)
fonts.createNewFont(bhFile, "bh_world20", 19, nil, true)
fonts.createNewFont(bhFile, "bh_world18", 17, nil, true)
fonts.createNewFont(bhFile, "bh_world16", 15, nil, true)
fonts.setFallbacks(regularFont, "fonts/cn-fallback.ttf")
fonts.setFallbacks(bhFile, "fonts/cn-fallback.ttf")

fonts.GENERIC_TEXT_AUTO_ADJUST_FONTS = {
	"pix24",
	"pix22",
	"pix20",
	"pix18",
	"pix16"
}
fonts.BOLD_AUTO_ADJUST_FONTS = {
	"bh24",
	"bh22",
	"bh20",
	"bh18",
	"bh16"
}
