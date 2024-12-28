extends Label

func _process(delta: float) -> void:
	if modulate.a <= 0:
		queue_free()
	position.y -= 0.03
	modulate.a -= 0.0008
