#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    // Simple plasma/nebula effect
    float t = uTime * 0.5;
    vec2 p = uv * 2.0 - 1.0;
    
    vec3 color = vec3(0.0);
    
    // Create some layers
    for(float i=1.0; i<4.0; i++) {
        p.x += 0.3/i * sin(i * 3.0 * p.y + t);
        p.y += 0.3/i * cos(i * 3.0 * p.x + t);
        float f = length(p);
        color += vec3(0.1/f, 0.05/f, 0.2/f); // Purple/Blue tint
    }
    
    // Darken and Clamp
    color = clamp(color, 0.0, 1.0);
    color *= 0.8; // Dim it down for background usage
    
    fragColor = vec4(color, 1.0);
}
