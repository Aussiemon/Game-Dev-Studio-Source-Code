local testDec = {}

testDec.class = "bench_decor"
testDec.objectAtlas = "city_decor"
testDec.quad = quadLoader:load("bench")
testDec.tileWidth = 2
testDec.tileHeight = 1
testDec.preventsMovement = true

objects.registerNew(testDec, "decoration_object_base")
