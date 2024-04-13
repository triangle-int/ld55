extends Buff

func _on_attack(_unit: Unit, target: Unit):
	target.switch_side()
