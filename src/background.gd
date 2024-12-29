extends Sprite2D

func _ready():
	# Ensure the node has a ShaderMaterial
	if not material or not (material is ShaderMaterial):
		var shader = preload("res://src/flicker.gdshader") # Adjust the path if necessary
		var shader_material = ShaderMaterial.new()
		shader_material.shader = shader
		material = shader_material
		print("ShaderMaterial created and assigned.")
	
	# Load and assign the noise texture
	var noise_texture = preload("res://Shader/Techno_13-512x512.png") # Ensure the path is correct
	if noise_texture is Texture:
		material.set_shader_parameter("noise_texture", noise_texture)
		print("Noise texture loaded successfully.")
	else:
		print("Error: Noise texture not valid.")

func _process(delta):
	if material is ShaderMaterial:
		# Get mouse position and viewport size
		var mouse_pos = get_viewport().get_mouse_position()
		var screen_size_i = get_viewport().size  # This returns Vector2i
		var screen_size = Vector2(screen_size_i.x, screen_size_i.y)  # Convert to Vector2

		# Normalize mouse position
		var normalized_pos = mouse_pos / screen_size
		normalized_pos.x = clamp(normalized_pos.x, 0.0, 1.0)
		normalized_pos.y = clamp(normalized_pos.y, 0.0, 1.0)

		# Update shader parameters
		material.set_shader_parameter("effect_position", normalized_pos)
		material.set_shader_parameter("effect_radius", 0.2) # Adjust radius as needed
		material.set_shader_parameter("glow_intensity", 0.15) # Adjust glow intensity as needed
		material.set_shader_parameter("screen_size", screen_size)

		# Debug output
		# Uncomment the following line to see normalized effect position in the output
		# print("Normalized Effect Position: ", normalized_pos)
	else:
		print("Error: Material is not a ShaderMaterial.")
