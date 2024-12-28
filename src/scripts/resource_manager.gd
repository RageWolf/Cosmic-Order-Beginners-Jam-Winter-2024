extends Node

signal resources_updated
signal game_over

var fuel: int = 0
var days_left: int
var credits: int

func _ready() -> void:
	resources_updated.emit()

func spend_travel_resources() -> bool:
	if fuel <= 0 or days_left <= 0:
		game_over.emit()
		return false
		
	fuel -= 1
	days_left -= 1
	resources_updated.emit()
	return true

func add_fuel(amount: int) -> void:
	fuel += amount
	resources_updated.emit()

func add_credits(amount: int) -> void:
	credits += amount
	resources_updated.emit()

func spend_credits(amount: int) -> bool:
	if credits < amount:
		return false
	
	credits -= amount
	resources_updated.emit()
	return true

func add_days(amount: int) -> void:
	days_left += amount
	resources_updated.emit()

func reset_resources() -> void:
	fuel = 0
	days_left = 0
	credits = 0
	resources_updated.emit()

func get_fuel() -> int:
	return fuel

func get_days_left() -> int:
	return days_left

func get_credits() -> int:
	return credits
