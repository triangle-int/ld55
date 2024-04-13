extends Control

@export var parent: Control
@export var stratagem_info: PackedScene

func _ready():
	stratagems_updated(PlayerSummon.get_stratagems())
	PlayerSummon.stratagems_updated.connect(stratagems_updated)

func stratagems_updated(stratagems: Array[Stratagem]):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for stratagem in stratagems:
		var instance = stratagem_info.instantiate()
		instance.set_stratagem(stratagem)
		add_child(instance)
