class_name Stratagem

extends Node

enum PathPart {UP, DOWN, LEFT, RIGHT}

@export var call_path: Array[PathPart]

func _on_call():
	print('Method _on_call is not defined!')

func call_stratagem():
	_on_call()
