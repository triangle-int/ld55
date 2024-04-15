class_name LevelSelectButton

extends Button

@export var level_key: String

func _on_pressed():
	LevelLoder.load_scene(level_key)
