extends Node

var _points: Array[ControlPoint] = []
var _battle_started: bool = false

signal point_owner_updated(point: ControlPoint)
signal battle_ended(winner: Unit.Side)
signal battle_started()
signal player_points_updated(points: int)
signal ai_points_updated(points: int)

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

func get_controlled_points() -> Dictionary:
	var result = {}
	result[ControlPoint.Owner.PLAYER] = len(_points.filter(
		func(p: ControlPoint): return p.curr_owner == ControlPoint.Owner.PLAYER
	))
	result[ControlPoint.Owner.AI] = len(_points.filter(
		func(p: ControlPoint): return p.curr_owner == ControlPoint.Owner.AI
	))
	return result

func attach_control_point(point: ControlPoint):
	_points.push_back(point)
	point.owner_updated.connect(func():
		point_owner_updated.emit(point)
	)

func detach_control_point(point: ControlPoint):
	_points.erase(point)

func start_battle():
	_battle_started = true
	battle_started.emit()

func end_battle(side: Unit.Side):
	_battle_started = false

	if side == Unit.Side.PLAYER:
		ProgressManager.save_level_beaten(LevelLoder.get_current_level())

	battle_ended.emit(side)

func get_battle_started() -> bool:
	return _battle_started
