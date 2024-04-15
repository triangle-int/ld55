extends Control

@export var rect_scene: PackedScene


func _process(_delta: float):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	if PlayerSummon.state == PlayerSummonClass.State.ARMY:
		return
	
	var areas = SpawnAreas.areas
	for area in areas:
		var instance = rect_scene.instantiate() as Panel
		instance.position = area.position
		instance.size = area.size
		add_child(instance)
