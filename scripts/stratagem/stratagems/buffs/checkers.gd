class_name CheckersBuff

extends Buff

func _modify_damage(unit: Unit, damage: float) -> float:
	unit.switch_side()
	unit.buff.remove_buff(self)
	return damage
