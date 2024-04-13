extends Node

@export var start_health = 100
@onready var health = start_health

func heal(amount: int) -> void:
	health += amount
	if health > start_health:
		health = start_health

func deal_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		death()

func death() -> void:
	queue_free()
