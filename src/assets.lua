local assets = {}

function assets.load()
  assets.T_Background = love.graphics.newImage("textures/Background1920.jpg")
  assets.T_ArcaneBlast = love.graphics.newImage("textures/ArcaneBlast.png")
  assets.T_AbilitySlot = love.graphics.newImage("textures/AbilitySlot.png")
  assets.T_AbilitySlotShadow = love.graphics.newImage("textures/AbilitySlotShadow.png")
  assets.T_AbilitySlotClick = love.graphics.newImage("textures/AbilitySlotClick.png")
  assets.T_AbilitySlotCooldown = love.graphics.newImage("textures/AbilitySlotCooldown.png")
  assets.T_CastbarBorder = love.graphics.newImage("textures/CastbarBorder.png")
  assets.T_CastbarBackground = love.graphics.newImage("textures/CastbarBackground.png")
  assets.T_CastbarFill = love.graphics.newImage("textures/CastbarFill.png")

  assets.F_WashYourHands_72 = love.graphics.newFont("fonts/WashYourHand.ttf", 72)

  assets.S_NinePatchRect = love.graphics.newShader[[
uniform vec2 texture_size;
uniform vec2 render_size;

float map(float value, vec2 sourceRange, vec2 targetRange) {
  float normalized = (value - sourceRange[0]) / (sourceRange[1] - sourceRange[0]);
  return normalized * (targetRange[1] - targetRange[0]) + targetRange[0];
}

float patch(float coordinate, float border_render_space, float border_texture_space) {
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
  float border_pixels = 10.0;
  patch_coords.x = patch(texture_coords.x, border_pixels / render_size.x, border_pixels / texture_size.x);
  patch_coords.y = patch(texture_coords.y, border_pixels / render_size.y, border_pixels / texture_size.y);
  vec4 pixel = Texel(texture, patch_coords);
  return pixel * color;
}
]]

  assets.S_RadialFade = love.graphics.newShader[[
extern number target_angle;

#define M_PI 3.1415926535897932384626433832795
#define ZERO_THRESHOLD radians(0.5)
#define SMOOTHING radians(4.0)

float inverseLerp(float a, float b, float x) {
  return clamp((x - a) / (b - a), 0.0, 1.0);
}

float unitCircleAngle(vec2 uv) {
  vec2 unitCircleCoords = normalize(vec2(uv.x, 1.0 - uv.y) - vec2(0.5, 0.5));
  highp float result = atan(unitCircleCoords.y, unitCircleCoords.x);
  if (result < 0.0) {
      result += 2.0 * M_PI;
  }
  return result;
}

float smoothing(float pixelAngle) {
  float angularDistance = abs(pixelAngle - target_angle);
  if (angularDistance > M_PI) {
    angularDistance = 2.0 * M_PI - angularDistance;
  }
  float nearZeroThreshold = 2.0 * M_PI - SMOOTHING;

  if (target_angle < ZERO_THRESHOLD) {
    return 1.0;
  }
  else if (pixelAngle < target_angle) {
    return 0.0;
  } else if (pixelAngle > nearZeroThreshold && target_angle < nearZeroThreshold && false) {
    return 1.0 - inverseLerp(nearZeroThreshold, 2.0 * M_PI, pixelAngle);
  } else {
    return inverseLerp(0.0, SMOOTHING, angularDistance);
  }
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_cords) {
  float pixelAngle = unitCircleAngle(texture_coords);
  highp float t = smoothing(pixelAngle);
  vec4 pixel = Texel(texture, texture_coords);
  pixel.a = pixel.a * (1.0-t);
  return pixel;
}
]]
end

return assets