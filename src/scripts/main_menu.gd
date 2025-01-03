extends Control

var StartScene : PackedScene = preload("res://src/start_screen.tscn")

func _ready() -> void:
	$StartButton.connect("pressed", _on_start_pressed_start_game)

func _on_start_pressed_start_game() -> void:
	print("presed")
	get_tree().change_scene_to_packed(StartScene)
