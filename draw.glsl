uniform vec3 mouseMovement;
uniform vec2 mousePosition;
uniform float resScale;

vec4 effect(vec4 color, Image tex, vec2 uv, vec2 screen_coords) {
    vec4 texel = Texel(tex, uv);
    if (mouseMovement.z > 0. && length(screen_coords - mousePosition.xy * resScale) < 30. * resScale) {
        texel.xy = mouseMovement.xy * 50;
        texel.z = 1.;
    }
    return texel;
}