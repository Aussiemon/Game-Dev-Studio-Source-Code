shaders.outline = love.graphics.newShader("extern vec2 stepSize;\nextern vec3 outlineColor;\n\nvec4 effect(vec4 col, Image texture, vec2 texturePos, vec2 screenPos)\n{\n    // get the base alpha channel value\n\tfloat alpha = ceil(Texel(texture, texturePos).a);\n\t\n\t// evaluate alpha channels to the left, right, up, and down\n\tfloat hor = min(ceil(Texel(texture, texturePos + vec2(stepSize.x, 0.0)).a), ceil(Texel(texture, texturePos + vec2(-stepSize.x, 0.0)).a));\n\tfloat vert = min(ceil(Texel(texture, texturePos + vec2(0, stepSize.y)).a), ceil(Texel(texture, texturePos + vec2(0, -stepSize.y)).a));\n\t\n\t// if there is at least one empty pixel in any direction, we will display an outline on this pixel\n\tfloat final = 0.25 + (1.0 - min(vert, hor)) * 0.75;\n\t\n\t// apply the alpha multiplier and return the final color value\t\n\treturn vec4(outlineColor.r, outlineColor.g, outlineColor.b, alpha * final);\n}")