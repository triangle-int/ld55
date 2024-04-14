class_name Unit

extends Node2D

enum Side {PLAYER, AI}

var _path_id: int = -1

var side: Unit.Side
var target_point: Vector2

@export var health: HealthComponent
@export var attack: AttackComponent
@export var sight: SightRangeComponent
@export var buff: BuffContainer

@export_group("Health")
@export var start_health = 100.0

@export_group("Attack")
@export var damage = 10.0
@export var attack_cooldown = 3.0

@onready var playerState = $StateChart/UnitState/Side/Player
@onready var aiState = $StateChart/UnitState/Side/AI
@onready var capturingState = $StateChart/UnitState/Action/Capturing
@onready var timer = $WalkingTimer

func switch_side():
	$StateChart.send_event("switch_side")

func _ready():
	health.set_max_health(start_health)
	attack.set_damage(damage)
	attack.set_attack_cooldown(attack_cooldown)

	Battle.point_owner_updated.connect(func(_p): _update_target())
	PathFinding.path_found.connect(_on_path_found)
	timer.timeout.connect(_on_walking_timer_timeout)

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
	_update_target()

func _update_target():
	if not capturingState.active:
		return

	target_point = Battle.find_nearest_point(
		global_position,
		ControlPoint.Owner.PLAYER
		if side == Side.PLAYER
		else ControlPoint.Owner.AI
	).global_position

func _on_path_found(id: int, next_point: Vector2):
	if id != _path_id:
		return

	_path_id = -1
	PathFinding.deoccopy(global_position)
	global_position = next_point
	PathFinding.occupy(global_position)

func _on_walking_timer_timeout():
	if _path_id != -1:
		return

	_path_id = PathFinding.enqueue_path(global_position, target_point)
