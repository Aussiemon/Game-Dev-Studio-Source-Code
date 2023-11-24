local testDec = {}

testDec.class = "bush_medium"
testDec.objectAtlas = "growing_decor"
testDec.tileWidth = 2
testDec.tileHeight = 2
testDec.quad = quadLoader:load("bush_medium")

objects.registerNew(testDec, "quadtree_decor_object_base")
