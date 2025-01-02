shader_type canvas_item;

uniform sampler2D texture;
uniform vec4 base_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float pulse_speed : hint_range(0.1, 10.0) = 2.0;
uniform float pulse_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Sample the texture color
    vec4 tex_color = texture(TEXTURE, UV);

    // Calculate the pulse effect
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5; // Range: 0 to 1
    float intensity = mix(1.0, 1.0 + pulse_intensity, pulse);

    // Apply the base color and pulse effect to the texture
    COLOR = tex_color * base_color * vec4(intensity, intensity, intensity, 1.0);
}

