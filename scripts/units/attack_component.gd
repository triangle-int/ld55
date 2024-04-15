class_name AttackComponent

extends Area2D

@export var attack_start_delay: float
var attack_cooldown: float
var damage: float

var _current_cooldown: float

signal on_attack(target: Unit, direction: Vector2i)
signal attack_started(target: Unit, direction: Vector2i)

@export var unit: Unit

func _process(delta: float):
	if _current_cooldown > 0:
		_current_cooldown -= delta

func _on_attacking_state_processing(_delta: float):
	if _current_cooldown > 0:
		return

	_current_cooldown = attack_cooldown

	var targets = get_overlapping_bodies().filter(
		func(b: Node2D): return unit.sight.get_enemies_in_range().has(b)
	)

	if targets.is_empty():
		return

	var target = targets.front()
	var direction = (target.global_position - global_position).normalized()
	attack_started.emit(target, Vector2i(direction))
	await get_tree().create_timer(attack_start_delay).timeout
	target.health.deal_damage(damage)
	on_attack.emit(target, Vector2i(direction))
