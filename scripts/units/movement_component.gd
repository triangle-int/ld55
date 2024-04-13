class_name MovementComponent

extends Node2D

@export var character_body: CharacterBody2D
@export var navigation_agent: NavigationAgent2D
@export var movement_speed = 100.0

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			set_target(get_global_mouse_position())

func _process(_delta):
	move_to_target()

func move_to_target() -> void:
	if navigation_agent.is_navigation_finished():
		return

	var current_position = character_body.position
	var next_position = navigation_agent.get_next_path_position()

	character_body.velocity = current_position.direction_to(next_position) * movement_speed
	character_body.move_and_slide()

func set_target(target: Vector2):
	navigation_agent.target_position = target