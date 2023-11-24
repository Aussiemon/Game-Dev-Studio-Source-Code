local testDec = {}

testDec.class = "billboard_1"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("billboard_1")

objects.registerNew(testDec, "quadtree_decor_object_base")
