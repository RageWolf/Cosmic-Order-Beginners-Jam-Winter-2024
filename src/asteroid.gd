extends Area2D
class_name Asteroid

@export var timer: Timer

var velocity: Vector2
var angular_velocity: float

func _ready() -> void:
	timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
	position += velocity * delta
	rotation += angular_velocity * delta
