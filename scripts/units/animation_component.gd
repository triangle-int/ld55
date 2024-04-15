extends Sprite2D

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum UnitType {
	SMALL,
	MEDIUM,
	LARGE
}

@export var unit_type: UnitType

@export var blue_texture_up: Texture2D
@export var blue_texture_down: Texture2D
@export var blue_texture_left: Texture2D
@export var blue_texture_right: Texture2D

@export var red_texture_up: Texture2D
@export var red_texture_down: Texture2D
@export var red_texture_left: Texture2D
@export var red_texture_right: Texture2D

@export var attack_distance: float
@export var attack_duration: float

@onready var animation_player = $AnimationPlayer

var direction: Direction
var side: Unit.Side

func _on_player_state_entered():
	side = Unit.Side.PLAYER
	update_texture()

func _on_ai_state_entered():
	side = Unit.Side.AI
	update_texture()

func _on_attack(_target: Unit, d: Vector2i):
	update_direction(d)
	update_texture()

	if unit_type == UnitType.SMALL:
		animation_player.play("small_attack")
	elif unit_type == UnitType.MEDIUM:
		animation_player.play("medium_attack")
	elif unit_type == UnitType.LARGE:
		animation_player.play("large_attack")
	
	var tween = create_tween()
	var attack_direction = Vector2(d.x, d.y) * attack_distance
	tween.tween_property(self, "position", attack_direction, attack_duration / 2)
	tween.chain().tween_property(self, "position", Vector2.ZERO, attack_duration / 2)

func _on_unit_movement_ended():
	animation_player.play("idle")

func _on_unit_movement_started(d: Vector2i):
	update_direction(d)
	update_texture()
	if unit_type == UnitType.SMALL:
		animation_player.play("small_walk")
	elif unit_type == UnitType.MEDIUM:
		animation_player.play("medium_walk")
	elif unit_type == UnitType.LARGE:
		animation_player.play("large_walk")

func update_direction(d: Vector2i):
	if d == Vector2i(0, -1):
		direction = Direction.UP
	elif d == Vector2i(0, 1):
		direction = Direction.DOWN
	elif d == Vector2i(-1, 0):
		direction = Direction.LEFT
	elif d == Vector2i(1, 0):
		direction = Direction.RIGHT

func update_texture():
	if side == Unit.Side.PLAYER:
		if direction == Direction.UP:
			texture = blue_texture_up
		elif direction == Direction.DOWN:
			texture = blue_texture_down
		elif direction == Direction.LEFT:
			texture = blue_texture_left
		elif direction == Direction.RIGHT:
			texture = blue_texture_right
	else:
		if direction == Direction.UP:
			texture = red_texture_up
		elif direction == Direction.DOWN:
			texture = red_texture_down
		elif direction == Direction.LEFT:
			texture = red_texture_left
		elif direction == Direction.RIGHT:
			texture = red_texture_right
