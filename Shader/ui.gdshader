shader_type canvas_item;

uniform vec4 glow_color= vec4(1.0, 0.5, 0.0, 1.0); // Color of the glow and particles
uniform float glow_thickness = 0.05; // Thickness of the glow in UV space (0.0 to 0.5)
uniform float glow_intensity = 0.5; // Intensity of the glow (0.0 to 1.0)
uniform float particle_size = 0.02; // Size of each particle in UV space
uniform float particle_speed = 1.0; // Speed of the particle animation
uniform int particle_count = 5; // Number of particles along the edge

void fragment() {
    // Sample the original texture color
    vec4 original_color = texture(TEXTURE, UV);
    
    // Calculate the distance to the nearest edge
    float dist_left = UV.x;
    float dist_right = 1.0 - UV.x;
    float dist_top = UV.y;
    float dist_bottom = 1.0 - UV.y;
    float border_dist = min(min(dist_left, dist_right), min(dist_top, dist_bottom));
    
    // Create a smooth mask for the glow near the edges
    float glow_mask = smoothstep(glow_thickness, glow_thickness - 0.02, border_dist) * glow_intensity;
    
    // Initialize particle effect
    float particle = 0.0;
    
    // Time-based animation
    float time = TIME * particle_speed;
    
    // Loop through each particle
    for(int i = 0; i < 20; i++) { // Limit to 20 to prevent performance issues
        if(i >= particle_count) break;
        float phase = float(i) / float(particle_count);
        float position = fract(time + phase) * 4.0; // Total perimeter is 4.0 units (each side is 1.0)
        vec2 particle_uv;
        
        // Determine particle position based on current_phase
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
        
        // Calculate distance to the particle position
        float distance_to_particle = distance(UV, particle_uv);
        
        // Create a soft particle effect based on distance
        float particle_effect = smoothstep(particle_size, particle_size - 0.005, distance_to_particle);
        
        // Accumulate particle effects
        particle += particle_effect;
    }
    
    // Ensure particle intensity is within [0,1]
    particle = clamp(particle, 0.0, 1.0);
    
    // Create particle color (bright spots along the edges)
    vec4 particle_color = vec4(glow_color.rgb * (1.0 - particle), 1.0) * glow_mask;
    
    // Create the glow color based on the mask
    vec4 glow_effect = vec4(glow_color.rgb * glow_mask, glow_mask);
    
    // Combine glow and particle effects
    vec4 combined_effect = glow_effect + particle_color;
    
    // Blend the combined effect with the original color
    vec4 final_color = mix(original_color, combined_effect, glow_mask);
    
    // Output the final color
    COLOR = clamp(final_color, 0.0, 1.0);
}
