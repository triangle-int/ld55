class_name HealthComponent

extends Node

signal damage_recieved(damage: float)
signal heal_recieved(heal: float)

var max_health: float
var health: float

@export var unit: Unit
@export var health_bar: ProgressBar

@onready var state_chart := $"../StateChart"

func set_max_health(amount: float):
	health = amount
	max_health = amount
	health_bar.value = health / max_health

func heal(amount: float):
	health += amount

	if health > max_health:
		health = max_health
	
	health_bar.value = health / max_health

func deal_damage(damage: float):
	state_chart.send_event("target_reached")
	damage = unit.buff.modify_damage(damage)
	damage_recieved.emit(damage)
	health -= damage
	
	health_bar.value = health / max_health
	
	if health <= 0:
		death()

func death():
	unit.queue_free()
