extends Node

var _player_points: int
var _ai_points: int

@export var initial_points: int
@export var update_timer: Timer

func _ready():
	_player_points = initial_points
	_ai_points = initial_points
	update_timer.timeout.connect(_update_points)
	Battle.start_battle()

func _update_points():
	var counts = Battle.get_controlled_points()
	_ai_points -= counts[ControlPoint.Owner.PLAYER]
	_player_points -= counts[ControlPoint.Owner.AI]

	if _ai_points <= 0:
		Battle.end_battle(Unit.Side.PLAYER)
		return

	if _player_points <= 0:
		Battle.end_battle(Unit.Side.AI)
