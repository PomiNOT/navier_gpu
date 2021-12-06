uniform vec2 iResolution;
uniform sampler2D heightField;

#define T(x) ((x) / iResolution)

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
    float h = 1 / iResolution.x;
    vec4 top = Texel(heightField, T(screen_coords + vec2(0.0, -1.0)));
    vec4 bottom = Texel(heightField, T(screen_coords + vec2(0.0, 1.0)));
    vec4 left = Texel(heightField, T(screen_coords + vec2(-1.0, 0.0)));
    vec4 right = Texel(heightField, T(screen_coords + vec2(1.0, 0.0)));
    vec2 gradient = 0.5 * vec2(right.y - left.y, bottom.y - top.y) / h;
    vec4 texel = Texel(tex, uv);
    return vec4(texel.xy - gradient, texel.z, 1.);
}