extends Control

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			PlayerSummon.deploy_army()

func _on_mouse_entered():
	PlayerSummon.show_army()

func _on_mouse_exited():
	PlayerSummon.hide_army()

func _process(delta):
	if PlayerSummon.army_visible:
		var camera = get_viewport().get_camera_2d()
		PlayerSummon.update_army_position(camera.get_global_mouse_position())
