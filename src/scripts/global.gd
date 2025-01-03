extends Node

var current_level: PackedScene = preload("res://src/space.tscn")
var current_space_location: String
var current_encounter = "1-1"
var current_encounter_image: CompressedTexture2D
var nav_tutorial_complete : bool = false
var asteroid_tutorial_complete : bool = false
