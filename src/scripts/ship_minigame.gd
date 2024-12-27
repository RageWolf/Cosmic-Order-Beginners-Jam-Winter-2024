class_name ShipMinigame extends Node2D

@export var startingPos : Vector2 = Vector2.ZERO
@export var player : PlayerShip

# Base class for all minigames that are played on a
# sideview with the spaceship, currently only used for
# the asteroid minigame.

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass
