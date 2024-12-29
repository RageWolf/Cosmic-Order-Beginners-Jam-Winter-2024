class_name PlayerShip extends CharacterBody2D

@export var max_speed : float = 130
@export var acceleration : float = 200
# Value of deceleration should remain between 0 and 1, closer to 1 means faster deceleration
@export var deceleration : float = 0.6
var hitInvulnerability : bool = false

@onready var BodyAnimationTree : AnimationTree = $BodyAnimationTree
@onready var ThrustersAnimationTree : AnimationTree = $ThrustersAnimationTree
@onready var PlayerHitbox : Hitbox = $Hitbox
@onready var InvulTimer : Timer = $HitInvulTimer

signal ship_destroyed
signal ship_out_of_fuel

func _ready() -> void:
	BodyAnimationTree.active = true
	ThrustersAnimationTree.active = true
	hitInvulnerability = false
	PlayerHitbox.connect("body_entered", _on_hitbox_body_entered)
	InvulTimer.connect("timeout", _on_invulTimer_timeout)

func _process(delta: float) -> void:
	animation_update()

func _physics_process(delta: float) -> void:
	movement_update(delta)

# Updates states for the state machines in the animation trees and changes direction of thrusters
func animation_update() -> void:
	var input_direction : Vector2 = get_input_direction()
	if (abs(input_direction) > Vector2.ZERO):
		ThrustersAnimationTree["parameters/conditions/idle"] = false
		ThrustersAnimationTree["parameters/conditions/moving"] = true
		$ThrusterFrontSprite.global_rotation = input_direction.angle()
		$ThrusterBackSprite.global_rotation = input_direction.angle()
		
		if (abs(input_direction.y) >= 0.3):
			BodyAnimationTree["parameters/conditions/idle"] = false
			BodyAnimationTree["parameters/conditions/moving"] = true
			BodyAnimationTree["parameters/Moving/blend_position"] = input_direction.y
			BodyAnimationTree["parameters/Movement_end/blend_position"] = input_direction.y
		else:
			BodyAnimationTree["parameters/conditions/idle"] = true
			BodyAnimationTree["parameters/conditions/moving"] = false
	else:
		ThrustersAnimationTree["parameters/conditions/idle"] = true
		ThrustersAnimationTree["parameters/conditions/moving"] = false
		
		BodyAnimationTree["parameters/conditions/idle"] = true
		BodyAnimationTree["parameters/conditions/moving"] = false

func movement_update(delta: float) -> void:
	var direction : Vector2 = get_input_direction()
	
	# Reduction of velocity based on deceleration value
	var delta_deceleration : float = deceleration * delta
	var new_velocity = Vector2(lerp(self.velocity.x, 0.0, delta_deceleration),lerp(self.velocity.y, 0.0, delta_deceleration))
	
	# Increases velocity based on acceleration, to a maximum of max_speed
	var delta_velocity : Vector2 = acceleration * delta * direction
	new_velocity = new_velocity + delta_velocity
	self.velocity = new_velocity.limit_length(max_speed)
	self.move_and_slide()

# Returns vector of inputed direction with a maximum length of 1
func get_input_direction() -> Vector2:
	var dirX : float = Input.get_axis("Left","Right")
	var dirY : float = Input.get_axis("Up","Down")
	
	return Vector2(dirX, dirY).normalized()

func take_damage(damage : int, fuel_lost : bool = false) -> void:
	if !hitInvulnerability:
		hitInvulnerability = true
		PlayerHitbox.set_deferred("monitoring",false)
		# *** TODO *** Implement damage properly when merging
		G.player_data.hull -= damage
		if fuel_lost:
			G.player_data.fuel-=1
		
		# *** TODO *** Implement hit animation
		
		# *** TODO *** Delete this print when UI is implemented
		print("Damage taken. Health: ", G.player_data.hull, " Fuel:", G.player_data.fuel)
		
		if (G.player_data.hull <= 0):
			ship_destroyed.emit()
		if (G.player_data.fuel <= 0):
			ship_out_of_fuel.emit()
	
		InvulTimer.start()

func _on_hitbox_body_entered(body : Node2D) -> void:
	if body is Asteroid && hitInvulnerability == false:
		take_damage(body.damage, body.fuel_damage)

func  _on_invulTimer_timeout() -> void:
	hitInvulnerability = false
	PlayerHitbox.set_deferred("monitoring",true)
	pass
