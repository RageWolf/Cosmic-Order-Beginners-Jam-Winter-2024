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
	
	# Set random speed between 100 and 200
	var speed = randf_range(100, 200)
	asteroid.velocity = direction * speed
	
	# Set random rotation
	asteroid.rotation = randf_range(0, PI * 2)
	asteroid.angular_velocity = randf_range(-PI, PI)