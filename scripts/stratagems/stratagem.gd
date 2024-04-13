class_name Stratagem

extends Node

enum PathPart {UP, DOWN, LEFT, RIGHT}

@export var call_path: Array[PathPart]

func _init():
	StratagemInput.stratagems.push_back(self)
	StratagemInput.stratagem_called.connect(func(_s): StratagemInput.stratagems.push_back(self))

func _on_call():
	print('Method _on_call is not defined!')

func call_stratagem():
	_on_call()
