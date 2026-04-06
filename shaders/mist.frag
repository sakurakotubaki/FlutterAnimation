#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;

out vec4 fragColor;

// ---------------------------------------------------------------------------
// Noise — gradient noise with per-octave rotation for organic feel
// ---------------------------------------------------------------------------

vec2 hash2(vec2 p) {
  p = vec2(dot(p, vec2(127.1, 311.7)),
           dot(p, vec2(269.5, 183.3)));
  return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float gradientNoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);

  float a = dot(hash2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0));
  float b = dot(hash2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
  float c = dot(hash2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
  float d = dot(hash2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));

  return mix(mix(a, b, u.x), mix(c, d, u.x), u.y) + 0.5;
}

// fbm — octave ごとに座標を回転させて格子の直線感を消す
float fbm(vec2 p) {
  float value = 0.0;
  float amp   = 0.5;
  // cos(0.5), sin(0.5) ≈ 0.8776, 0.4794
  mat2 rot = mat2(0.8776, 0.4794, -0.4794, 0.8776);

  for (int i = 0; i < 6; i++) {
    value += amp * gradientNoise(p);
    p = rot * p * 2.0 + vec2(1.7, 9.2);
    amp *= 0.5;
  }
  return value;
}

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  float t = uTime;

  // --- Layer 1: 大きくゆっくり流れる背景霞 ---
  vec2 p1 = uv * 2.5 + vec2(t * 0.08, t * 0.015);
  float layer1 = fbm(p1);

  // --- Layer 2: 中スケールの主要ミスト ---
  vec2 p2 = uv * 4.5 + vec2(-t * 0.06, t * 0.035);
  float layer2 = fbm(p2);

  // --- Layer 3: 細かい霧の筋 ---
  vec2 p3 = uv * 8.0 + vec2(t * 0.1, -t * 0.025);
  float layer3 = fbm(p3);

  // レイヤー合成
  float mist = layer1 * 0.50 + layer2 * 0.35 + layer3 * 0.15;

  // コントラスト強調
  mist = smoothstep(0.25, 0.75, mist);

  // 下半分に厚く溜まる（霧は低い場所に溜まる）
  float heightWeight = smoothstep(0.0, 0.65, 1.0 - uv.y);
  mist *= mix(0.25, 1.0, heightWeight);

  // 画面端をフェードアウト
  float edgeFade = smoothstep(0.0, 0.12, uv.x)
                 * smoothstep(1.0, 0.88, uv.x)
                 * smoothstep(0.0, 0.08, uv.y)
                 * smoothstep(1.0, 0.92, uv.y);
  mist *= edgeFade;

  // 色：奥は青みがかった冷色、手前は暖色寄りの白
  vec3 coolTint = vec3(0.72, 0.80, 0.92);
  vec3 warmTint = vec3(0.92, 0.90, 0.87);
  vec3 color = mix(coolTint, warmTint, layer2);

  float alpha = mist * 0.75;

  fragColor = vec4(color * alpha, alpha);
}
