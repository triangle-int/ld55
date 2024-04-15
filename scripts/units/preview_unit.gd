extends Node2D


func _process(_delta: float):
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
	if PathFinding.is_occupied(id):
		return false
	
	for area in SpawnAreas.areas:
		if area.has_point(global_position):
			return true
	
	return false
