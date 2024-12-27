extends Area2D


@export var background: bool
@export var background_color: Color
var background_active: bool = false

var mouse_present = false

func _ready() -> void:
	_draw()

func _draw() -> void:
	if background_active:
		var radius = $CollisionShape2D.get_shape().radius
		draw_circle(position,radius,background_color)
	


func activate_background(active: bool) -> void:
	background_active = active
	queue_redraw()
	
func _process(delta: float) -> void:
	#Capture mouse presses on this Node
	if Input.is_action_just_released("left_mouse") and mouse_present:
		if get_parent().has_method("clicked"):
			get_parent().clicked()
	


func _on_mouse_entered() -> void:
	mouse_present = true
	activate_background(true)


func _on_mouse_exited() -> void:
	mouse_present = false
	activate_background(false)
