extends Node

const SAVE_GAME_PATH = "user://savegame.tres"

var _progress: Progress = Progress.new()

@export var levels: Array[String]

func _ready():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		_progress = load(SAVE_GAME_PATH)

func save_level_beaten(level_key: String):
	if level_key not in _progress.levels_beaten:
		_progress.levels_beaten.push_back(level_key)

	ResourceSaver.save(_progress, SAVE_GAME_PATH)

func is_level_available(level_key: String) -> bool:
	if level_key not in levels:
		return false

	var prev_level_index = levels.find(level_key) - 1

	if prev_level_index < 0:
		return true

	return _progress.levels_beaten.has(levels[prev_level_index])

func get_next_level(level_key: String) -> String:
	var index = levels.find(level_key)
	return levels[(index + 1) % len(levels)]
