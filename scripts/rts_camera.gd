extends Camera2D

@export var edge_detection_range: float = 80
@export var move_speed: float = 1000
@export var zoom_speed: float = 0.1

@export var max_zoom: float = 2
@export var min_zoom: float = 0.5

func _process(delta):
	var rect = get_viewport().get_visible_rect()
	var mouse_pos = get_viewport().get_mouse_position()
	
	var velocity = Vector2.ZERO
	if rect.size.x - mouse_pos.x <= edge_detection_range:
		velocity.x += 1
	if mouse_pos.x <= edge_detection_range:
		velocity.x -= 1
	if rect.size.y - mouse_pos.y <= edge_detection_range:
		velocity.y += 1
	if mouse_pos.y <= edge_detection_range:
		velocity.y -= 1
	
	position += velocity.normalized() * move_speed * delta

func _input(event):
	if event is InputEventPanGesture:
		var zoom_strength = event.delta.y
		add_zoom_with_limits(zoom_speed * -zoom_strength)
	if event is InputEventMouseButton:
		print(event.button_index)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			print("zoom in")
			add_zoom_with_limits(zoom_speed)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			print("zoom out")
			add_zoom_with_limits(zoom_speed)

func add_zoom_with_limits(z: float):	
	zoom.x += z
	zoom.y += z
	
	if zoom.x > max_zoom:
		zoom.x = max_zoom
		zoom.y = max_zoom
	if zoom.x < min_zoom:
		zoom.x = min_zoom
		zoom.y = min_zoom
