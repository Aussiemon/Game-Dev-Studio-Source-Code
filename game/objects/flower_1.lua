local testDec = {}

testDec.class = "flower_1"
testDec.scaleX = 2
testDec.scaleY = 2
testDec.tileWidth = 2
testDec.tileHeight = 2
testDec.objectAtlas = "growing_decor"
testDec.quad = quadLoader:load("flower_1")

objects.registerNew(testDec, "quadtree_decor_object_base")
