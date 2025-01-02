class_name ShipMinigame
extends Node2D

@export var starting_pos: Vector2 = Vector2(100, 240)
var Player : Player_Ship = preload("res://src/player_ship_2.tscn").instantiate()

func _ready() -> void:
	# Automatically spawn the player when this node is added to the scene
	spawn_player()

func _process(delta: float) -> void:
	pass

func spawn_player() -> void:
	add_child(Player)
	Player.position = starting_pos
	Player.visible = true
