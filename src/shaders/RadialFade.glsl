uniform number target_angle;

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