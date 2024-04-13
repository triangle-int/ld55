class_name Army

extends Stratagem

var units: Array

@export var unit_health: int
@export var unit_count: int
@export var unit_icon: Texture2D
@export var unit_scene: PackedScene

func prepare_units():
	units.resize(unit_count)
	print('TODO: Prepare units')

func start_units():
	print('TODO: Start units')
