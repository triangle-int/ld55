class_name Unit

extends Node2D

enum Side {PLAYER, AI}

var _is_capturing: bool = false

var side: Unit.Side

@export var movement: MovementComponent
@export var health: HealthComponent
@export var sight: SightRangeComponent
@export var buff: BuffContainer
@export var attack: AttackComponent

func switch_side():
	$StateChart.send_event("switch_side")

func _ready():
	Battle.point_owner_updated.connect(func(_p): _update_target())

func _on_player_state_entered():
	side = Side.PLAYER

func _on_ai_state_entered():
	side = Side.AI

func _on_capturing_state_entered():
	_is_capturing = true
	_update_target()

func _on_capturing_state_exited():
	_is_capturing = false

func _update_target():
	if not _is_capturing:
		return

	var target = Battle.find_nearest_point(
		global_position,
		ControlPoint.Owner.PLAYER
		if side == Side.PLAYER
		else ControlPoint.Owner.AI
	)
	movement.set_target(target.global_position)
