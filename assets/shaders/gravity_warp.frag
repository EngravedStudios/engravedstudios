#include <flutter/runtime_effect.glsl>

// Inputs from Flutter
uniform vec2 uSize;        // Screen size
uniform vec2 uCenter;      // Click position (origin of warp)
uniform float uProgress;   // Animation progress 0.0 to 1.0
uniform float uDirection;  // 1.0 for expand/explosion, -1.0 for implode
uniform sampler2D uTexture; // Screen capture

out vec4 fragColor;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
    vec2 uv = fragCoord / uSize;
    
    // Vector from center to current pixel
    vec2 toPixel = fragCoord - uCenter;
    float dist = length(toPixel);
    
    // Calculate wave radius (expands over time)
    float maxRadius = length(uSize) * 1.2;
    float waveRadius = uProgress * maxRadius;
    
    // Wave parameters
    float waveWidth = 150.0;
    float waveCenter = waveRadius;
    
    // Distance from the expanding wave front
    float distFromWave = abs(dist - waveCenter);
    
    // Warp strength falls off from wave center
    float warpAmount = 0.0;
    if (distFromWave < waveWidth) {
        // Stronger warp at wave front, falls off
        float t = 1.0 - (distFromWave / waveWidth);
        // Smooth falloff with sine curve
        warpAmount = sin(t * 3.14159 * 0.5) * 80.0;
        // Reduce strength as wave expands
        warpAmount *= (1.0 - uProgress * 0.7);
    }
    
    // Direction of warp (outward for explosion, inward for implosion)
    vec2 warpDir = normalize(toPixel + vec2(0.001)); // Avoid div by zero
    
    // Apply warp offset to UV
    vec2 offset = warpDir * warpAmount * uDirection / uSize;
    vec2 warpedUV = uv - offset;
    
    // Clamp to valid UV range
    warpedUV = clamp(warpedUV, 0.0, 1.0);
    
    // Sample the texture with warped coordinates
    vec4 color = texture(uTexture, warpedUV);
    
    // Optional: Add a subtle glow at wave front
    float glowIntensity = 0.0;
    if (distFromWave < waveWidth * 0.3) {
        glowIntensity = (1.0 - distFromWave / (waveWidth * 0.3)) * 0.3 * (1.0 - uProgress);
    }
    
    // Mix glow color (using a bright accent)
    vec3 glowColor = vec3(0.8, 1.0, 0.2); // Neon lime-ish
    color.rgb = mix(color.rgb, glowColor, glowIntensity);
    
    fragColor = color;
}
