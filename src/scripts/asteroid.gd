extends Area2D
class_name Asteroid

@export_file("*tscn") var asteroid_scene: String
@export var timer: Timer
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

var size: int
var velocity: Vector2
var angular_velocity: float

func _ready() -> void:
	match size:
		0: # big
			animation_player.play("big")
		1: # medium
			animation_player.play("medium")
		2: # small
			animation_player.play("small")
	
	timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
	position += velocity * delta
	rotation += angular_velocity * delta

func spawn_smaller_asteroids() -> void:
	if size >= 2: # Don't spawn if already smallest
		return
		
	# Spawn two smaller asteroids
	for i in range(2):
		var new_asteroid: Asteroid = load(asteroid_scene).instantiate()
		new_asteroid.size = size + 1 # Make it one size smaller

		get_parent().add_child(new_asteroid)
		new_asteroid.position = position
		
		# Random direction with some spread
		var random_angle = randf_range(0, PI * 2)
		var direction = Vector2.RIGHT.rotated(random_angle)
		
		# Faster speed for smaller asteroids
		var base_speed = 50.0 + (new_asteroid.size * 50.0)
		var speed = randf_range(base_speed, base_speed + 50.0)
		new_asteroid.velocity = direction * speed
		
		# Random rotation
		new_asteroid.rotation = randf_range(0, PI * 2)
		var min_angular_speed = PI / 4.0
		var base_angular_speed = PI / 2.0
		var final_speed = base_angular_speed * (new_asteroid.size + 1)
		new_asteroid.angular_velocity = (min_angular_speed + randf() * (final_speed - min_angular_speed)) * (-1 if randf() > 0.5 else 1)
