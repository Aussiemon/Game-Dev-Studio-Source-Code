local testDec = {}

testDec.class = "bush_large"
testDec.objectAtlas = "growing_decor"
testDec.tileWidth = 2
testDec.tileHeight = 2
testDec.quad = quadLoader:load("bush_big")

objects.registerNew(testDec, "quadtree_decor_object_base")
