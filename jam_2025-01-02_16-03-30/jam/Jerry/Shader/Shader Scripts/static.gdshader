shader_type canvas_item;

uniform sampler2D gradient_texture;   // Gradient texture for nebula colors
uniform sampler2D noise_texture;      // Noise texture for nebula and stars
uniform float glow_intensity = 0.5;   // Glow strength for nebula
uniform float distortion_intensity = 0.02; // Nebula distortion strength
uniform float star_density = 0.3;     // Density of stars (higher = more stars)
uniform float star_brightness = 1.5;  // Brightness of stars
uniform float blink_speed = 1.0;      // Speed of star blinking
uniform float speed_factor = 0.5;     // Speed of nebula animation
uniform float drift_speed = 0.01;     // Speed of random star movement
uniform float glitch_intensity = 0.005; // Strength of glitch effect
uniform float glitch_chance = 0.1;    // Probability of a glitch (lower = rarer)

// New uniform for scaling the noise texture
uniform float noise_scale = 1.0;      // Scale factor for noise texture (1.0 = default size)

// Random function using fractals and sine
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV;

    // Time-based distortion for dynamic nebula movement
    float time = TIME * speed_factor;

    // Scale UV coordinates for the noise texture
    // This will enlarge or shrink the noise features
    // The bigger the noise_scale, the "zoom out" effect you’ll get
    vec2 scaled_uv = uv * noise_scale;

    // Random star drift using noise texture (using scaled_uv)
    // to create a sense of larger or smaller noise patterns
    vec2 drift_offset = texture(noise_texture, scaled_uv * 2.0).rg * 2.0 - 1.0; // Map to [-1, 1]
    drift_offset *= drift_speed * time; // Scale by drift speed and time
    vec2 star_uv = uv + drift_offset;

    // Random glitch trigger
    float glitch_trigger = random(vec2(time, uv.y)) < glitch_chance ? 1.0 : 0.0;
    vec2 glitch_offset = glitch_trigger * vec2(random(uv + time) - 0.5) * glitch_intensity;

    // Apply glitch offset
    vec2 glitch_uv = uv + glitch_offset;

    // Sample noise texture for nebula distortion (again using scaled UVs)
    vec4 nebula_noise = texture(noise_texture, glitch_uv * 2.0 * noise_scale);
    vec2 nebula_uv = glitch_uv + nebula_noise.rg * distortion_intensity;

    // Nebula base color from gradient texture
    vec4 nebula_color = texture(gradient_texture, vec2(fract(nebula_uv.x + time * 0.1), 0.5));
    nebula_color *= glow_intensity;

    // Starfield creation
    // We'll keep star sampling less scaled or unscaled to differentiate from the nebula
    // but you can also apply noise_scale if desired
    vec4 star_noise = texture(noise_texture, star_uv * 5.0 * noise_scale); // Sample noise for stars
    float star_threshold = 0.9 - star_density; // Threshold for stars
    float star_mask = step(star_threshold, star_noise.r); // Bright stars threshold

    // Randomized blinking effect
    float blink_random = random(vec2(star_noise.r, time));
    float blink = abs(sin(time * blink_speed + blink_random * 10.0)); // Blinking effect with randomness

    vec4 star_color = vec4(vec3(star_mask * blink * star_brightness), star_mask * blink); // Blinking stars

    // Glitch color shift to grey and dark blue
    vec4 glitch_color = vec4(0.2, 0.2, 0.2, 1.0) * glitch_trigger // Grey
                      + vec4(0.1, 0.1, 0.3, 1.0) * glitch_trigger; // Dark Blue

    // Combine nebula and stars with glitch effect
    vec4 final_color = mix(nebula_color + star_color, glitch_color, glitch_trigger);

    // Output the final color, clamped to avoid overflow
    COLOR = clamp(final_color, 0.0, 1.0);
}
