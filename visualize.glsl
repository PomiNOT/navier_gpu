vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
    vec4 texel = Texel(tex, uv);
    return vec4(texel.zzz, 1.);
}