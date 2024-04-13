extends Node

signal stratagems_updated(stratagems: Array[Stratagem])

enum State {ARMY, BUFFS}

var state: State = State.ARMY
var army: Army = null

@export var armys: Array[Stratagem]
@export var buffs: Array[Stratagem]
# @export var debuffs: Array[???]

func _ready():
	StratagemInput.set_stratagems(armys)
	StratagemInput.stratagem_called.connect(_on_called)
	StratagemInput.wrong_combination.connect(_on_wrong_combination)

func _on_called(stratagem: Stratagem):
	if state == State.ARMY:
		army = stratagem as Army
		army.prepare_units()
		_set_state(State.BUFFS)
		return

	var buff = stratagem as Buff
	buff.apply_buff(army)
	army.start_units()
	_set_state(State.ARMY)

func _on_wrong_combination():
	print('TODO: Make debuffs')
	_set_state(State.ARMY)

func _set_state(new_state: State):
	state = new_state
	
	var stratagems = get_stratagems()
	
	stratagems_updated.emit(stratagems)
	StratagemInput.set_stratagems(stratagems)

func get_stratagems() -> Array[Stratagem]:
	if state == State.ARMY:
		return armys
	elif state == State.BUFFS:
		return buffs
	return []
