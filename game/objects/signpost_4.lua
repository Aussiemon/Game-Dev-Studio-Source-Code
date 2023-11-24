local testDec = {}

testDec.class = "signpost_4"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("signpost_warning")

objects.registerNew(testDec, "quadtree_decor_object_base")
