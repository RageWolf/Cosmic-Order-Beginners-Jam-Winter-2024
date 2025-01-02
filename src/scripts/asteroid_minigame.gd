class_name AsteroidMinigame extends ShipMinigame

## Basic difficulty modifier, scales asteroid speed and frequency.
@export_range(0.5,3,0.1) var difficulty_scaling : float = 1.0

const AsteroidObj : PackedScene = preload("res://src/asteroid.tscn")
const AsteroidSpawnPos : Vector2 = Vector2(672,16)
const AsteroidSpawnArea : Vector2 = Vector2(32,464)

@onready var LevelTimer : Timer = $LevelTimer
@onready var AsteroidTimer : Timer = $AsteroidTimer
@onready var level_state = LevelState.Starting
var min_velocity : float = 40.0
var max_velocity : float = 100.0

enum LevelState {
	Starting,
	InProgress,
	Finished,
	GameOver
}

func _ready() -> void:
	LevelTimer.connect("timeout", _on_LevelTimer_timeout)
	AsteroidTimer.connect("timeout", _on_AsteroidTimer_timeout_Spawn_Asteroid)
	$OutOfBoundsBorder.connect("body_entered", _on_body_outOfBounds)
	$OutOfBoundsBorder.connect("area_entered", _on_area_outOfBounds)
	Player.connect("ship_destroyed", _on_Ship_Destroyed)
	Player.connect("ship_out_of_fuel", _on_Ship_Out_Of_Fuel)
	update_difficulty()
	spawn_player()
	state_update()
	
func state_update() -> void:
	match level_state:
		LevelState.Starting:
			# *** TODO *** Implement tutorial
			AsteroidTimer.stop()
			LevelTimer.set_wait_time(5)
			LevelTimer.start()
		LevelState.InProgress:
			LevelTimer.set_wait_time(10)
			LevelTimer.start()
			AsteroidTimer.start()
		LevelState.Finished:
			# *** TODO *** Implement UI for exiting level
			AsteroidTimer.stop()
			get_tree().change_scene_to_packed(G.current_level)
		LevelState.GameOver:
			# *** TODO *** Implement game over screen
			AsteroidTimer.stop()
			print("Game Over")
		_:
			pass

func update_difficulty() -> void:
	AsteroidTimer.set_wait_time(0.2 / difficulty_scaling)
	min_velocity = 40 * difficulty_scaling
	max_velocity = 100 * difficulty_scaling

func _on_LevelTimer_timeout() -> void:
	match level_state:
		LevelState.Starting:
			level_state = LevelState.InProgress
		LevelState.InProgress:
			level_state = LevelState.Finished
	state_update()

func _on_AsteroidTimer_timeout_Spawn_Asteroid() -> void:
	var asteroid : Asteroid = AsteroidObj.instantiate()
	
	# Randomizing size, direction, starting position and speed of asteroids
	asteroid.magnitude = randi_range(1,3)
	asteroid.direction = randf_range(160,200)
	asteroid.velocity = randf_range(min_velocity, max_velocity)
	var random_x = randf_range(AsteroidSpawnPos.x, AsteroidSpawnPos.x + AsteroidSpawnArea.x)
	var random_y = randf_range(AsteroidSpawnPos.y, AsteroidSpawnPos.y + AsteroidSpawnArea.y)
	asteroid.position = Vector2(random_x, random_y)
	
	self.add_child(asteroid)
	pass

func _on_body_outOfBounds(body : Node2D) -> void:
	if body is PlayerShip:
		body.position = self.starting_pos
	else:
		body.queue_free()

func _on_area_outOfBounds(area: Area2D) -> void:
	if area is Hitbox || area is Hurtbox:
		area.delete_origin()

func _on_Ship_Destroyed() -> void:
	# *** TODO *** Implement ship destroyed animation
	level_state = LevelState.GameOver
	state_update()
	
func _on_Ship_Out_Of_Fuel() -> void:
	# *** TODO *** Implement ship out of fuel animation
	level_state = LevelState.GameOver
	state_update()
