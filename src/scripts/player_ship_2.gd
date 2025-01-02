class_name PlayerShip extends CharacterBody2D

@export var max_speed : float = 130
@export var acceleration : float = 200
## Value of deceleration should remain between 0 and 1, closer to 1 means faster deceleration.
@export var deceleration : float = 0.4
@export var mass : float = 2.0	
## Fraction of velocity that is bounced back on impact, between 0 and 1.
@export var bounce_factor : float = 0.4
# Impact with an object will always cause a minimum ammount of bounce off to prevent it from trapping the player.
var base_bounce : float = 20.0
var hit_invulnerability : bool = false
@export var shoot_frequency : float = 0.7
@export var shot_speed : float = 200.0
var shoot_cooldown : bool = false
@onready var shot_origin : Vector2 = $CannonSprite.position * self.scale

const ShotObj : PackedScene = preload("res://src/shot.tscn")

@onready var BodyAnimationTree : AnimationTree = $BodyAnimationTree
@onready var ThrustersAnimationTree : AnimationTree = $ThrustersAnimationTree
@onready var ShaderAnimationPlayer : AnimationPlayer = $ShaderAnimationPlayer
@onready var CannonAnimationPlayer : AnimationPlayer = $CannonAnimations
@onready var CannonSprite : Sprite2D = $CannonSprite
@onready var PlayerHitbox : Hitbox = $Hitbox
@onready var InvulTimer : Timer = $HitInvulTimer
@onready var CannonCooldown : Timer = $CannonCooldown
# Very archaic implementation of audio; I'm too pressed on time to make a proper audio manager.
@onready var FireStartPlayer : AudioStreamPlayer2D = $AudioFireStart
@onready var FireBurstPlayer : AudioStreamPlayer2D = $AudioFireBurst
@onready var FireLoopPlayer : AudioStreamPlayer2D = $AudioFireLoop
@onready var FireEndPlayer : AudioStreamPlayer2D = $AudioFireEnd

signal ship_destroyed
signal ship_out_of_fuel

func _ready() -> void:
	BodyAnimationTree.active = true
	ThrustersAnimationTree.active = true
	ThrustersAnimationTree.connect("animation_started", _on_animationStateChanged_updateAudio)
	hit_invulnerability = false
	shoot_cooldown = false
	PlayerHitbox.connect("body_entered", _on_hitbox_body_entered)
	InvulTimer.connect("timeout", _on_invulTimer_timeout)
	CannonCooldown.wait_time = shoot_frequency
	CannonCooldown.connect("timeout", _on_cannonCooldown_completed)
	FireLoopPlayer.connect("finished", _on_fireLoop_finished_replay)

func _process(delta: float) -> void:
	animation_update()
	
	if (!shoot_cooldown && Input.is_action_pressed("Action")):
		shoot()

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
	
	CannonSprite.rotation = get_local_mouse_position().angle()

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
	if !hit_invulnerability:
		hit_invulnerability = true
		PlayerHitbox.set_deferred("monitoring",false)
		# *** TODO *** Implement damage properly when merging
		G.player_data.hull -= damage
		if fuel_lost:
			G.player_data.fuel-=1
		
		ShaderAnimationPlayer.play("damage_taken")
		
		# *** TODO *** Delete this print when UI is implemented
		print("Damage taken. Health: ", G.player_data.hull, " Fuel:", G.player_data.fuel)
		
		if (G.player_data.hull <= 0):
			ship_destroyed.emit()
		if (G.player_data.fuel <= 0):
			ship_out_of_fuel.emit()
	
		InvulTimer.start()

func shoot() -> void:
	shoot_cooldown = true	
	CannonAnimationPlayer.play("RESET")
	CannonAnimationPlayer.play("shoot")
	var shot_instance : Shot = ShotObj.instantiate()
	# Setting direction to be aligned with the mouse and distance to be slightly away from the ship's center.
	var shot_direction : Vector2 = get_local_mouse_position().normalized()
	shot_instance.position = self.position + shot_origin + shot_direction * 10 * self.scale
	shot_instance.rotation = shot_direction.angle()
	shot_instance.speed = shot_speed
	shot_instance.direction = shot_direction
	
	get_parent().add_child(shot_instance)
	CannonCooldown.start()

func _on_hitbox_body_entered(body : Node2D) -> void:
	if body is Asteroid && !hit_invulnerability:
		take_damage(body.damage, body.fuel_damage)
		var impact_direction : Vector2 = (body.position - self.position).normalized()
		var impact_bounce : Vector2 =  (self.velocity - body.linear_velocity).abs() * bounce_factor * impact_direction
		self.velocity = - impact_bounce * (body.mass/self.mass) - base_bounce * impact_direction
		body.linear_velocity += impact_bounce * (self.mass/body.mass) + base_bounce * impact_direction

func  _on_invulTimer_timeout() -> void:
	hit_invulnerability = false
	PlayerHitbox.set_deferred("monitoring",true)

func _on_cannonCooldown_completed() -> void:
	shoot_cooldown = false

func _on_fireLoop_finished_replay() -> void:
	FireLoopPlayer.play()

func _on_animationStateChanged_updateAudio(anim_name: StringName) -> void:
	match(anim_name):
		"movement_started":
			FireStartPlayer.play()
			FireBurstPlayer.play()
			FireLoopPlayer.play()
		"movement_ended":
			FireLoopPlayer.stop()
			FireEndPlayer.play()
		_:
			FireLoopPlayer.stop()
