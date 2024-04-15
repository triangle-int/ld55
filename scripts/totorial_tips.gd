extends Node

var _current_tip := 0

@export var tips: Array[String]

func next_tip():
	_current_tip = min(_current_tip + 1, len(tips))

func curr_tip() -> String:
	if _current_tip >= len(tips):
		return ''

	return tips[_current_tip]
