local testDec = {}

testDec.class = "test_decor_entity"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("trashcan")

objects.registerNew(testDec, "quadtree_decor_object_base")
