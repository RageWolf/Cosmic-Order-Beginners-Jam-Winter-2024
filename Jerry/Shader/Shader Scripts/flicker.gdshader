shader_type canvas_item;

uniform sampler2D noise_texture; // Noise texture
uniform vec4 base_color = vec4(0.05, 0.05, 0.1, 1.0); // Base dark color
uniform float glow_intensity = 0.15; // Strength of the glow
uniform float distortion_strength = 0.02; // Strength of distortion
uniform float flicker_speed = 3.0; // Speed of the flickering effect
uniform float noise_scale = 1.5; // Scale of the noise texture
uniform vec2 scroll_speed = vec2(0.1, 0.0); // Speed of scrolling patterns
uniform float distortion_frequency = 20.0; // Frequency of angular distortion
uniform vec2 effect_position = vec2(0.5, 0.5); // Mouse position normalized (0.0 to 1.0)
uniform float effect_radius = 0.2; // Radius of the effect area
uniform float fade_radius = 0.4; // Distance at which the fade-out ends

// Random function for angular distortion
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Original texture color
    vec4 original_color = texture(TEXTURE, UV);

    // Compute the distance from the current pixel to the effect center
    float dist_from_center = length(SCREEN_UV - effect_position);

    // Smooth fade based on distance
    float fade = smoothstep(effect_radius, fade_radius, dist_from_center);

    // Stretch and scroll the noise texture
    vec2 noise_uv = fract(SCREEN_UV * noise_scale + TIME * scroll_speed); // Ensure noise texture repeats
    float noise_value = texture(noise_texture, noise_uv).r;

    // Generate angular distortion
    vec2 distortion = vec2(
        random(UV * distortion_frequency) * distortion_strength,
        random(UV.yx * distortion_frequency) * distortion_strength
    );

    // Apply distortion and repeat UV coordinates
    vec2 distorted_uv = fract(UV + distortion); // Ensure the texture wraps around

    // Sample the texture with angular distorted UVs
    vec4 distorted_color = texture(TEXTURE, distorted_uv);

    // Glow effect based on UV distance from center
    float glow = 1.0 - dist_from_center * glow_intensity;
    glow = clamp(glow, 0.0, 1.0);

    // Flickering effect
    float flicker = sin(TIME * flicker_speed) * 0.5 + 0.5;

    // Combine effects
    vec4 glow_effect = vec4(base_color.rgb * glow, 1.0);
    vec4 final_color = mix(distorted_color, base_color, noise_value * flicker);

    // Blend the glow on top
    final_color.rgb += glow_effect.rgb * glow;

    // Apply the fade to the alpha channel
    final_color.a = 1.0 - fade;

    // Final output
    COLOR = mix(original_color, final_color, final_color.a);
}
