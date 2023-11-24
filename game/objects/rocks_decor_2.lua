local testDec = {}

testDec.class = "rocks_decor_2"
testDec.objectAtlas = "world_decorations_no_shadow"
testDec.quad = quadLoader:load("rocks_2")
testDec.scaleX = 2
testDec.scaleY = 2

objects.registerNew(testDec, "rocks_decor")
