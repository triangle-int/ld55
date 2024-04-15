class_name BackgammonBuff

extends Buff

func _on_attack(unit: Unit, target: Unit):
	target.switch_side()
	unit.buff.remove_buff(self)
