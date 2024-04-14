extends Node

const INPUT_TO_PART: Dictionary = {
	'stratagem_up': Stratagem.PathPart.UP,
	'stratagem_down': Stratagem.PathPart.DOWN,
	'stratagem_left': Stratagem.PathPart.LEFT,
	'stratagem_right': Stratagem.PathPart.RIGHT,
}

signal combination_updated(combination: Array[Stratagem.PathPart])
signal stratagem_called(stratagem: Stratagem)
signal wrong_combination()

var _stratagems: Array[Stratagem] = []
var _combination: Array[Stratagem.PathPart] = []

func set_stratagems(stratagems: Array[Stratagem]):
	_combination.clear()
	combination_updated.emit(_combination)
	_stratagems = stratagems.duplicate()

func _process(_delta: float):
	for key in INPUT_TO_PART:
		if Input.is_action_just_pressed(key):
			var part = INPUT_TO_PART[key]
			_combination.push_back(part)
			combination_updated.emit(_combination)
			_check_combination()
			return

func _is_combination_prefix(call_path: Array[Stratagem.PathPart]) -> bool:
	if len(call_path) < len(_combination):
		return false
	
	for i in range(len(_combination)):
		if call_path[i] != _combination[i]:
			return false
	return true

func _check_combination():
	var available = _stratagems.filter(func(s): return _is_combination_prefix(s.call_path))

	if len(available) == 0:
		_combination.clear()
		combination_updated.emit(_combination)
		wrong_combination.emit()
		return

	var to_call = available.filter(func(s): return (
		len(s.call_path) == len(_combination)
	))

	if len(to_call) == 0:
		return

	if len(to_call) != 1:
		print("%d stratagems want to be called at once! This should not happen!" % len(to_call))

	var called = to_call.back()
	_combination.clear()
	combination_updated.emit(_combination)
	stratagem_called.emit(called)
