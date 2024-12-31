@tool
extends Resource
class_name Idle_Star_Parameters

# Base Resource Class for Shaders. Stores available parameters that can be changed and 
# presets can be stored for different states.

# Export Parameters
@export var screen_size: Vector2 = Vector2(640.0, 480.0)
@export var star_texture: Texture = preload("res://PNG/sa.png") # Update the path accordingly
@export var base_blink_speed: float = 1.0
@export var base_glow_intensity: float = 1.0
@export var star_density: float = 0.2
@export var scroll_speed: Vector2 = Vector2(-1.0, 0.2)
@export var randomness_seed: float = 0.5
@export var min_blink_speed: float = 0.5
@export var max_blink_speed: float = 2.0
