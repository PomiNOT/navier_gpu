uniform vec2 iResolution;
uniform float iTimeDelta;

#define T(x) ((x) / iResolution)

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
    vec2 vel = Texel(tex, T(screen_coords)).xy;
    vec2 was = screen_coords - vel * iTimeDelta;
    return vec4(Texel(tex, T(was)).xyz, 1.0);
}