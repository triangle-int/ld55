class_name Unit

extends Node2D

enum Side {PLAYER, AI}

var side: Unit.Side

@export var movement: MovementComponent
@export var health: HealthComponent
@export var sight: SightRangeComponent

func _on_player_state_entered():
	side = Side.PLAYER

func _on_ai_state_entered():
	side = Side.AI
