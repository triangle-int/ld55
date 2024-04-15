extends CanvasItem

@export var label: Label
@export var next_level_button: Button

func _ready():
	visible = false
	Battle.battle_ended.connect(_on_battle_ended)
	next_level_button.pressed.connect(func():
		LevelLoder.load_scene(
			ProgressManager.get_next_level(LevelLoder.get_current_level())
		)
	)

func _on_battle_ended(s: Unit.Side):
	visible = true

	if s == Unit.Side.PLAYER:
		label.text = "You Won"
		next_level_button.disabled = false
	else:
		label.text = "You Lost"
		next_level_button.disabled = true
