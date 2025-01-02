shader_type canvas_item;

uniform int PAIR_COUNT = 10; // Number of twin pairs
uniform float MAX_SIZE = 10.0; // Maximum size of a star
uniform float TIME_SPEED = 1.0; // Speed of blinking

// Pseudo-random hash function
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// Pseudo-random 2D vector based on seed
vec2 rand2(float seed) {
    float x = hash(seed);
    float y = hash(seed + 1.0);
    return vec2(x, y);
}

void fragment() {
    // Use SCREEN_UV for normalized coordinates [0,1] across the screen
    vec2 uv = SCREEN_UV;
    vec3 color = vec3(0.0); // Initialize color

    // Iterate over each twin pair
    for(int i = 0; i < 100; i++) { // Increased loop limit for flexibility
        if(i >= PAIR_COUNT) break; // Ensure we only process PAIR_COUNT pairs

        float seed = float(i) * 10.0;

        // Generate positions for twin stars
        vec2 pos1 = rand2(seed);
        vec2 pos2 = rand2(seed + 100.0); // Different seed for second star

        // Generate sizes
        float size1 = hash(seed + 200.0) * MAX_SIZE;
        float size2 = hash(seed + 300.0) * MAX_SIZE;

        // Generate blinking effect
        float time = TIME * TIME_SPEED;
        float blink1 = 0.5 + 0.5 * sin(time + seed);
        float blink2 = 0.5 + 0.5 * sin(time + seed + 3.1415); // Phase shift for variety

        // Calculate distance from current fragment to each star
        float dist1 = distance(uv, pos1);
        float dist2 = distance(uv, pos2);

        // Star intensity based on distance and size
        // Adjusted smoothstep parameters for better visual
        float star1 = smoothstep(size1 / SCREEN_PIXEL_SIZE.x, (size1 + 1.0) / SCREEN_PIXEL_SIZE.x, size1 / SCREEN_PIXEL_SIZE.x - dist1);
        float star2 = smoothstep(size2 / SCREEN_PIXEL_SIZE.x, (size2 + 1.0) / SCREEN_PIXEL_SIZE.x, size2 / SCREEN_PIXEL_SIZE.x - dist2);

        // Accumulate star colors with blinking
        color += vec3(blink1 * star1) + vec3(blink2 * star2);

        // Draw line between twins
        vec2 dir = pos2 - pos1;
        float line_length = length(dir);
        float line_width = 1.0 / SCREEN_PIXEL_SIZE.x; // Line width in normalized coordinates

        // Project fragment position onto the line
        float projection = clamp(dot(uv - pos1, dir) / (line_length * line_length), 0.0, 1.0);
        vec2 closest = pos1 + projection * dir;
        float line_dist = distance(uv, closest);

        // Line intensity
        float line = smoothstep(line_width, 0.0, line_dist);

        // Optionally, modulate line brightness based on star brightness
        color += vec3(line * 0.5); // Adjust line brightness here
    }

    // Final color with background
    vec3 final_color = vec3(0.0) + color;
    COLOR = vec4(final_color, 1.0);
}
