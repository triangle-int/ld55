class_name BuffContainer

extends Node

var _buffs: Array[Buff] = []

@export var unit: Unit

func _ready():
	unit.attack.on_attack.connect(_on_attack)

func attach_buff(buff: Buff):
	_buffs.push_back(buff)
	buff.on_apply(unit)

func remove_buff(buff: Buff):
	_buffs.erase(buff)

func modify_damage(damage: float) -> float:
	for buff in _buffs.duplicate():
		damage = buff.modify_damage(damage)

	return damage

func _on_attack(target: Unit, direction: Vector2i):
	for buff in _buffs.duplicate():
		buff.on_attack(unit, target)
