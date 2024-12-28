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
	fire_rate.timeout.connect(on_fire_rate_timeout)
	hit_detector.area_entered.connect(on_hit_detector_area_entered)
func _process(delta) -> void:
	turn_direction = Input.get_axis("turn_right", "turn_left")
	apply_torque(turn_direction * turn_speed)

	if Input.is_action_pressed("thrust"):
		apply_central_force(transform.basis_xform(Vector2.UP) * thrust_force)
	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()
	
	# Screen wrapping
	var viewport_size = get_viewport_rect().size
	var wrap_margin = 25.0
	
	if global_position.x < 0 - wrap_margin:
		global_position.x = viewport_size.x
	elif global_position.x > viewport_size.x + wrap_margin:
		global_position.x = 0
	
	if global_position.y < 0 - wrap_margin:
		global_position.y = viewport_size.y
	elif global_position.y > viewport_size.y + wrap_margin:
		global_position.y = 0

func on_fire_rate_timeout() -> void:
	can_shoot = true

func shoot() -> void:
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	can_shoot = false
	fire_rate.start()

func on_hit_detector_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		print("hit an asteroid")
