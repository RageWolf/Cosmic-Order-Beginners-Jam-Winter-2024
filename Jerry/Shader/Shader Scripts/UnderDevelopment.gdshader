shader_type canvas_item;

uniform vec2 effect_position = vec2(0.5, 0.5); // Center of the effect (normalized coordinates)
uniform float effect_radius = 0.2; // Radius of the effect

void fragment() {
    vec4 base_color = texture(TEXTURE, UV); // Base texture
    vec4 noise_color = vec4(1.0, 0.0, 0.0, 1.0); // Example effect color (red)

    // Calculate distance from the center
    float dist = length(SCREEN_UV - effect_position);

    // Create a circular mask
    float mask = step(effect_radius, dist); // 1.0 outside the radius, 0.0 inside

    // Apply the mask: only show the effect inside the radius
    COLOR = mix(noise_color, base_color, mask);
}
