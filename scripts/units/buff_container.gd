class_name BuffContainer

extends Node

var _buffs: Array[Buff] = []

@export var unit: Unit
@export var views: Array[Sprite2D]

func _ready():
	unit.attack.on_attack.connect(_on_attack)

func attach_buff(buff: Buff):
	_buffs.push_back(buff)
	_on_buffs_updated()
	buff.on_apply(unit)

func remove_buff(buff: Buff):
	_buffs.erase(buff)
	_on_buffs_updated()

func modify_damage(damage: float) -> float:
	for buff in _buffs.duplicate():
		damage = buff.modify_damage(unit, damage)

	return damage

func _on_attack(target: Unit, _direction: Vector2i):
	for buff in _buffs.duplicate():
		buff.on_attack(unit, target)

func _on_buffs_updated():
	for index in range(len(views)):
		if index >= len(_buffs):
			views[index].visible = false
			continue

		views[index].visible = true
		views[index].texture = _buffs[index].icon
