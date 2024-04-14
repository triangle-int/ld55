extends Node

var _start_pos: Vector2
var _is_selecting: bool

signal rect_selected(rect: Rect2)
signal unit_target(point: Vector2i)

@export var selection_panel: Panel
@export var area: Area2D
@export var shape: CollisionShape2D

func _process(_delta: float):
	if Input.is_action_just_pressed("unit_order"):
		var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
		unit_target.emit(PathFinding.to_id(mouse_pos))

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
	_start_pos = get_viewport().get_camera_2d().get_global_mouse_position()

	selection_panel.position = _start_pos
	selection_panel.size = Vector2.ZERO
	selection_panel.visible = true

func stop_selecting():
	_is_selecting = false
	selection_panel.visible = false
	rect_selected.emit(_get_current_rect())

func _draw_selection():
	var rect = _get_current_rect()
	selection_panel.global_position = rect.position
	selection_panel.size = rect.size

func _get_current_rect() -> Rect2:
	var current_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	var top_left = Vector2(
		min(current_pos.x, _start_pos.x),
		min(current_pos.y, _start_pos.y),
	)
	var size = Vector2(
		abs(current_pos.x - _start_pos.x),
		abs(current_pos.y - _start_pos.y),
	)
	return Rect2(top_left, size)
