extends Node2D
# I was starting the logic to change the shader peramiters dynamicly with a state change # 
#but decided to stip untill this is in main as I do not know how we are going to structure everything, 
# This now serves as a place holder for w.e background or Canvis Node you want the shader to 
#do its magic with. 

signal game_state_changed(new_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("GameState"):
		emit_signal("game_state_changed")
