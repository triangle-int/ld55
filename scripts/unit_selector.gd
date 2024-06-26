extends Node

var _start_pos: Vector2
var _is_selecting: bool

signal rect_selected(rect: Rect2)
signal unit_target(point: Vector2i)

@export var selection_panel: Panel
@export var cursor: Sprite2D

func _ready():
	Battle.battle_ended.connect(func(_s):
		cursor.visible = false
		selection_panel.visible = false
	)

func _process(_delta: float):
	if not Battle.get_battle_started():
		return

	if Input.is_action_just_pressed("unit_order"):
		var mouse_pos = _get_mouse_position()
		var target_id = PathFinding.to_id(mouse_pos)
		unit_target.emit(target_id)
		cursor.global_position = PathFinding.to_pos(target_id)
		cursor.visible = true

	if Input.is_action_just_pressed("unit_select_start"):
		start_selecting()
		return

	if Input.is_action_just_released("unit_select_start"):
		stop_selecting()
		return

	if not _is_selecting:
		return

	_draw_selection()

func start_selecting():
	_is_selecting = true
	_start_pos = _get_mouse_position()

	selection_panel.position = _start_pos
	selection_panel.size = Vector2.ZERO
	selection_panel.visible = true

func stop_selecting():
	_is_selecting = false
	selection_panel.visible = false
	cursor.visible = false
	rect_selected.emit(_get_current_rect())

func _draw_selection():
	var rect = _get_current_rect()
	selection_panel.global_position = rect.position
	selection_panel.size = rect.size

func _get_current_rect() -> Rect2:
	var current_pos = _get_mouse_position()
	var top_left = Vector2(
		min(current_pos.x, _start_pos.x),
		min(current_pos.y, _start_pos.y),
	)
	var size = Vector2(
		abs(current_pos.x - _start_pos.x),
		abs(current_pos.y - _start_pos.y),
	)
	return Rect2(top_left, size)

func _get_mouse_position() -> Vector2:
	var camera = get_viewport().get_camera_2d()

	if camera == null:
		return Vector2.ZERO

	return camera.get_global_mouse_position()
