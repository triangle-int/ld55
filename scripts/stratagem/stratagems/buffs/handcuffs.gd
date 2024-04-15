class_name HandcuffsBuff

extends Buff

@export var duration: float

func _on_apply(unit: Unit):
	unit.stunned = true
	await Battle.get_tree().create_timer(duration).timeout
	unit.buff.remove_buff(self)
	unit.stunned = false
