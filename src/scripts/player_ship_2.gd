class_name Player_Ship extends CharacterBody2D

@export var maxSpeed : float = 130
@export var acceleration : float = 200
# Value of deceleration should remain between 0 and 1, closer to 1 means fastar deceleration
@export var deceleration : float = 0.6

@onready var BodyAnimationTree : AnimationTree = $BodyAnimationTree
@onready var ThrustersAnimationTree : AnimationTree = $ThrustersAnimationTree

func _ready() -> void:
	BodyAnimationTree.active = true
	ThrustersAnimationTree.active = true
	pass

func _process(delta: float) -> void:
	animation_update()
	pass

func _physics_process(delta: float) -> void:
	movement_update(delta)
	pass

# Updates states for the state machines in the animation trees and changes direction of thrusters
func animation_update() -> void:
	var inputDirection : Vector2 = get_input_direction()
	if (abs(inputDirection) > Vector2.ZERO):
		ThrustersAnimationTree["parameters/conditions/idle"] = false
		ThrustersAnimationTree["parameters/conditions/moving"] = true
		$ThrusterFrontSprite.global_rotation = inputDirection.angle()
		$ThrusterBackSprite.global_rotation = inputDirection.angle()
		
		if (abs(inputDirection.y) >= 0.3):
			BodyAnimationTree["parameters/conditions/idle"] = false
			BodyAnimationTree["parameters/conditions/moving"] = true
			BodyAnimationTree["parameters/Moving/blend_position"] = inputDirection.y
			BodyAnimationTree["parameters/Movement_end/blend_position"] = inputDirection.y
		else:
			BodyAnimationTree["parameters/conditions/idle"] = true
			BodyAnimationTree["parameters/conditions/moving"] = false
		pass
	else:
		ThrustersAnimationTree["parameters/conditions/idle"] = true
		ThrustersAnimationTree["parameters/conditions/moving"] = false
		
		BodyAnimationTree["parameters/conditions/idle"] = true
		BodyAnimationTree["parameters/conditions/moving"] = false
	pass

func movement_update(delta: float) -> void:
	var direction : Vector2 = get_input_direction()
	
	# Reduction of velocity based on deceleration value
	var deltaDeceleration : float = deceleration * delta
	var newVelocity = Vector2(lerp(self.velocity.x, 0.0, deltaDeceleration),lerp(self.velocity.y, 0.0, deltaDeceleration))
	
	# Increases velocity based on acceleration, to a maximum of maxSpeed
	var deltaVelocity : Vector2 = acceleration * delta * direction
	newVelocity = newVelocity + deltaVelocity
	self.velocity = newVelocity.limit_length(maxSpeed)
	self.move_and_slide()
	pass

# Returns vector of inputed direction with a maximum length of 1
func get_input_direction() -> Vector2:
	var dirX : float = Input.get_axis("Left","Right")
	var dirY : float = Input.get_axis("Up","Down")
	
	return Vector2(dirX, dirY).normalized()
