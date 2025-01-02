class_name Shot extends Node2D

@export var speed : float = 200.0
@export var direction : Vector2 = Vector2(1,0)

@onready var ShotHurtbox : Hurtbox = $Hurtbox

func _ready() -> void:
	ShotHurtbox.connect("delete_object", _on_markedForDeletion_delete)
	ShotHurtbox.connect("area_entered", _on_hurtbox_areaEntered)
	ShotHurtbox.connect("body_entered", _on_hurtbox_bodyEntered)

func _physics_process(delta: float) -> void:
	self.position += speed * direction * delta
	pass

func _on_markedForDeletion_delete() -> void:
	self.queue_free()

func _on_hurtbox_areaEntered(area: Area2D) -> void:
	pass

func _on_hurtbox_bodyEntered(body: Node2D) -> void:
	if (body is Asteroid):
		body.hit()
		self.queue_free()
