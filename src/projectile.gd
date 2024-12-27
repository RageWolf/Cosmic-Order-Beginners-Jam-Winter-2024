extends Area2D
class_name Projectile

@export var speed: float = 400

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	position += Vector2.UP.rotated(rotation) * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area is Asteroid:
		area.call_deferred("spawn_smaller_asteroids")
		area.queue_free()
		queue_free()
