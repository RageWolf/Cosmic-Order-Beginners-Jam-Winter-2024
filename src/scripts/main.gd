# res://Scripts/ShaderManager.gd
extends Node  # Choosing Node since we'll attach this script to a scene node

# Enum definitions for shader types, noise types, and rune types
enum ShaderType {
	FLICKER,
	STATIC,
	UI,
	UNDER_DEV_1,
	UNDER_DEV_2
}

enum NoiseType {
	SIMPLEX,
	PERLIN,
	VORONOI,
	FBM
}

enum RuneType {
	BASIC,
	ELDER,
	ARCANE,
	SHADOW
}

# Paths to resource folders
const SHADER_FOLDER = "res://Jerry/Shaders/"
const NOISE_TEXTURE_FOLDER = "res://Textures/Noise/"
const RUNE_TEXTURE_FOLDER = "res://Textures/Runes/"

# Dictionaries to store loaded resources
var shaders = {}
var noise_textures = {}
var rune_textures = {}

# Preloading Main menu scene
@onready var menu_scene : PackedScene = preload("res://src/main_menu.tscn")

func _ready():
	load_shaders()
	load_noise_textures()
	load_rune_textures()
	self.add_child(menu_scene.instantiate())
	
# Function to load shaders from the Shaders folder
func load_shaders():
	var dir = DirAccess.open(SHADER_FOLDER)
	
	if (dir == null):
		return
	
	if dir.error != OK:
		push_error("Failed to open shader folder: " + SHADER_FOLDER)
		return
	
	dir.list_dir_begin()  # Exclude hidden files, sorted
	var file_name = dir.get_next()
	while file_name:
		if file_name.ends_with(".gdshader"):
			var shader_path = SHADER_FOLDER + file_name
			var shader = load(shader_path)
			if shader:
				# Map the shader based on filename (you can customize this mapping)
				var key = file_name.strip_suffix(".gdshader").to_upper().replace("-", "_")
				if ShaderType.has(key):
					shaders[ShaderType[key]] = shader
				else:
					push_warning("Shader type for '" + key + "' not defined in ShaderType enum.")
			else:
				push_error("Failed to load shader: " + shader_path)
		file_name = dir.get_next()
	dir.list_dir_end()

# Function to load noise textures from the Noise folder
func load_noise_textures():
	var dir = DirAccess.open(NOISE_TEXTURE_FOLDER)
	
	if (dir == null):
		return
	
	if dir.error != OK:
		push_error("Failed to open noise texture folder: " + NOISE_TEXTURE_FOLDER)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	if (dir == null):
		return
	
	while file_name:
		if file_name.endswith(".png") or file_name.endswith(".jpg") or file_name.endswith(".jpeg"):
			var texture_path = NOISE_TEXTURE_FOLDER + file_name
			var texture = load(texture_path)
			if texture:
				var key = file_name.strip_suffix(".png").strip_suffix(".jpg").strip_suffix(".jpeg").to_upper().replace("-", "_")
				if NoiseType.has(key):
					noise_textures[NoiseType[key]] = texture
				else:
					push_warning("Noise type for '" + key + "' not defined in NoiseType enum.")
			else:
				push_error("Failed to load noise texture: " + texture_path)
		file_name = dir.get_next()
	dir.list_dir_end()

# Function to load rune textures from the Runes folder
func load_rune_textures():
	var dir = DirAccess.open(RUNE_TEXTURE_FOLDER)
	
	if (dir == null):
		return
	
	if dir.error != OK:
		push_error("Failed to open rune texture folder: " + RUNE_TEXTURE_FOLDER)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name:
		if file_name.endswith(".png") or file_name.endswith(".jpg") or file_name.endswith(".jpeg"):
			var texture_path = RUNE_TEXTURE_FOLDER + file_name
			var texture = load(texture_path)
			if texture:
				var key = file_name.strip_suffix(".png").strip_suffix(".jpg").strip_suffix(".jpeg").to_upper().replace("-", "_")
				if RuneType.has(key):
					rune_textures[RuneType[key]] = texture
				else:
					push_warning("Rune type for '" + key + "' not defined in RuneType enum.")
			else:
				push_error("Failed to load rune texture: " + texture_path)
		file_name = dir.get_next()
	dir.list_dir_end()

# Getter functions
func get_shader(shader_type: ShaderType) -> Shader:
	if shaders.has(shader_type):
		return shaders[shader_type]
	else:
		push_error("Shader of type '" + str(shader_type) + "' not found.")
		return null

func get_noise_texture(noise_type: NoiseType) -> Texture:
	if noise_textures.has(noise_type):
		return noise_textures[noise_type]
	else:
		push_error("Noise texture of type '" + str(noise_type) + "' not found.")
		return null

func get_rune_texture(rune_type: RuneType) -> Texture:
	if rune_textures.has(rune_type):
		return rune_textures[rune_type]
	else:
		push_error("Rune texture of type '" + str(rune_type) + "' not found.")
		return null
