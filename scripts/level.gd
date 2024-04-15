extends Node

var _player_points: int
var _ai_points: int

@export var initial_points: int
@export var update_timer: Timer
@export var tilemap: TileMap

func _ready():
	_player_points = initial_points
	_ai_points = initial_points
	_update_points()
	update_timer.timeout.connect(_update_points)
	Battle.start_battle()
	PathFinding.clear_occupied()

	for w in range(PathFinding.region.size.x):
		for h in range(PathFinding.region.size.y):
			var x = PathFinding.region.position.x + w
			var y = PathFinding.region.position.y + h
			var cell = tilemap.get_cell_tile_data(0, Vector2i(x, y))

			if cell == null or cell.terrain != 1:
				continue

			PathFinding.occupy(Vector2i(x, y))

func _update_points():
	var counts = Battle.get_controlled_points()
	_ai_points = max(0, _ai_points - counts[ControlPoint.Owner.PLAYER])
	_player_points = max(0, _player_points - counts[ControlPoint.Owner.AI])
	_points_updated()

	if _ai_points <= 0:
		Battle.end_battle(Unit.Side.PLAYER)
		return

	if _player_points <= 0:
		Battle.end_battle(Unit.Side.AI)

func _points_updated():
	if not Battle.get_battle_started():
		return

	Battle.player_points_updated.emit(_player_points)
	Battle.ai_points_updated.emit(_ai_points)
