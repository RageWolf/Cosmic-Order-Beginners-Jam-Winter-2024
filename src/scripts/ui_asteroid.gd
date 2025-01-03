extends CanvasLayer

var floater_scene = preload("res://src/floater.tscn")
func _ready() -> void:
	ResourceManager.resources_updated.connect(_on_resources_updated)
	$FuelContainer/Fuel.text = str(ResourceManager.fuel)
	$HullBar.value = int(ResourceManager.hull)
	
func _on_resources_updated() -> void:
	if ResourceManager.fuel != int($FuelContainer/Fuel.text):
		var floater:Label= floater_scene.instantiate()
		floater.text = str(ResourceManager.fuel - int($FuelContainer/Fuel.text))
		floater.position = $FuelContainer/Fuel.global_position
		add_child(floater)
	if ResourceManager.hull != int($HullBar.value):
		var floater:Label= floater_scene.instantiate()
		floater.text = str(ResourceManager.hull - int($HullBar.value))
		floater.position = $HullBar/TextureRect.global_position
		add_child(floater)
	$FuelContainer/Fuel.text = str(ResourceManager.fuel)
	$HullBar.value = int(ResourceManager.hull)
