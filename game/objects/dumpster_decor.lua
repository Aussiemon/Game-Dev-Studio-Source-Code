local testDec = {}

testDec.class = "dumpster_decor"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("dumpster")

objects.registerNew(testDec, "quadtree_decor_object_base")
