shader_type canvas_item;

// Uniforms for overall control
uniform vec2 screen_size = vec2(640.0, 480.0); // Screen size
uniform float base_blink_speed : hint_range(0.1, 5.0) = 1.0; // Base blink speed
uniform float base_glow_intensity : hint_range(0.1, 2.0) = 1.7; // Base glow intensity
uniform float star_density : hint_range(0.0, 1.0) = 0.8; // Star density
uniform vec2 scroll_speed = vec2(-1.0, 0.5); // Scrolling speed
uniform float randomness_seed : hint_range(0.0, 1000.0) = 1.0; // Seed for random variations
uniform float deceleration : hint_range(0.0, 1.0) = .002; // Deceleration factor

void fragment() {
    // Decelerate scrolling speed
    vec2 effective_scroll_speed = scroll_speed * deceleration;

    // Normalized UV coordinates with decelerated scrolling
    vec2 uv = FRAGCOORD.xy / screen_size;
    vec2 scroll_uv = uv + (TIME * effective_scroll_speed);

    // Generate random seed based on position
    float noise_value = fract(sin(dot(scroll_uv * 100.0, vec2(12.9898, 78.233) * randomness_seed)) * 43758.5453);

    // Only render stars if the noise value is below the star density
    if (noise_value < star_density) {
        // Randomize star position
        vec2 random_offset = vec2(
            fract(sin(dot(scroll_uv, vec2(34.123, 78.456))) * 23456.0),
            fract(cos(dot(scroll_uv, vec2(12.789, 45.678))) * 98765.0)
        );
        vec2 star_pos = fract(scroll_uv + random_offset);

        // Star glow calculation
        float distance_to_star = length(uv - star_pos);
        float glow = smoothstep(0.15, 0.0, distance_to_star) * base_glow_intensity;

        // Blink effect with randomness
        float blink = 0.5 + 0.5 * sin(TIME * base_blink_speed * noise_value * 10.0);

        // Final star color with intensity
        vec3 star_color = vec3(1.0);
        COLOR = vec4(star_color * glow * blink, 1.0);
    } else {
        // Default background color (space)
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
