extends Node2D

func set_side(side: Unit.Side):
	for child in get_children():
		child.set_side.call_deferred(side)
