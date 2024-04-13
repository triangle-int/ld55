class_name HealthComponent

extends Node

@export var start_health: int = 100
@onready var health: int = start_health

func heal(amount: int):
	health += amount

	if health > start_health:
		health = start_health

func deal_damage(damage: int):
	health -= damage

	if health <= 0:
		death()

func death():
	$"..".queue_free()
