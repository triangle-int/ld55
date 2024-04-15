class_name Unit

extends Node2D

enum Side {PLAYER, AI}

signal movement_started(direction: Vector2i)
signal movement_ended

var _path_id: int = -1
var _selected: bool = false

var side: Unit.Side
var target_point: Vector2i
var position_point: Vector2i
var stunned: bool = false

@export var health: HealthComponent
@export var attack: AttackComponent
@export var sight: SightRangeComponent
@export var buff: BuffContainer
@export var selection: Sprite2D

@export_group("Health")
@export var start_health = 100.0

@export_group("Attack")
@export var damage = 10.0
@export var attack_cooldown = 3.0

@export_group("Movement")
@export var tween_time: float
@export var max_delay: float
@export var min_delay: float

@onready var player_state := $StateChart/Side/Player
@onready var capturing_state := $StateChart/Side/AI/Capturing
@onready var timer := $WalkingTimer
@onready var state_chart := $StateChart

func _ready():
	position_point = PathFinding.to_id(global_position)
	target_point = position_point
	global_position = PathFinding.to_pos(position_point)
	PathFinding.occupy(position_point)

	health.set_max_health(start_health)
	attack.damage = damage
	attack.attack_cooldown = attack_cooldown

	Battle.point_owner_updated.connect(func(_p): _update_target())
	PathFinding.path_found.connect(_on_path_found)

	timer.wait_time = randf_range(min_delay, max_delay)
	timer.timeout.connect(_on_walking_timer_timeout)
	timer.start()

	UnitsSelector.rect_selected.connect(_on_rect_selected)
	UnitsSelector.unit_target.connect(_on_target_selected)

func _select():
	_selected = true
	selection.visible = true

func _deselect():
	_selected = false
	selection.visible = false

func switch_side():
	_deselect()

	if side == Unit.Side.PLAYER:
		state_chart.send_event("set_ai_side")
	elif side == Unit.Side.AI:
		state_chart.send_event("set_player_side")

func set_side(s: Unit.Side):
	await player_state.state_entered

	if s == Unit.Side.AI:
		state_chart.send_event("set_ai_side")
	elif s == Unit.Side.PLAYER:
		state_chart.send_event("set_player_side")

func _on_target_selected(target: Vector2i):
	if !_selected:
		return

	state_chart.send_event("target_set")
	target_point = target

func _on_rect_selected(rect: Rect2):
	if side != Side.PLAYER or not rect.has_point(global_position):
		_deselect()
		return

	_select()

func _on_player_state_entered():
	side = Side.PLAYER

func _on_ai_state_entered():
	side = Side.AI

func _on_capturing_state_entered():
	_update_target()

func _update_target():
	if not capturing_state.active:
		return

	target_point = PathFinding.to_id(
		Battle.find_nearest_point(
			global_position,
			ControlPoint.Owner.PLAYER
			if side == Side.PLAYER
			else ControlPoint.Owner.AI,
		).global_position
	)

func _on_path_found(id: int, next_point: Vector2i):
	if id != _path_id:
		return

	_path_id = -1

	if stunned:
		return

	if next_point == position_point:
		state_chart.send_event("target_reached")
		return

	var direction = next_point - position_point
	movement_started.emit(direction)

	PathFinding.deoccupy(position_point)
	position_point = next_point
	PathFinding.occupy(position_point)

	var tween = create_tween()
	tween.tween_property(
		self,
		"global_position",
		PathFinding.to_pos(position_point),
		tween_time,
	)
	tween.chain().tween_callback(func(): movement_ended.emit())

func _on_walking_timer_timeout():
	if _path_id != -1:
		return

	_path_id = PathFinding.enqueue_path(
		position_point,
		target_point,
	)

func _exit_tree():
	PathFinding.path_found.disconnect(_on_path_found)
	PathFinding.deoccupy(position_point)
