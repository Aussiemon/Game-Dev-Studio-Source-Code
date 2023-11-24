local testDec = {}

testDec.class = "rocks_decor_3"
testDec.objectAtlas = "world_decorations_no_shadow"
testDec.quad = quadLoader:load("rocks_3")
testDec.scaleX = 2
testDec.scaleY = 2

objects.registerNew(testDec, "rocks_decor")
