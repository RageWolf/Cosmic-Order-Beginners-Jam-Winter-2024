extends Node

signal resources_updated
signal game_over

var fuel: int = 0
var days_left: int = 0
var credits: int = 0
var hull: int = 100

func _ready() -> void:
	reset_resources()

func spend_travel_resources() -> bool:
	fuel -= 1
	if fuel < 0:
		fuel = 0
		days_left -= 2
	else:
		days_left -= 1
		
	resources_updated.emit()
	return true

func add_fuel(amount: int) -> void:
	fuel += amount
	if fuel < 0:
		fuel = 0
	resources_updated.emit()

func add_credits(amount: int) -> void:
	credits += amount
	if credits < 0:
		credits = 0
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

func add_health(amount: int) -> void:
	hull += amount
	resources_updated.emit()

func reset_resources() -> void:
	fuel = 0
	days_left = 0
	credits = 0
	hull = 100
	resources_updated.emit()

func get_fuel() -> int:
	return fuel

func get_days_left() -> int:
	return days_left

func get_credits() -> int:
	return credits

func get_health() -> int:
	return hull

func game_over_emit() -> void:
	game_over.emit()
