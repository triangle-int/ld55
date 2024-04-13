class_name SightRangeComponent

extends Area2D

var enemies_in_range: Array[Unit] = []

@export var unit: Unit

func _on_enemy_in_sight_state_processing(_delta: float):
	unit.movement.set_target(enemies_in_range.front().global_position)

func _on_body_entered(body: Node2D):
	if not (body is Unit) or body == $"..":
		return

	var enemy = body as Unit

	if enemy.side == unit.side:
		return

	enemies_in_range.push_back(body as Unit)
	$"../StateChart".send_event("enemy_in_sight")

func _on_body_exited(body: Node2D):
	remove_enemy(body)

func remove_enemy(enemy: Unit):
	enemies_in_range.erase(enemy)

	if enemies_in_range.is_empty():
		$"../StateChart".send_event("enemy_lost")
