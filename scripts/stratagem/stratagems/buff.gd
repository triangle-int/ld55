class_name Buff

extends Stratagem

func _on_apply(_unit: Unit):
	pass

func _on_attack(_unit: Unit, _target: Unit):
	pass

func _modify_damage(_unit: Unit, damage: float) -> float:
	return damage

func on_apply(unit: Unit):
	_on_apply(unit)

func on_attack(unit: Unit, target: Unit):
	_on_attack(unit, target)

func modify_damage(unit: Unit, damage: float) -> float:
	return _modify_damage(unit, damage)
