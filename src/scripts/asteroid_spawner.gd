extends Node
class_name AsteroidSpawner

@export var asteroid_scene: PackedScene
@export var spawn_rate: Timer

@onready var viewport_size: Vector2 = get_viewport().get_visible_rect().size
@onready var spawn_margin: float = 50.0

func _ready() -> void:
	spawn_rate.start()
	spawn_rate.timeout.connect(on_spawn_rate_timeout)

func on_spawn_rate_timeout() -> void:
	var asteroid: Asteroid = asteroid_scene.instantiate()
	asteroid.size = randi_range(0, 2)
	get_parent().add_child(asteroid)
	
	# Choose a random side (0: top, 1: right, 2: bottom, 3: left)
	var side = randi() % 4
	var spawn_pos = Vector2.ZERO
	
	match side:
		0: # Top
			spawn_pos = Vector2(randf_range(0, viewport_size.x), -spawn_margin)
		1: # Right
			spawn_pos = Vector2(viewport_size.x + spawn_margin, randf_range(0, viewport_size.y))
		2: # Bottom
			spawn_pos = Vector2(randf_range(0, viewport_size.x), viewport_size.y + spawn_margin)
		3: # Left
			spawn_pos = Vector2(-spawn_margin, randf_range(0, viewport_size.y))
	
	asteroid.position = spawn_pos
	
	
	# Calculate direction towards center with some randomness
	var direction = (viewport_size / 2 - spawn_pos).normalized()
	direction = direction.rotated(randf_range(-PI / 4, PI / 4))
	
	# Adjust speed based on size (smaller = faster)
	# size 0 (big): 50-100
	# size 1 (medium): 100-150
	# size 2 (small): 150-200
	var base_speed = 50.0 + (asteroid.size * 50.0)
	var speed = randf_range(base_speed, base_speed + 50.0)
	asteroid.velocity = direction * speed
	
	# Set random rotation, smaller asteroids rotate faster
	asteroid.rotation = randf_range(0, PI * 2)
	var min_angular_speed = PI / 4.0 # Minimum rotation speed
	var base_angular_speed = PI / 2.0 # Base rotation speed (big asteroids)
	var final_speed = base_angular_speed * (asteroid.size + 1)
	
	# Ensure rotation is at least min_angular_speed, but randomize direction
	asteroid.angular_velocity = (min_angular_speed + randf() * (final_speed - min_angular_speed)) * (-1 if randf() > 0.5 else 1)
