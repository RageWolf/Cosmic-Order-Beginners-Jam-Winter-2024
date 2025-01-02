@tool
extends Control
class_name Star_Shader  # This Shader Node has 
  
# Define Shader Parameters Enum
enum ShaderParams {
	Idle,
	Warp,
	# Add more shader parameter sets here as needed
}
### This is the Game State Enum to change the Shader Peramiters dynamicly. 
enum GameState {
	Idle,
	Warp,
	# Add more game states as needed
}

# Current Game State with setter
var current_game_state: GameState = GameState.Idle

# Export This Property alows you to change the differant Shader 
#Peramiters from Warp to Idle with a Drop Down selection
@export var selected_shader_parameters: ShaderParams = ShaderParams.Idle

# Preload shader parameter resources 
var params_dictionary: Dictionary = {
	ShaderParams.Idle: preload("res://Jerry/Shader_Peramiters/Star_Shader_Parameters/idle_star_peramiters.tres"),
	ShaderParams.Warp: preload("res://Jerry/Shader_Peramiters/Star_Shader_Parameters/warp_star_parameters.tres"),
	# Add more shader parameter sets here as needed
}

@export var shader_material: ShaderMaterial = null

# Private backing variable for selected_shader_parameters
var _selected_shader_parameters: ShaderParams = ShaderParams.Idle

# Private backing variable for current_game_state
var _current_game_state: GameState = GameState.Idle

func _ready():
	print("[_ready] Initial selected_shader_parameters: %s" % selected_shader_parameters)
	
	# Verify ShaderMaterial is assigned
	if shader_material:
		print("[_ready] ShaderMaterial assigned via Inspector: ", shader_material)
		print("[_ready] ShaderMaterial shader: ", shader_material.shader)
		load_shader_parameters()
	else:
		push_error("ShaderMaterial is not assigned in the Inspector.")
		
# Setter for selected_shader_parameters to handle changes
func set_selected_shader_parameters(value: ShaderParams) -> void:
	print("[set_selected_shader_parameters] Called with value: %s" % value)
	if params_dictionary.has(value):
		_selected_shader_parameters = value
		print("[set_selected_shader_parameters] _selected_shader_parameters set to: %s" % _selected_shader_parameters)
		load_shader_parameters()
	else:
		push_error("Invalid shader parameter selection: %s." % value)

# Getter for selected_shader_parameters
func get_selected_shader_parameters() -> ShaderParams:
	return _selected_shader_parameters

# Setter for game state
func set_game_state(state: GameState) -> void:
	if state != _current_game_state:
		_current_game_state = state
		print("[set_game_state] Game state changed to: %s" % _current_game_state)
		update_shader_parameters_based_on_state()
	else:
		print("[set_game_state] Game state remains: %s" % _current_game_state)

# Getter for game state (optional)
func get_game_state() -> GameState:
	return _current_game_state

# Function to map game states to shader parameters
func update_shader_parameters_based_on_state():
	match _current_game_state:
		GameState.Idle:
			set_selected_shader_parameters(ShaderParams.Idle)
		GameState.Warp:
			set_selected_shader_parameters(ShaderParams.Warp)
		# Handle more states as needed
		_:
			push_error("Unhandled game state: %s" % _current_game_state)

# Function to apply shader parameters to the ShaderMaterial
func load_shader_parameters():
	print("[load_shader_parameters] Loading parameters for: %s" % selected_shader_parameters)
	var params = params_dictionary.get(selected_shader_parameters, null)
	
	if params:
		print("[load_shader_parameters] Parameters loaded: %s" % params)
		if shader_material:
			# Set each uniform individually
			shader_material.set_shader_param("screen_size", params.screen_size)
			shader_material.set_shader_param("star_texture", params.star_texture)
			shader_material.set_shader_param("base_blink_speed", params.base_blink_speed)
			shader_material.set_shader_param("base_glow_intensity", params.base_glow_intensity)
			shader_material.set_shader_param("star_density", params.star_density)
			shader_material.set_shader_param("scroll_speed", params.scroll_speed)
			shader_material.set_shader_param("randomness_seed", params.randomness_seed)
			shader_material.set_shader_param("min_blink_speed", params.min_blink_speed)
			shader_material.set_shader_param("max_blink_speed", params.max_blink_speed)
			print("[load_shader_parameters] Shader parameters applied to ShaderMaterial.")
		else:
			push_error("ShaderMaterial reference is null.")
	else:
		push_error("Failed to load parameters for: %s." % selected_shader_parameters)
		
		


func _on_test_world_game_state_changed(new_state: Variant) -> void:
	set_game_state(GameState.Warp)
