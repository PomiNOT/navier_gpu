uniform vec2 iResolution;
uniform float alpha;
uniform float beta;
uniform Image orig;
uniform bool calculatingHeightfield;

#define T(x) ((x) / iResolution)

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
    vec4 texel = Texel(orig, T(screen_coords));
    vec4 top = Texel(tex, T(screen_coords + vec2(0.0, -1.0)));
    vec4 bottom = Texel(tex, T(screen_coords + vec2(0.0, 1.0)));
    vec4 left = Texel(tex, T(screen_coords + vec2(-1.0, 0.0)));
    vec4 right = Texel(tex, T(screen_coords + vec2(1.0, 0.0)));
    if (!calculatingHeightfield) {
        vec4 result = (texel + alpha * (top + bottom + left + right)) / beta;
        return vec4(result.xy, texel.z, 1.);
    }
    else {
        float result = (texel.x + alpha * (top.y + bottom.y + left.y + right.y)) / beta;
        return vec4(texel.x, result, 0., 1.);
    }
}