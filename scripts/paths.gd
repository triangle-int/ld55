class_name Paths

extends Node

class Path:
	var id: int
	var source: Vector2
	var target: Vector2

var _last_path_id: int = 0
var _queue: Array[Path] = []
var _pathfinder: AStarGrid2D

@export var region: Rect2i
@export var cell_size: Vector2

signal path_found(id: int, next_point: Vector2)

func enqueue_path(from: Vector2, to: Vector2) -> int:
	_last_path_id += 1
	var path = Path.new()
	path.id = _last_path_id
	path.source = from
	path.target = to
	_queue.push_back(path)
	return _last_path_id

func _ready():
	_pathfinder = AStarGrid2D.new()
	_pathfinder.region = region
	_pathfinder.cell_size = cell_size
	_pathfinder.diagonal_mode = 1
	_pathfinder.update()

func _process(_delta: float):
	if _queue.is_empty():
		return

	var curr = _queue.pop_front()
	var next_point = _find_path(curr)
	path_found.emit(curr.id, next_point)

func _find_path(path: Path) -> Vector2:
	var source_id = to_id(path.source)
	var source_point = _pathfinder.get_point_position(source_id)
	var was_occupied = _pathfinder.get_point_weight_scale(source_id) > 1
	deoccopy(source_point)
	var target_id = to_id(path.target)
	var result = _pathfinder.get_point_path(
		source_id,
		target_id,
	)

	if was_occupied:
		occupy(source_point)

	if len(result) <= 1:
		return source_point

	if _pathfinder.get_point_weight_scale(to_id(result[1])) > 1:
		return source_point

	return result[1]

func to_id(point: Vector2) -> Vector2i:
	var x = point.x / _pathfinder.cell_size.x
	var y = point.y / _pathfinder.cell_size.y
	return Vector2i(round(x), round(y))

func occupy(point: Vector2):
	_pathfinder.set_point_weight_scale(to_id(point), 1e9)

func deoccopy(point: Vector2):
	_pathfinder.set_point_weight_scale(to_id(point), 1)
