extends Node2D


func _on_buy_fuel_pressed() -> void:
	if ResourceManager.credits >= 300:
		ResourceManager.add_credits(-300)
		ResourceManager.add_fuel(1)


func _on_space_pressed() -> void:
	get_tree().change_scene_to_packed(G.current_level)
