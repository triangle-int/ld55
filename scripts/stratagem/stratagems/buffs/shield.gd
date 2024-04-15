class_name ShieldBuff

extends Buff

func _modify_damage(_unit: Unit, damage: float) -> float:
	if damage <= 0:
		return damage

	_unit.buff.remove_buff(self)
	return 0
