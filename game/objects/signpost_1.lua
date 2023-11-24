local testDec = {}

testDec.class = "signpost_1"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("signpost")

objects.registerNew(testDec, "quadtree_decor_object_base")
