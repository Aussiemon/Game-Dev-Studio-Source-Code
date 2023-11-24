local testDec = {}

testDec.class = "billboard_3"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("billboard_3")

objects.registerNew(testDec, "quadtree_decor_object_base")
