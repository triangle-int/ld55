class_name PlayerSummonClass
extends Node

signal state_updated(state: State)
signal stratagems_updated(stratagems: Array[Stratagem])

signal army_position_updated(pos: Vector2)
signal army_visability_changed(visible: bool)
signal army_buff_applied(buff: Buff)
signal army_prepared(army: Army)
signal army_deployed()

enum State {ARMY, BUFFS, AWAIT_POSITION}

var state: State = State.ARMY
var army: Army = null
var army_visible := false
var army_position: Vector2
var obstacle_on_spawn := false
var whitelisted_buffs: Array[Stratagem]
var applied_buffs: Array[Stratagem]

@export var armys: Array[Stratagem]
@export var buffs: Array[Stratagem]
@export var debuffs: Array[Stratagem]

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
	army_buff_applied.emit(buff)
	_update_statagems()

func _on_wrong_combination():
	if state != State.Army:
		army_buff_applied.emit(debuffs.pick_random())

	if army != null:
		_set_state(State.AWAIT_POSITION)
	else:
		_set_state(State.ARMY)

func _set_state(new_state: State):
	state = new_state
	
	if state == State.ARMY:
		army = null
		army_visible = false
		applied_buffs = []
	elif state == State.BUFFS:
		whitelisted_buffs = buffs.duplicate()
		army_visible = true
		army_prepared.emit(army)
	
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

func deploy_army():
	if obstacle_on_spawn:
		return
	
	if army != null:
		army_deployed.emit()
		_set_state(State.ARMY)

func show_army():
	if not army_visible:
		army_visible = true
		army_visability_changed.emit(army_visible)

func hide_army():
	if army_visible:
		army_visible = false
		army_visability_changed.emit(army_visible)

func update_army_position(pos: Vector2):
	if army != null:
		army_position = pos
		army_position_updated.emit(pos)
