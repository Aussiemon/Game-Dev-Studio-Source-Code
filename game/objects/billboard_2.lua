local testDec = {}

testDec.class = "billboard_2"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("billboard_2")

objects.registerNew(testDec, "quadtree_decor_object_base")
