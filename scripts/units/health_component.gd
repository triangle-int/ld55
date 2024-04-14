class_name HealthComponent

extends Node

var max_health: float
var health: float

@export var unit: Unit

func set_max_health(amount: float):
	health = amount
	max_health = amount

func heal(amount: float):
	health += amount

	if health > max_health:
		health = max_health

func deal_damage(damage: float):
	damage = unit.buff.modify_damage(damage)
	health -= damage

	if health <= 0:
		death()

func death():
	PathFinding.deoccupy(unit.position_point)
	unit.queue_free()
