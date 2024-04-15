extends Node

@export var buttons: Array[Button]

func _ready():
	for index in range(len(buttons)):
		buttons[index].disabled =\
			not ProgressManager.is_level_available(buttons[index].level_key)
		print(buttons[index].disabled)
