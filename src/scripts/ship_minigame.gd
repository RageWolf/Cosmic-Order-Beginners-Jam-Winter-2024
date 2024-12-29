class_name ShipMinigame extends Node2D

@export var starting_pos : Vector2 = Vector2(100,240)
var Player : PlayerShip = preload("res://src/player_ship.tscn").instantiate()

# Base class for all minigames that are played on a
# sideview with the spaceship, currently only used for
# the asteroid minigame.

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func spawn_player() -> void:
	add_child(Player)
	Player.position = starting_pos
	Player.visible = true
