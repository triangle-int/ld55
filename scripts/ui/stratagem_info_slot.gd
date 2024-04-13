extends NinePatchRect

@export var icon: TextureRect
@export var label: Label
@export var combination_view: CombinationView

func set_stratagem(stratagem: Stratagem):
	icon.texture = stratagem.icon
	label.text = stratagem.name
	combination_view.set_combination(stratagem.call_path)
