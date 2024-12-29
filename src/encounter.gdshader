shader_type canvas_item;

uniform vec4 glow_color= vec4(0.0, 1.0, 1.0, 1.0); // Color of the glow
uniform float glow_intensity = 1.0; // Maximum intensity of the glow
uniform float pulse_speed = 2.0; // Speed of the pulsing effect

void fragment() {
    // Get the original texture color
    vec4 original_color = texture(TEXTURE, UV);

    // Create a pulsating effect
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5; // Pulsates between 0.0 and 1.0

    // Apply glow effect
    vec4 glow_effect = vec4(glow_color.rgb * pulse * glow_intensity, glow_color.a * pulse);

    // Blend the glow effect with the original texture
    COLOR = original_color + glow_effect;
}
