class_name BuffContainer

extends Node

@export var unit: Unit

var _buffs: Array[Buff] = []

func _ready():
	unit.attack.on_attack.connect(_on_attack)

func attach_buff(buff: Buff):
	_buffs.push_back(buff)
	buff.on_apply(unit)

func remove_buff(buff: Buff):
	_buffs.erase(buff)

func _on_attack(target: Unit):
	for buff in _buffs:
		buff.on_attack(unit, target)
