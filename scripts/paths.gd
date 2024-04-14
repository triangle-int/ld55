class_name Paths

extends Node

class Path:
	var id: int
	var source: Vector2i
	var target: Vector2i

	func _init(id: int, source: Vector2i, target: Vector2i):
		self.id = id
		self.source = source
		self.target = target

var _last_path_id: int = 0
var _queue: Array[Path] = []
var _pathfinder: AStarGrid2D

@export var region: Rect2i
@export var cell_size: Vector2
@export var paths_in_frame: float

signal path_found(id: int, next_point: Vector2)

func enqueue_path(from: Vector2i, to: Vector2i) -> int:
	_last_path_id += 1
	var path = Path.new(_last_path_id, from, to)
	_queue.push_back(path)
	return _last_path_id

func _ready():
	_pathfinder = AStarGrid2D.new()
	_pathfinder.region = region
	_pathfinder.cell_size = cell_size
	_pathfinder.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_pathfinder.update()

func _process(_delta: float):
	if _queue.is_empty():
		return
	
	var size = mini(paths_in_frame, _queue.size())
	for i in range(size):
		var curr = _queue.pop_front()
		var next_point = _find_path(curr)
		path_found.emit(curr.id, next_point)

func _find_path(path: Path) -> Vector2i:
	var was_occupied = _pathfinder.get_point_weight_scale(path.source) > 1
	deoccopy(path.source)
	var result = _pathfinder.get_id_path(
		path.source,
		path.target,
	)

	if was_occupied:
		occupy(path.source)

	if len(result) <= 1 or _pathfinder.get_point_weight_scale(result[1]) > 1:
		return path.source

	return result[1]

func to_pos(point: Vector2i) -> Vector2:
	return _pathfinder.get_point_position(point)

func to_id(point: Vector2) -> Vector2i:
	return Vector2i(
		round(point.x / cell_size.x),
		round(point.y / cell_size.y),
	)

func occupy(point: Vector2i):
	_pathfinder.set_point_weight_scale(point, 1e9)

func deoccopy(point: Vector2i):
	_pathfinder.set_point_weight_scale(point, 1)
