extends Area2D
class_name Projectile

@export var speed: float = 400

func _process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta