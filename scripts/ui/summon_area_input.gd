extends Control


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			PlayerSummon.summon_at_position(get_global_mouse_position())
