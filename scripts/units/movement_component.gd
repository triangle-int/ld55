class_name MovementComponent

extends Node2D

@export var character_body: CharacterBody2D
@export var navigation_agent: NavigationAgent2D
var movement_speed: float

func _physics_process(delta):
	move_to_target()

func set_movement_speed(speed: float):
	movement_speed = speed

func move_to_target() -> void:
	if navigation_agent.is_navigation_finished():
		return

	var current_position = character_body.global_position
	var next_position = navigation_agent.get_next_path_position()
	
	var new_velocity = current_position.direction_to(next_position) * movement_speed
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = new_velocity
	else:
		_on_velocity_computed(new_velocity)

func set_target(target: Vector2):
	navigation_agent.target_position = target

func _on_velocity_computed(safe_velocity: Vector2):
	character_body.velocity = safe_velocity
	character_body.move_and_slide()
