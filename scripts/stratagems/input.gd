extends Node

const INPUT_TO_PART: Dictionary = {
	'stratagem_up': Stratagem.PathPart.UP,
	'stratagem_down': Stratagem.PathPart.DOWN,
	'stratagem_left': Stratagem.PathPart.LEFT,
	'stratagem_right': Stratagem.PathPart.RIGHT,
}

signal stratagem_called(stratagem)

var stratagems: Array[Stratagem] = []
var current_combination: Array[Stratagem.PathPart] = []

func _process(_delta: float):
	for key in INPUT_TO_PART:
		if Input.is_action_just_pressed(key):
			var part = INPUT_TO_PART[key]
			current_combination.push_back(part)
			_check_combination()
			return

func _check_combination():
	var available = stratagems.filter(func(s): return (
		len(s.call_path) >= len(current_combination) and
		current_combination.back() == s.call_path[len(current_combination) - 1]
	))

	if len(available) == 0:
		current_combination.clear()
		_on_incorrect_combination()
		return

	var to_call = available.filter(func(s): return (
		len(s.call_path) == len(current_combination)
	))

	if len(to_call) == 0:
		return

	if len(to_call) != 1:
		print("%d stratagems want to be called at once! This should not happen!" % len(to_call))

	var called = stratagems.back()
	stratagems.clear()
	current_combination.clear()

	called.call_stratagem()
	stratagem_called.emit(called)

func _on_incorrect_combination():
	print('You typed it wrong, something bad will happen now!')
