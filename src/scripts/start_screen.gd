extends Encounter

# The way this node works is a disaster, moving on...

func _ready() -> void:
	G.current_encounter = "0"
	encounters = JSON.parse_string(file)
	encounter = encounters[G.current_encounter]
	text_displaying = encounter[str(flag)]["text"]
	main_text.text = text_displaying
	main_text.visible_characters = 0
	$EncounterImage.texture = G.current_encounter_image

func _process(delta : float) -> void:
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
				$EncounterUI/VBoxContainer/Continue.connect("pressed", _start_level)
				if encounter[str(flag)].has("scene"):
					target_scene = load(encounter[str(flag)]["scene"])
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

func _start_level() -> void:
	if changing_scene && target_scene != null:
		get_tree().change_scene_to_packed(target_scene)
