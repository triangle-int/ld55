extends CanvasItem

func _ready():
	Battle.battle_ended.connect(_on_battle_ended)

func _on_battle_ended(_s: Unit.Side):
	visible = true
