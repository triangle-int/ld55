class_name HealthComponent

extends Node

signal damage_recieved(damage: float)

var max_health: float
var health: float

@export var unit: Unit
@onready var state_chart := $"../StateChart"

func set_max_health(amount: float):
	health = amount
	max_health = amount

func heal(amount: float):
	health += amount

	if health > max_health:
		health = max_health

func deal_damage(damage: float):
	state_chart.send_event("target_reached")
	damage = unit.buff.modify_damage(damage)
	damage_recieved.emit(damage)
	health -= damage

	if health <= 0:
		death()

func death():
	unit.queue_free()
