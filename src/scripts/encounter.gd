class_name Encounter extends Node2D

var json = JSON.new()
@onready var file = FileAccess.get_file_as_string("res://src/encounters.json")
var option_scene = preload("res://src/encounter_option.tscn")
var encounters
var encounter
var flag = 1
@onready var main_text: RichTextLabel = $EncounterUI/VBoxContainer/MainText
var text_displaying = ""
var changing_scene = false
var target_scene : PackedScene = null

var text_timer = 0
var text_interval = 0.01
var picking_options = false

func _ready() -> void:
	encounters = JSON.parse_string(file)
	encounter = encounters[G.current_encounter]
	text_displaying = encounter[str(flag)]["text"]
	main_text.text = text_displaying
	main_text.visible_characters = 0
	$EncounterImage.texture = G.current_encounter_image
	
func _process(delta: float) -> void:
	if main_text.visible_characters < len(text_displaying):
		if text_timer <= 0:
			text_timer = text_interval
			main_text.visible_characters += 1
		else:
			text_timer -= delta
	else:
		if not picking_options:
			if encounter[str(flag)]["flag"] == "-1":
				$EncounterUI/VBoxContainer/Continue.show()
				if encounter[str(flag)].has("outcomes"):
					$EncounterUI/VBoxContainer/Outcomes.show()
					for outcome in encounter[str(flag)]["outcomes"]:
						var label = Label.new()
						var text = ""
						var key = outcome.keys()[0]
						text =  key +": " + str(outcome[key])
						label.text = text
						$EncounterUI/VBoxContainer/Outcomes.add_child(label)
						process_outcomes(key, int(outcome[key]))
				if encounter[str(flag)].has("scene"):
					self.target_scene = load(encounter[str(flag)]["scene"])
					changing_scene = true
				picking_options = true
			if encounter[str(flag)].has("options"):
				picking_options = true
				var index = 1
				for option in encounter[str(flag)]["options"]:
					var option_label = option_scene.instantiate()
					option_label.get_node("Text").text = str(index)+". "+option["text"]
					option_label.get_node("Text").pressed.connect(_on_option_pressed.bind(option["flag"]))
					$EncounterUI/VBoxContainer/Options.add_child(option_label)
					index += 1

func _on_option_pressed(option_flag):
	picking_options = false
	flag = int(option_flag)
	text_displaying = encounter[str(flag)]["text"]
	main_text.text = text_displaying
	main_text.visible_characters = 0
	for option in $EncounterUI/VBoxContainer/Options.get_children():
		option.queue_free()



func _on_continue_pressed() -> void:
	if changing_scene && target_scene != null:
		get_tree().change_scene_to_packed(target_scene)
	else:
		get_tree().change_scene_to_packed(G.current_level)



func process_outcomes(resource, amount):
	if resource == "Days":
		ResourceManager.add_days(amount)
	elif resource == "Credits":
		ResourceManager.add_credits(amount)
	elif resource == "Fuel":
		ResourceManager.add_fuel(amount)
