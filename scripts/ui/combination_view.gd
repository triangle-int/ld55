class_name CombinationView
extends Control

@export var arrow: PackedScene

func set_combination(combination: Array[Stratagem.PathPart]):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for path_part in combination:
		var instance = arrow.instantiate()
		instance.set_path_part(path_part)
		add_child(instance)
