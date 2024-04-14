class_name AttackComponent

extends Area2D

var _current_cooldown: float
var _enemies_in_attack_range: Array[Unit] = []

signal on_attack(target: Unit, direction: Vector2i)

@export var unit: Unit
var attack_cooldown: float
var damage: float

func set_attack_cooldown(cooldown: float):
	attack_cooldown = cooldown

func set_damage(d: float):
	damage = d

func _on_attack_area_body_entered(body: Node2D):
	if not unit.sight.enemies_in_range.has(body):
		return

	_enemies_in_attack_range.push_back(body as Unit)

func _on_attack_area_body_exited(body: Node2D):
	_enemies_in_attack_range.erase(body)

func _on_attack_state_processing(_delta: float):
	if _current_cooldown > 0:
		return

	if _enemies_in_attack_range.is_empty():
		return

	_current_cooldown = attack_cooldown
	var target = _enemies_in_attack_range.front()

	while target != null and target.side == unit.side:
		_enemies_in_attack_range.pop_front()
		unit.sight.remove_enemy(target)
		target = _enemies_in_attack_range.front()

	if target == null:
		return

	target.health.deal_damage(damage)
	var direction = (target.global_position - global_position).normalized()
	on_attack.emit(target, Vector2i(direction))

func _process(delta: float):
	if _current_cooldown > 0:
		_current_cooldown -= delta
