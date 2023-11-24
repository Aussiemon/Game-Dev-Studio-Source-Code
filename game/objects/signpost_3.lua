local testDec = {}

testDec.class = "signpost_3"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("signpost_stop")

objects.registerNew(testDec, "quadtree_decor_object_base")
