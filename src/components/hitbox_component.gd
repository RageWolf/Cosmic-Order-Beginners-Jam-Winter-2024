class_name Hitbox extends Area2D

signal delete_object()

func _ready() -> void:
	pass

func delete_origin() -> void:
	self.delete_object.emit()
