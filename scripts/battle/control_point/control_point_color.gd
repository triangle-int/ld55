extends Node2D

@export var control_point: ControlPoint
@export var start_position: Vector2 = Vector2(0, 40)
@export var end_position: Vector2 = Vector2(0, 0)

@onready var white_sprite = $WhiteSprite
@onready var blue_sprite = $BlueSprite
@onready var red_sprite = $RedSprite
@onready var animation_player = $AnimationPlayer

var current_sprite: Node2D

func _ready():
	owner_updated()
	control_point.owner_updated.connect(owner_updated)

func _process(_delta: float):
	var weight = absf(control_point.balance)
	var new_position = start_position.lerp(end_position, weight)
	current_sprite.position = new_position

func owner_updated():
	white_sprite.visible = false
	blue_sprite.visible = false
	red_sprite.visible = false
	
	var owner = control_point.curr_owner
	if owner == ControlPoint.Owner.NONE:
		current_sprite = white_sprite
	elif owner == ControlPoint.Owner.PLAYER:
		current_sprite = blue_sprite
	elif owner == ControlPoint.Owner.AI:
		current_sprite = red_sprite
	
	current_sprite.visible = true
	animation_player.play("start")
	await animation_player.animation_finished
	animation_player.play("idle")
