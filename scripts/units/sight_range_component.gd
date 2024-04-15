class_name SightRangeComponent

extends Area2D

@export var unit: Unit
@onready var state_chart := $"../StateChart"

func _on_attacking_state_physics_processing(_delta: float):
	var enemies = get_enemies_in_range()
	var min_dist := INF
	var closest: Unit = null

	for enemy in enemies:
		var dist = Vector2(enemy.position_point).distance_squared_to(
			Vector2(unit.position_point)
		)

		if dist < min_dist or closest == null:
			closest = enemy
			min_dist = dist

	unit.target_point = closest.position_point

func _physics_process(_delta: float):
	var enemies = get_enemies_in_range()

	if enemies.is_empty():
		state_chart.send_event("enemy_lost")
	elif not enemies.is_empty():
		state_chart.send_event("enemy_detected")

func get_enemies_in_range() -> Array:
	return get_overlapping_bodies().filter(
		func(b: Node2D): return b is Unit
	).map(
		func(b: Node2D): return b as Unit
	).filter(
		func(u: Unit): return u.side != unit.side
	)
