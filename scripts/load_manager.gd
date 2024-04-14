extends Node

@export var levels: Array[LevelResource]

func load_scene(scene_key: String):
	var level = levels.filter(
		func(level: LevelResource): return level.key == scene_key
	).front()

	get_tree().change_scene_to_packed(level.scene)
