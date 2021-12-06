uniform vec2 iResolution;

#define T(x) ((x) / iResolution)

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
    float h = 1 / iResolution.x;
    vec4 top = Texel(tex, T(screen_coords + vec2(0.0, -1.0)));
    vec4 bottom = Texel(tex, T(screen_coords + vec2(0.0, 1.0)));
    vec4 left = Texel(tex, T(screen_coords + vec2(-1.0, 0.0)));
    vec4 right = Texel(tex, T(screen_coords + vec2(1.0, 0.0)));
    float div = -0.5 * h * (right.x - left.x + bottom.y - top.y);
    return vec4(div, 0, 0, 1);
}