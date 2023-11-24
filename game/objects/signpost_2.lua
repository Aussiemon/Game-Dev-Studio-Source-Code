local testDec = {}

testDec.class = "signpost_2"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("signpost_animals")

objects.registerNew(testDec, "quadtree_decor_object_base")
