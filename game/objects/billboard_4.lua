local testDec = {}

testDec.class = "billboard_4"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("billboard_4")

objects.registerNew(testDec, "quadtree_decor_object_base")
