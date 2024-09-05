uniform float clip_x;
uniform float uv_fade;

float clipRange(float clip, float coord) {
  vec2 clipRange = vec2(clip - ((1.0 - clip) * uv_fade), clip + (clip * uv_fade));
  float clamped = min(max(coord, clipRange.x), clipRange.y);
  return 1.0 - ((clamped - clipRange.x) / (clipRange.y - clipRange.x));
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_cords) {
  vec4 pixel = Texel(texture, texture_coords);
  pixel.a = pixel.a * clipRange(clip_x, texture_coords.x);
  return pixel * color;
}