class_name Unit

extends Node2D

enum Side {PLAYER, AI}

var _is_capturing: bool = false

var side: Unit.Side

@export var movement: MovementComponent
@export var health: HealthComponent
@export var attack: AttackComponent
@export var sight: SightRangeComponent
@export var buff: BuffContainer

func switch_side():
	$StateChart.send_event("switch_side")

@export_group("Health")
@export var start_health = 100.0

@export_group("Movement")
@export var movement_speed = 200.0

@export_group("Attack")
@export var damage = 10.0
@export var attack_cooldown = 3.0

@onready var playerState = $StateChart/UnitState/Side/Player
@onready var aiState = $StateChart/UnitState/Side/AI

func _ready():
	health.set_max_health(start_health)
	movement.set_movement_speed(movement_speed)
	attack.set_damage(damage)
	attack.set_attack_cooldown(attack_cooldown)
	
	Battle.point_owner_updated.connect(func(_p): _update_target())

func set_side(s: Unit.Side):
	await playerState.state_entered
	if s == Unit.Side.AI:
		$StateChart.send_event("set_ai_side")
	elif s == Unit.Side.PLAYER:
		$StateChart.send_event("set_player_side")

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
