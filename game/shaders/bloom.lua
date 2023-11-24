shaders.bloomThreshold = love.graphics.newShader("\t#ifdef PIXEL\n\t\tvec4 effect(vec4 color, Image canvas, vec2 uv, vec2 pixelCoordinates)\n\t\t{\n\t\t\tvec4 texel = Texel(canvas, uv);\n\t\t\tfloat brightness = dot(texel.rgb, vec3(0.2126, 0.7152, 0.0722));\n\t\t\t\n\t\t\tif (brightness > 1.0)\n\t\t\t\treturn vec4(texel.rgb, 1.0);\n\t\t}\n\t#endif\n")