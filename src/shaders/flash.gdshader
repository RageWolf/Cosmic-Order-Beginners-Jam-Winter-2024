shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 mask = texture(TEXTURE, UV);
	mask.rgb = mix(mask.rgb, flash_color.rgb, flash_modifier);
	mask.a *= alpha;
	COLOR = mask;
}