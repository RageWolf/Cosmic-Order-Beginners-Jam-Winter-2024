extends Node2D

@export var speed: float = 0.5
var destination: Vector2 = Vector2.ZERO
var stopped:bool = false

signal destination_reached

func _process(delta: float) -> void:
	if not global_position.is_equal_approx(destination):
		position = position.move_toward(destination, speed)
	else:
		if not stopped:
			emit_signal("destination_reached")
			stopped = true
