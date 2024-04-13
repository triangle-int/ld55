extends Node

@export var min_cooldown: float
@export var max_cooldown: float
@export var armys: Array[Army]
@export var buffs: Array[Buff]

var cooldown: float = 0

func _process(delta):
	cooldown -= delta

	if cooldown > 0:
		return

	cooldown = randf_range(min_cooldown, max_cooldown)
	var army = pick_army()
	var selected_buffs = pick_buffs()
	print('TODO: Actual summon')
	print('Summoning army %s with buffs:' % army.name)
	print(' '.join(selected_buffs.map(func(b): return b.name)))

func pick_army() -> Army:
	return armys.pick_random()

func pick_buffs() -> Array[Buff]:
	var count = randi_range(0, len(buffs))
	var shuffled = buffs.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)
