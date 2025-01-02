extends Node2D

@export var level_name: String = "Default Level Name"
@export var next_level: PackedScene
@export var starting_credits: int = 300
@export var days_left_until_delivery: int = 9

var floater_scene = load("res://src/floater.tscn")

var arriving_node: LocationNode

func _ready() -> void:
	G.current_level = load(scene_file_path)
	
	#ResourceManager.reset_resources()
	
	# This will run when the Space scene is loaded as a fresh level
	if G.current_space_location == "":
		ResourceManager.add_credits(starting_credits)
		ResourceManager.add_days(days_left_until_delivery)
		ResourceManager.add_fuel(4)
		#Set player_present on the node named "LocationNode"
		if get_node("LocationNode") and get_node("LocationNode").get("player_present") != null:
			$LocationNode.player_present = true
			$LocationNode.finish_travel()
			
			#Initialise SpacePlayer to the location of Location Node
			if get_node("SpacePlayer"):
				set_player_pos($LocationNode)
				
	#This will run if you are returning to the space scene from another scene
	else:
		var locationNode: LocationNode = get_node(G.current_space_location)
		locationNode.finish_travel()
		set_player_pos(locationNode)
		
		
func set_player_pos(node: LocationNode) -> void:
	$SpacePlayer.global_position = node.global_position
	$SpacePlayer.destination = node.global_position
	$SpacePlayer.stopped = true

# Begin the process of travelling from current node to the new destination
func travel(new_pos: Vector2, destination_node: LocationNode, departing_node: LocationNode) -> void:
	if ResourceManager.spend_travel_resources():
		departing_node.player_present = false
		$SpacePlayer.destination = new_pos
		$SpacePlayer.stopped = false
		self.arriving_node = destination_node


#Player has arrived at the destination node
func _on_space_player_destination_reached() -> void:
	G.current_space_location = arriving_node.name
	G.current_encounter = arriving_node.encounter
	G.current_encounter_image = arriving_node.encounter_image
	arriving_node.finish_travel()
	if arriving_node.event:
		get_tree().change_scene_to_packed(arriving_node.event)
	if arriving_node.is_final_node:
		G.current_level = next_level
		G.current_space_location = ""
		get_tree().change_scene_to_file("res://src/shop.tscn")
