class_name UnitSpawner

extends Node2D

var current_player_army: UnitsGroup

func _ready():
	PlayerSummon.army_prepared.connect(_on_army_prepared)
	PlayerSummon.army_buff_applied.connect(_on_army_buff_applied)
	PlayerSummon.army_position_updated.connect(_on_army_position_updated)
	PlayerSummon.army_deployed.connect(_on_army_deployed)

func summon_ai_army(army: Army, buffs: Array, pos: Vector2):
	var instance = army.unit_scene.instantiate() as UnitsGroup
	instance.global_position = pos

	for buff in buffs:
		instance.apply_buff(buff)

	add_child(instance)
	instance.summon_units(Unit.Side.AI, true)

func _on_army_position_updated(pos: Vector2):
	if current_player_army == null:
		return

	current_player_army.global_position = pos

func _on_army_prepared(army: Army):
	current_player_army = army.unit_scene.instantiate()
	add_child(current_player_army)

func _on_army_buff_applied(buff: Buff):
	current_player_army.apply_buff(buff)

func _on_army_deployed():
	current_player_army.summon_units(Unit.Side.PLAYER)
