extends NinePatchRect

@export var combination_view: CombinationView

func _ready():
	StratagemInput.combination_updated.connect(update_combination)

func update_combination(combination: Array[Stratagem.PathPart]):
	combination_view.set_combination(combination)
