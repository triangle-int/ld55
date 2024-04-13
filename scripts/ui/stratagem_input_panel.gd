extends NinePatchRect

@export var parent: Control
@export var stratagem_arrow: PackedScene

func _ready():
	StratagemInput.combination_updated.connect(update_combination)

func update_combination(combination: Array[Stratagem.PathPart]):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
	
	for path_part in combination:
		var instance = stratagem_arrow.instantiate()
		instance.set_path_part(path_part)
		parent.add_child(instance)
