class_name UnitSpawner

extends Node2D

func _ready():
	PlayerSummon.army_summoned.connect(summon_player_army)

func summon_player_army(army: Army, buffs: Array, position: Vector2):
	summon_army(army, buffs, position, Unit.Side.PLAYER)

func summon_army(army: Army, buffs: Array, position: Vector2, side: Unit.Side):
	var instance = army.unit_scene.instantiate()
	instance.set_side(side)
	# TODO: Apply buffs
	add_child(instance)
	instance.global_position = position
