extends Area2D
class_name Asteroid

@export var timer: Timer
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

var size: int
var velocity: Vector2
var angular_velocity: float

func _ready() -> void:
	size = randi_range(0, 2)

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
