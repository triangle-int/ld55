extends Buff

func _modify_damage(_unit: Unit, damage: int) -> int:
	if damage <= 0:
		return damage

	_unit.buff.remove_buff(self)
	return 0
