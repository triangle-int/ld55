extends Node

var _points: Array[ControlPoint] = []

signal point_owner_updated(point: ControlPoint)

func find_nearest_point(pos: Vector2, side: ControlPoint.Owner) -> ControlPoint:
	var to_select = _points.filter(func(p): return p.curr_owner != side)

	if to_select.is_empty():
		to_select = _points

	var result: ControlPoint = null
	var min_dist: float

	for point in to_select:
		var dist = point.global_position.distance_squared_to(pos)

		if result == null or dist < min_dist:
			min_dist = dist
			result = point

	return result

func attach_control_point(point: ControlPoint):
	_points.push_back(point)
	point.owner_updated.connect(func():
		point_owner_updated.emit(point)
	)
