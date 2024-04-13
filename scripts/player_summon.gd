extends Node

signal state_updated(state: State)
signal stratagems_updated(stratagems: Array[Stratagem])

signal army_summoned(army: Army, buffs: Array[Stratagem], position: Vector2)

enum State {ARMY, BUFFS, AWAIT_POSITION}

var state: State = State.ARMY
var army: Army = null
var whitelisted_buffs: Array[Stratagem]
var applied_buffs: Array[Stratagem]

@export var armys: Array[Stratagem]
@export var buffs: Array[Stratagem]

func _ready():
	StratagemInput.set_stratagems(armys)
	StratagemInput.stratagem_called.connect(_on_called)
	StratagemInput.wrong_combination.connect(_on_wrong_combination)

func _on_called(stratagem: Stratagem):
	if state == State.ARMY:
		army = stratagem as Army
		_set_state(State.BUFFS)
		return

	var buff = stratagem as Buff
	whitelisted_buffs.erase(buff)
	applied_buffs.append(buff)
	_update_statagems()

func _on_wrong_combination():
	print('TODO: Make debuffs')
	if army != null:
		_set_state(State.AWAIT_POSITION)
	_set_state(State.ARMY)

func _set_state(new_state: State):
	state = new_state
	
	if state == State.ARMY:
		army = null
		applied_buffs = []
	elif state == State.BUFFS:
		whitelisted_buffs = buffs.duplicate()
	
	_update_statagems()
	state_updated.emit(state)

func _update_statagems():
	var stratagems = get_stratagems()
	
	stratagems_updated.emit(stratagems)
	StratagemInput.set_stratagems(stratagems)

func get_stratagems() -> Array[Stratagem]:
	if state == State.ARMY:
		return armys
	elif state == State.BUFFS:
		return whitelisted_buffs
	elif state == State.AWAIT_POSITION:
		return []
	return []

func summon_at_position(position: Vector2):
	if army != null:
		army_summoned.emit(army, applied_buffs, position)
		_set_state(State.ARMY)
