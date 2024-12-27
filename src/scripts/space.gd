extends Node2D

@export var level_name: String = "Default Level Name"
@export var next_level: PackedScene

var arriving_node: LocationNode

func _ready() -> void:
	G.current_level = load(scene_file_path)
	print(G.current_space_location)
	# This will run when the Space scene is loaded as a fresh level
	if G.current_space_location == "":
		#Set player_present on the node named "LocationNode"
		if get_node("LocationNode") and get_node("LocationNode").get("player_present") != null:
			$LocationNode.player_present = true
			$LocationNode.finish_travel()
			
			#Initialise SpacePlayer to the location of Location Node
			if get_node("SpacePlayer"):
				set_player_pos($LocationNode)
				
	#This will run if you are returning to the space scene from another scene
	else:
		var locationNode:LocationNode = get_node(G.current_space_location)
		locationNode.finish_travel()
		set_player_pos(locationNode)
		
		
func set_player_pos(node: LocationNode) -> void:
	$SpacePlayer.global_position = node.global_position
	$SpacePlayer.destination = node.global_position
	$SpacePlayer.stopped = true

# Begin the process of travelling from current node to the new destination
func travel(new_pos: Vector2, destination_node: LocationNode) ->void:
	$SpacePlayer.destination = new_pos
	$SpacePlayer.stopped = false
	self.arriving_node = destination_node
	$"Load Minigame".hide()
	$"Load Ship Scene".hide()

#Player has arrived at the destination node
func _on_space_player_destination_reached() -> void:
	arriving_node.finish_travel()
	G.current_space_location = arriving_node.name
	$"Load Minigame".show()
	$"Load Ship Scene".show()
	if arriving_node.is_final_node:
		$"Next level".show()

# ****DEBUG****
# REMOVE ME
func _on_reload_scene_pressed() -> void:
	G.current_space_location = ""
	get_tree().reload_current_scene()

# ****DEBUG****
# REMOVE ME
func _on_load_ship_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://src/ship.tscn")

# ****DEBUG****
# REMOVE ME
func _on_load_minigame_pressed() -> void:
	get_tree().change_scene_to_file("res://src/minigame.tscn")

# ****DEBUG****
# REMOVE ME
func _on_next_level_pressed() -> void:
	G.current_space_location = ""
	get_tree().change_scene_to_packed(next_level)
