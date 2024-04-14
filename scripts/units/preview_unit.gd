extends Node2D


func _process(delta):
	var parent_pos = get_parent().global_position
	var id = PathFinding.to_id(parent_pos)
	global_position = PathFinding.to_pos(id)
	
	if can_spawn():
		modulate = Color.WHITE
	else:
		modulate = Color.RED
	modulate.a = 0.5

func can_spawn():
	var parent_pos = get_parent().global_position
	var id = PathFinding.to_id(parent_pos)
	return not PathFinding.is_occupied(id)
