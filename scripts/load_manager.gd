extends Node

var _current_level: String = ""

@export var levels: Array[LevelResource]

func load_scene(scene_key: String):
	var level = levels\
		.filter(func(l: LevelResource): return l.key == scene_key)\
		.front()

	_current_level = scene_key
	get_tree().change_scene_to_packed(level.scene)

func get_current_level() -> String:
	return _current_level
