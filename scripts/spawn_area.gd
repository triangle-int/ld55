extends Area2D

func get_rect(shape: CollisionShape2D):
	var rect_size = shape.shape.size
	print(rect_size)
	return Rect2(shape.position - rect_size / 2, rect_size)

func _process(delta):
	var shapes = get_children()\
		.filter(func(child): return not child.disabled)\
		.map(func(child): return get_rect(child))
	SpawnAreas.areas = shapes
