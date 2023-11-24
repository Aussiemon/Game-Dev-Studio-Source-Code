local testDec = {}

testDec.class = "rocks_decor_1"
testDec.objectAtlas = "world_decorations_no_shadow"
testDec.quad = quadLoader:load("rocks_1")
testDec.scaleX = 2
testDec.scaleY = 2

objects.registerNew(testDec, "rocks_decor")
