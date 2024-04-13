class_name HealthComponent

extends Node

var health: float
var max_health: float

func set_max_health(amount: float):
	health = amount
	max_health = amount

func heal(amount: float):
	health += amount

	if health > max_health:
		health = max_health

func deal_damage(damage: float):
	health -= damage

	if health <= 0:
		death()

func death():
	$"..".queue_free()
