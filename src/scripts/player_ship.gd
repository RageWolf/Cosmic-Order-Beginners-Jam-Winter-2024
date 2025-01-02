extends RigidBody2D
class_name PlayerShip

@export var projectile_scene: PackedScene
@export var hit_detector: Area2D
@export var thrust_force: float = 100
@export var turn_speed: float = 100
@export var fire_rate: Timer

var turn_direction: float = 0
var can_shoot: bool

func _ready() -> void:
	can_shoot = true
	# Connect signal callbacks using Godot 4's syntax
	fire_rate.timeout.connect(_on_fire_rate_timeout)
#	hit_detector.area_entered.connect(_on_hit_detector_area_entered)


func _physics_process(delta: float) -> void:
	# 1. Use _physics_process instead of _process for physics-related code
	turn_direction = Input.get_axis("turn_right", "turn_left")
	apply_torque(turn_direction * turn_speed)

	if Input.is_action_pressed("thrust"):
		apply_central_force(transform.basis_xform(Vector2.UP) * thrust_force)

	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

	# 2. Screen wrapping
	var viewport_size: Vector2 = get_viewport_rect().size
	var wrap_margin = 25.0

	if global_position.x < -wrap_margin:
		global_position.x = viewport_size.x
	elif global_position.x > viewport_size.x + wrap_margin:
		global_position.x = 0

	if global_position.y < -wrap_margin:
		global_position.y = viewport_size.y
	elif global_position.y > viewport_size.y + wrap_margin:
		global_position.y = 0


func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	can_shoot = false
	fire_rate.start()


func _on_fire_rate_timeout() -> void:
	can_shoot = true


# commenting this since it's generating an error with the Asteroid class on startup.
# func _on_hit_detector_area_entered(area: Area2D) -> void:
#	if area is Asteroid:
#		print("Hit an asteroid")
		# Potentially handle damage to the player or the asteroid here
