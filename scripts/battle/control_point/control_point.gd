class_name ControlPoint

extends Node2D

enum Owner {PLAYER, AI, NONE}

var units: Array[Unit] = []
var balance: float = 0
var curr_owner: ControlPoint.Owner = Owner.NONE

signal owner_updated()

@export var speed: float

func _ready():
	Battle.attach_control_point(self)

func _exit_tree():
	Battle.detach_control_point(self)

func _process(delta: float):
	var player_count = len(units.filter(
		func(u): return u.side == Unit.Side.PLAYER
	))
	var ai_count = len(units.filter(
		func(u): return u.side == Unit.Side.AI
	))

	if ai_count + player_count == 0:
		return

	var multiplier = (player_count / float(ai_count + player_count)) * 2 - 1
	balance += delta * multiplier * speed
	balance = clamp(balance, -1, 1)

	var new_owner = Owner.PLAYER if balance >= 1 else (Owner.AI if balance <= -1 else Owner.NONE)
	
	if new_owner != curr_owner:
		curr_owner = new_owner
		owner_updated.emit()

func _on_area_2d_body_entered(body: Node2D):
	if not (body is Unit):
		return

	units.push_back(body)

func _on_area_2d_body_exited(body: Node2D):
	units.erase(body)
