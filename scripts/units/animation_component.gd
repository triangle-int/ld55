extends Sprite2D

@export var blue_texture: Texture2D
@export var red_texture: Texture2D

@onready var animation_player = $AnimationPlayer

func _on_player_state_entered():
	texture = blue_texture

func _on_ai_state_entered():
	texture = red_texture

func _on_attack(target):
	pass
