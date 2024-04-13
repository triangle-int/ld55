extends Buff

func _on_attack(unit: Unit, target: Unit):
	target.health.deal_damage(target.health.health + 1)
	unit.buff.remove_buff(self)
