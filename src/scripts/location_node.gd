extends Node2D
class_name LocationNode

# Nodes the player can travel FROM
@export var departures: Array[LocationNode]
@export var is_final_node: bool = false
@export var event: PackedScene
@export var encounter: String
@export var encounter_image: CompressedTexture2D

var player_present: bool = false
@onready var Sprite : Sprite2D = $Sprite2D

func _ready() ->void:
	Sprite.frame = randi_range(0,1)
	show_paths()

func _process(delta: float) -> void:
	pass

# Update Line2D path to the departure point with a player present
func show_paths() ->void:
	var path:Line2D = $PathingLine
	path.hide()
	for node in departures:
		
		if node.player_present:
			path.points[1] = to_local(node.global_position)
			path.show()


#Triggered by HoverClickable
func clicked() -> void:
	# Check if any of the connected departure nodes have player_present; if so - TRAVEL!
	for node:LocationNode in departures:
		if node.player_present:
			start_travel(node)


func start_travel(departing_node: LocationNode) -> void:
	if get_parent().has_method("travel"):
		#departing_node.player_present = false
		get_parent().travel(position, self, departing_node)

func finish_travel() -> void:
	player_present = true
	for node in get_parent().get_children():
		if node.has_method("show_paths"):
			node.show_paths()
