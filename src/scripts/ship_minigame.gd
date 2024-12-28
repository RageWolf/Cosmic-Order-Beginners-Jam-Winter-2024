class_name ShipMinigame extends Node2D

@export var startingPos : Vector2 = Vector2(100,240)
var player : PlayerShip = preload("res://src/player_ship_2.tscn").instantiate()

# Base class for all minigames that are played on a
# sideview with the spaceship, currently only used for
# the asteroid minigame.

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func spawn_player() -> void:
	add_child(player)
	player.position = startingPos
	player.visible = true
	pass
