extends Node2D

func _ready():
	PlayerSummon.army_summoned.connect(summon_army)

func summon_army(army: Army, buffs: Array[Stratagem], position: Vector2):
	var instance = army.unit_scene.instantiate()
	# TODO: Apply buffs
	add_child(instance)
	instance.position = position
