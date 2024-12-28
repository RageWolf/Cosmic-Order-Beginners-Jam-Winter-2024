extends CanvasLayer

var floater_scene = preload("res://src/floater.tscn")
func _ready() -> void:
	ResourceManager.resources_updated.connect(_on_resources_updated)
	$FuelContainer/Fuel.text = str(ResourceManager.fuel)
	$CreditsContainer/Credits.text = str(ResourceManager.credits)
	$DaysContainer/Days.text = str(ResourceManager.days_left)
func _on_resources_updated() -> void:
	print(ResourceManager.fuel)
	print(int($FuelContainer/Fuel.text))
	if ResourceManager.fuel != int($FuelContainer/Fuel.text):
		var floater:Label= floater_scene.instantiate()
		floater.text = str(ResourceManager.fuel - int($FuelContainer/Fuel.text))
		floater.position = $FuelContainer/Fuel.global_position
		add_child(floater)
	if ResourceManager.days_left != int($DaysContainer/Days.text):
		var floater:Label= floater_scene.instantiate()
		floater.text = str(ResourceManager.days_left - int($DaysContainer/Days.text))
		floater.position = $DaysContainer/Days.global_position
		add_child(floater)
	if ResourceManager.credits != int($CreditsContainer/Credits.text):
		var floater:Label= floater_scene.instantiate()
		floater.text = str(ResourceManager.credits - int($CreditsContainer/Credits.text))
		floater.position = $CreditsContainer/Credits.global_position
		add_child(floater)
	$FuelContainer/Fuel.text = str(ResourceManager.fuel)
	$CreditsContainer/Credits.text = str(ResourceManager.credits)
	$DaysContainer/Days.text = str(ResourceManager.days_left)
