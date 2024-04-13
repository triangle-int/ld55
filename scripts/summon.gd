extends Node

enum State {ARMY, BUFFS}

var state: State = State.ARMY

@export var armys: Array[Stratagem]
@export var buffs: Array[Stratagem]
# @export var debuffs: Array[???]

func _ready():
	StratagemInput.set_stratagems(armys)
	StratagemInput.stratagem_called.connect(_on_called)
	StratagemInput.wrong_combination.connect(_on_wrong_combination)

func _on_called(_s: Stratagem):
	if state == State.ARMY:
		StratagemInput.set_stratagems(buffs)
		state = State.BUFFS
	elif state == State.BUFFS:
		StratagemInput.set_stratagems(armys)
		state = State.ARMY

func _on_wrong_combination():
	print('TODO: Make debuffs')
	# _on_called(null)
