extends Node2D


func _on_space_pressed() -> void:
	get_tree().change_scene_to_packed(G.current_level)
