extends Control


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var camera = get_viewport().get_camera_2d()
			PlayerSummon.summon_at_position(camera.get_global_mouse_position())
