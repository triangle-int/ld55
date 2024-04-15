extends Node2D

@export var unit_scene: PackedScene
@export var unit_preview: PackedScene

var summoned := false

func _ready():
	for child in get_children():
		var preview = unit_preview.instantiate()
		child.add_child(preview)

func _process(_delta: float):
	if summoned:
		return
	
	PlayerSummon.obstacle_on_spawn = not can_spawn()

func can_spawn():
	for child in get_children():
		if child.get_child_count() > 0:
			if not child.get_child(0).can_spawn():
				return false
	return true

func summon_units(side: Unit.Side, bypass: bool = false):
	if (not can_spawn() and not bypass):
		return
	
	summoned = true
	for child in get_children():
		if child.get_child_count() > 0:
			child.get_child(0).queue_free()
		var unit = unit_scene.instantiate()
		unit.set_side.call_deferred(side)
		unit.position = child.position
		add_child(unit)
