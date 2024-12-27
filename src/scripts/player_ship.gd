class_name PlayerShip extends CharacterBody2D

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

func animation_update() -> void:
	pass

func movement_update(delta: float) -> void:
	var direction : Vector2 = get_input_direction()
	
	# Reduction of velocity based on deceleration value
	var deltaDeceleration : float = deceleration * delta
	self.velocity = Vector2(lerp(self.velocity.x, 0.0, deltaDeceleration),lerp(self.velocity.y, 0.0, deltaDeceleration))
	
	# Increases velocity based on acceleration, to a maximum of maxSpeed
	var deltaVelocity : Vector2 = acceleration * delta * direction
	var newVelocity : Vector2 = (self.velocity) + deltaVelocity
	self.velocity = newVelocity.limit_length(maxSpeed)
	print(self.velocity)
	self.move_and_slide()
	pass

# Returns vector of inputed direction with a maximum length of 1
func get_input_direction() -> Vector2:
	var dirX : float = Input.get_axis("Left","Right")
	var dirY : float = Input.get_axis("Up","Down")
	
	return Vector2(dirX, dirY).normalized()
