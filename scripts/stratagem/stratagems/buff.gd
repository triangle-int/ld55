class_name Buff

extends Stratagem

func _on_apply(_unit: Unit):
	pass

func _on_attack(_unit: Unit, _target: Unit):
	pass

func on_apply(unit: Unit):
	_on_apply(unit)

func on_attack(unit: Unit, target: Unit):
	_on_attack(unit, target)
