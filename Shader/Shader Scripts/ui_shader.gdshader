shader_type canvas_item;

// Uniforms for glow and particles
uniform float glow_thickness = 0.05; // Thickness of the primary glow
uniform float glow_intensity = 1.0; // Intensity of the glow
uniform float particle_size = 0.02; // Base size of each particle
uniform float particle_speed = 1.0; // Base speed of particle movement
uniform int particle_count = 10; // Number of particles
uniform float color_pulse_speed = 2.0; // Speed of color pulsing
uniform float flicker_speed = 3.0; // Speed of glow flickering
uniform sampler2D noise_texture; // High-quality noise texture
uniform sampler2D rune_texture; // Rune symbols texture
uniform bool use_runes = true; // Toggle rune integration
uniform bool is_hovered = false; // Indicates if the panel is hovered
uniform bool is_clicked = false; // Indicates if the panel is clicked

// Adjusted scaling factor for larger runes
uniform float scaling_factor = 2.0; // Reduced from 5.0 to make runes larger

// Function to generate a pseudo-random number based on a seed
float random(vec2 seed) {
    return fract(sin(dot(seed, vec2(12.9898, 78.233))) * 43758.5453);
}

// Function to interpolate between the provided color palette
vec3 get_color(float t) {
    // Define the number of segments
    int segments = 5;
    float segment_length = 1.0 / float(segments);
    
    // Ensure t wraps around [0,1]
    t = fract(t);
    
    // Determine the current segment
    float segment_float = t / segment_length;
    int segment = int(floor(segment_float));
    float local_t = fract(segment_float);
    
    // Define the colors (Normalized RGB)
    vec3 color0 = vec3(0.678, 0.761, 0.984); // adc2fb
    vec3 color1 = vec3(0.506, 0.584, 0.867); // 8195de
    vec3 color2 = vec3(0.373, 0.424, 0.678); // 5f6cad
    vec3 color3 = vec3(0.270, 0.306, 0.494); // 454e7e
    vec3 color4 = vec3(0.282, 0.361, 0.302); // 485c4d
    vec3 color5 = vec3(0.573, 0.627, 0.651); // 92a0a6
    
    // Interpolate between the colors based on the segment
    if(segment == 0){
        return mix(color0, color1, local_t);
    }
    else if(segment == 1){
        return mix(color1, color2, local_t);
    }
    else if(segment == 2){
        return mix(color2, color3, local_t);
    }
    else if(segment == 3){
        return mix(color3, color4, local_t);
    }
    else{
        return mix(color4, color5, local_t);
    }
}

void fragment() {
    // Sample the original texture (should be transparent)
    vec4 original_color = texture(TEXTURE, UV);
    
    // Color pulsing
    float hue = mod(TIME * 0.05, 1.0);
    vec3 rotated_color = get_color(hue);
    
    // Distortion
    vec2 noise_uv = UV * 10.0;
    float noise_value = texture(noise_texture, noise_uv + TIME * 0.1).r;
    vec2 distortion = vec2(noise_value * 0.005, noise_value * 0.005);
    vec2 distorted_UV = UV + distortion;
    
    // Distance from edges
    float dist_left = distorted_UV.x;
    float dist_right = 1.0 - distorted_UV.x;
    float dist_top = distorted_UV.y;
    float dist_bottom = 1.0 - distorted_UV.y;
    float border_dist = min(min(dist_left, dist_right), min(dist_top, dist_bottom));
    
    // Glow mask with flicker
    float flicker = 0.8 + 0.2 * sin(TIME * flicker_speed);
    float glow_mask = smoothstep(glow_thickness, glow_thickness - 0.05, border_dist) * glow_intensity * flicker;
    
    // Rune integration
    if(use_runes){
        vec4 rune_sample = texture(rune_texture, UV * scaling_factor);
        float rune_alpha = rune_sample.a; // Use alpha channel
        glow_mask *= rune_alpha; // Modulate glow_mask with rune presence
        
        // Blend rune color with pulsed color
        vec3 rune_color = rune_sample.rgb;
        rotated_color = mix(rotated_color, rune_color, rune_alpha);
        
        // Interactive effect: Change color on click
        if(is_clicked){
            rotated_color = vec3(1.0, 0.0, 0.0); // Example: Red on click
        }
        
        // Enhance glow intensity on hover
        if(is_hovered){
            glow_mask *= 1.2; // Increase glow intensity by 20%
        }
    }
    
    // Initialize particle effect
    float particle = 0.0;
    
    // Loop through each particle layer for enhanced smoothness
    for(int layer = 0; layer < 2; layer++) { // particle_layers = 2
        float speed = particle_speed + float(layer) * 0.5;
        float size = particle_size + float(layer) * 0.005;
        
        float time_layer = TIME * speed;
        
        // Loop through each particle in the layer
        for(int i = 0; i < 20; i++) { // Limit to 20 to prevent performance issues
            if(i >= particle_count) break;
            float phase = float(i) / float(particle_count);
            float position = fract(time_layer + phase) * 4.0; // 4.0 perimeter units for square
            
            vec2 particle_uv;
            if(position < 1.0) {
                // Top edge: left to right
                particle_uv = vec2(position, 0.0);
            }
            else if(position < 2.0) {
                // Right edge: top to bottom
                particle_uv = vec2(1.0, position - 1.0);
            }
            else if(position < 3.0) {
                // Bottom edge: right to left
                particle_uv = vec2(3.0 - position, 1.0);
            }
            else {
                // Left edge: bottom to top
                particle_uv = vec2(0.0, 4.0 - position);
            }
            
            // Calculate distance to the particle position with distortion
            float distance_to_particle = distance(distorted_UV, particle_uv);
            
            // Randomize particle size and add variation
            float rand_val = random(vec2(float(i), TIME));
            float dynamic_particle_size = size + rand_val * 0.01; // Vary size slightly
            
            // Create a soft particle effect based on distance with smoother falloff
            float particle_effect = smoothstep(dynamic_particle_size + 0.005, dynamic_particle_size - 0.015, distance_to_particle);
            
            // Accumulate particle effects
            particle += particle_effect;
        }
    }
    
    // Ensure particle intensity is within [0,1]
    particle = clamp(particle, 0.0, 1.0);
    
    // Create pulsing color effect
    float pulse = 0.5 + 0.5 * sin(TIME * color_pulse_speed);
    vec3 pulsed_color = rotated_color * pulse;
    
    // Create particle color (bright spots)
    vec4 particle_color = vec4(pulsed_color * (1.0 - particle), glow_mask * pulse);
    
    // Create the glow color based on the mask
    vec4 glow_effect = vec4(pulsed_color * glow_mask, glow_mask);
    
    // Combine glow and particle effects
    vec4 combined = glow_effect + particle_color;
    
    // Apply ambient occlusion to darken edges slightly
    float ao = 1.0 - smoothstep(glow_thickness + 0.03, glow_thickness, border_dist);
    vec3 ambient = vec3(0.1) * ao;
    
    // Combine ambient occlusion
    combined.rgb += ambient;
    
    // Output the combined color with appropriate alpha
    float final_alpha = max(glow_mask, (1.0 - particle) * glow_mask);
    COLOR = vec4(combined.rgb, final_alpha);
}
