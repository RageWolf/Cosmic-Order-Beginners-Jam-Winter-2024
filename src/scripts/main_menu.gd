extends Control

var StartScene : PackedScene = preload("res://src/start_screen.tscn")

func _ready() -> void:
	$StartButton.connect("pressed", _on_start_pressed_start_game)

func _on_start_pressed_start_game() -> void:
	$BackgroundMusic.reparent(get_parent())
	get_parent().add_child(StartScene.instantiate())
	queue_free()
