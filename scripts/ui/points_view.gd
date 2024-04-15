extends Node

@export var player_points: Label
@export var ai_points: Label

func _ready():
	Battle.player_points_updated.connect(func(points: int):
		player_points.text = "YOU: %d" % points
	)
	Battle.ai_points_updated.connect(func(points: int):
		ai_points.text = "ENEMY: %d" % points
	)
