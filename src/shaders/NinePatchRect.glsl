uniform vec2 texture_size;
uniform vec2 render_size;
uniform vec2 border_pixels;
uniform float clip_x;

float map(float value, vec2 sourceRange, vec2 targetRange) {
  float normalized = (value - sourceRange[0]) / (sourceRange[1] - sourceRange[0]);
  return normalized * (targetRange[1] - targetRange[0]) + targetRange[0];
}

float patchAxis(float coordinate, float border_render_space, float border_texture_space) {
  if (coordinate < border_render_space) {
    return map(coordinate, vec2(0.0, border_render_space), vec2(0.0, border_texture_space));
  } else if (coordinate < 1.0 - border_render_space) {
    return map(coordinate, vec2(border_render_space, 1.0 - border_render_space), vec2(border_texture_space, 1.0-border_texture_space));
  } else {
    return map(coordinate, vec2(1.0 - border_render_space, 1.0), vec2(1.0-border_texture_space, 1.0));
  }
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_cords) {
  vec2 patch_coords;
  patch_coords.x = patchAxis(texture_coords.x, border_pixels.x / render_size.x, border_pixels.x / texture_size.x);
  patch_coords.y = patchAxis(texture_coords.y, border_pixels.y / render_size.y, border_pixels.y / texture_size.y);
  vec4 pixel = Texel(texture, patch_coords);
  if (texture_coords.x > clip_x) {
    pixel.a = 0.0;
  }
  return pixel * color;
}